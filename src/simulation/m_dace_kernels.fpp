!! @brief Contains module m_dace_kernels
!!
!! P2/T2.3 — the MFC_DACE integration shim: ISO_C_BINDING bindings for the
!! DaCe-compiled production kernel libraries (pipeline/mfc_dace/lib*.so,
!! built by scripts/mfc_dace_build.py) plus the MFC-field marshaling.
!!
!! The kernel libraries are device-resident: field arguments are CUDA device
!! pointers, scalars cross by value, and the case configuration (plain 3-D
!! 5-eq 2-fluid) is baked at kernel-build time.  This module owns the MFC
!! side: it packs MFC's struct-of-arrays fields (scalar_field %sf(-buff:m+buff))
!! into the kernel's flat (eqn-fastest, 1-based flat = raw + buff + 1) device
!! buffers, runs the kernel, and unpacks the outputs.
!!
!! Staging today is host memcpy (works for both CPU and OpenACC builds); the
!! device-resident pack kernel replaces the copies in the follow-up (the
!! T1.3 staging-cost measurement bounds that win).
#if defined(MFC_DACE)
module m_dace_kernels
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, &
                                         c_double, c_associated, c_loc, &
                                         c_f_pointer, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_fd_gradient, s_dace_finalize

#if defined(MFC_DACE)
  ! buff_size the production kernel library was baked with (scripts/
  ! mfc_dace_build.py MFC_DACE_BUFF); the CMake MFC_DACE block passes it
#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 2
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF
  ! ------------------------------------------------------------------ !
  ! CUDA runtime (cudart) — linked by CMake when MFC_DACE is on         !
  ! ------------------------------------------------------------------ !
  interface
    function cudaMalloc_(p, size) bind(C, name='cudaMalloc')
      import :: c_ptr, c_size_t, c_int
      integer(c_int) :: cudaMalloc_
      type(c_ptr) :: p
      integer(c_size_t), value :: size
    end function
    function cudaFree_(p) bind(C, name='cudaFree')
      import :: c_ptr, c_int
      integer(c_int) :: cudaFree_
      type(c_ptr), value :: p
    end function
    function cudaMemcpy_(dst, src, count, kind) bind(C, name='cudaMemcpy')
      import :: c_ptr, c_size_t, c_int
      integer(c_int) :: cudaMemcpy_
      type(c_ptr), value :: dst, src
      integer(c_size_t), value :: count
      integer(c_int), value :: kind
    end function
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function
  end interface

  integer(c_int), parameter :: cpH2D = 1_c_int
  integer(c_int), parameter :: cpD2H = 2_c_int

  ! ------------------------------------------------------------------ !
  ! libmfc_dace_fdiff.so: kernel(state, <ptrs>, <extents>, <bounds>,     !
  ! nvars) — see pipeline/mfc_dace/mfc_dace_fdiff.args (generated).      !
  ! ------------------------------------------------------------------ !
  interface
    subroutine mfc_dace_fdiff_run(state, grad_x, grad_y, grad_z, var, &
                                  x_cc, y_cc, z_cc, &
                                  grad_x_d0, grad_x_d1, grad_x_d2, &
                                  grad_y_d0, grad_y_d1, grad_y_d2, &
                                  grad_z_d0, grad_z_d1, grad_z_d2, &
                                  jb, je, kb, ke, lb, le, nvars, &
                                  var_d0, var_d1, var_d2) &
        bind(C, name='__program_mfc_dace_fdiff')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: grad_x, grad_y, grad_z, var, x_cc, y_cc, z_cc
      integer(c_int64_t), value :: grad_x_d0, grad_x_d1, grad_x_d2
      integer(c_int64_t), value :: grad_y_d0, grad_y_d1, grad_y_d2
      integer(c_int64_t), value :: grad_z_d0, grad_z_d1, grad_z_d2
      integer(c_int), value :: jb, je, kb, ke, lb, le, nvars
      integer(c_int64_t), value :: var_d0, var_d1, var_d2
    end subroutine

    function mfc_dace_fdiff_init(grad_x_d0, grad_x_d1, grad_x_d2, &
                                 grad_y_d0, grad_y_d1, grad_y_d2, &
                                 grad_z_d0, grad_z_d1, grad_z_d2, &
                                 jb, je, kb, ke, lb, le, nvars, &
                                 var_d0, var_d1, var_d2) &
        bind(C, name='__dace_init_mfc_dace_fdiff')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: mfc_dace_fdiff_init
      integer(c_int64_t), value :: grad_x_d0, grad_x_d1, grad_x_d2
      integer(c_int64_t), value :: grad_y_d0, grad_y_d1, grad_y_d2
      integer(c_int64_t), value :: grad_z_d0, grad_z_d1, grad_z_d2
      integer(c_int), value :: jb, je, kb, ke, lb, le, nvars
      integer(c_int64_t), value :: var_d0, var_d1, var_d2
    end function

    function mfc_dace_fdiff_exit(state) bind(C, name='__dace_exit_mfc_dace_fdiff')
      import :: c_ptr, c_int
      integer(c_int) :: mfc_dace_fdiff_exit
      type(c_ptr), value :: state
    end function
  end interface

  ! Cached device buffers (grown on demand; reused across calls)
  type(c_ptr), save :: d_var = c_null_ptr, d_gx = c_null_ptr
  type(c_ptr), save :: d_gy = c_null_ptr, d_gz = c_null_ptr
  type(c_ptr), save :: d_x = c_null_ptr, d_y = c_null_ptr, d_z = c_null_ptr
  integer(c_size_t), save :: cap_f = 0_c_size_t, cap_c = 0_c_size_t
  type(c_ptr), save :: state_fdiff = c_null_ptr
  integer, save :: state_ext = -1, state_nvars = -1
  real(c_double), allocatable, target, save :: xbuf(:), ybuf(:), zbuf(:)

contains

  subroutine chk(ierr, what)
    integer(c_int), intent(in) :: ierr
    character(*), intent(in) :: what
    if (ierr /= 0_c_int) then
      print *, 'm_dace_kernels: CUDA error in ', what, ': code=', ierr
      error stop 1
    end if
  end subroutine chk

  subroutine ensure_buf(p, cap, want, what)
    ! Grow-on-demand keyed on the POINTER (not a shared cap: buffers of one
    ! class share the cap variable, so only the first was ever allocated —
    ! the rest stayed c_null_ptr and the kernel faulted on null bases)
    type(c_ptr), intent(inout) :: p
    integer(c_size_t), intent(inout) :: cap
    integer(c_size_t), intent(in) :: want
    character(*), intent(in) :: what
    integer(c_int) :: ierr
    if (.not. c_associated(p) .or. cap < want) then
      if (c_associated(p)) then
        ierr = cudaFree_(p); call chk(ierr, 'free '//what)
      end if
      ierr = cudaMalloc_(p, want); call chk(ierr, 'malloc '//what)
      cap = want
    end if
  end subroutine ensure_buf

  !> Fused central-difference gradient kernel (the DaCe build of the three
  !! interior loops of s_compute_fd_gradient, fused over fields).  Fields:
  !! q_prim_qp%vf(1:nvars) in, the three gradient fields out.  Flat layout:
  !! 1-based flat position = raw %sf subscript + buff_size + 1 (buff_size=2
  !! is baked into the kernel; the raw allocation is (-buff_size:m+buff_size)).
  subroutine s_dace_fd_gradient(q_prim_vf, grad_x_vf, grad_y_vf, grad_z_vf, &
                                nvars_in)
    type(scalar_field), dimension(:), intent(in) :: q_prim_vf
    type(scalar_field), dimension(:), intent(inout) :: grad_x_vf, grad_y_vf, &
                                                      grad_z_vf
    integer, intent(in) :: nvars_in

    real(c_double), pointer :: d_var_f(:), d_gx_f(:), d_gy_f(:), d_gz_f(:)
    integer :: ext, s, e, k, l, i, jb, je, nvars
    integer :: lin
    integer(c_size_t) :: bytes_f, bytes_c
    integer(c_int) :: ierr
    integer(c_int64_t) :: e64

    nvars = nvars_in
    ext = size(q_prim_vf(1)%sf, 1)     ! = m + 2*buff_size + 1
    if (buff_size /= BAKED_BUFF_SIZE) then
      print *, 'm_dace_kernels: fdiff kernel baked with buff_size=', &
               BAKED_BUFF_SIZE, ' but case uses', buff_size, &
               ' (rebuild with MFC_DACE_BUFF=<case buff_size>)'
      error stop 1
    end if

    ! P2/T2.3 DEVICE-RESIDENT STAGING: q_prim and the grad fields are
    ! declare-create'd (device-resident in the OpenACC build) — the
    ! (j,k,l,eqn)->(eqn,j,k,l) transposes run ON DEVICE via acc kernels;
    ! no host staging of the field data.
    ! coordinates: cell centers at flat position f = raw + buff_size (0-based)
    if (.not. allocated(xbuf) .or. size(xbuf) < ext) then
      if (allocated(xbuf)) deallocate (xbuf, ybuf, zbuf)
      allocate(xbuf(ext), ybuf(ext), zbuf(ext))
      do i = 1, ext
        xbuf(i) = real(x_cc(i - buff_size), c_double)
        ybuf(i) = real(y_cc(i - buff_size), c_double)
        zbuf(i) = real(z_cc(i - buff_size), c_double)
      end do
    end if

    bytes_f = int(nvars*ext**3*8, c_size_t)
    bytes_c = int(ext*8, c_size_t)
    call ensure_buf(d_var, cap_f, bytes_f, 'var')
    call ensure_buf(d_gx, cap_f, bytes_f, 'gx')
    call ensure_buf(d_gy, cap_f, bytes_f, 'gy')
    call ensure_buf(d_gz, cap_f, bytes_f, 'gz')
    call ensure_buf(d_x, cap_c, bytes_c, 'x_cc')
    call ensure_buf(d_y, cap_c, bytes_c, 'y_cc')
    call ensure_buf(d_z, cap_c, bytes_c, 'z_cc')

    call c_f_pointer(d_var, d_var_f, [nvars*ext**3])
    !$acc parallel loop collapse(4) deviceptr(d_var_f)
    do l = 1, ext
      do k = 1, ext
        do s = 1, ext
          do e = 1, nvars
            d_var_f((e - 1) + nvars*((s - 1) + ext*((k - 1) + ext*(l - 1))) + 1) = &
                q_prim_vf(e)%sf(s - buff_size - 1, k - buff_size - 1, &
                                l - buff_size - 1)
          end do
        end do
      end do
    end do
    !$acc end parallel loop
    ierr = cudaDeviceSynchronize_(); call chk(ierr, 'sync pack')
    ierr = cudaMemcpy_(d_x, c_loc(xbuf), bytes_c, cpH2D)
    ierr = cudaMemcpy_(d_y, c_loc(ybuf), bytes_c, cpH2D)
    ierr = cudaMemcpy_(d_z, c_loc(zbuf), bytes_c, cpH2D)

    jb = 1; je = ext - 2     ! flat interior loop range (raw 1-buff:m+buff-1)
    e64 = int(ext, c_int64_t)

    if (state_ext /= ext .or. state_nvars /= nvars) then
      if (c_associated(state_fdiff)) then
        ierr = mfc_dace_fdiff_exit(state_fdiff)
      end if
      state_fdiff = mfc_dace_fdiff_init( &
                    int(nvars, c_int64_t), e64, e64, &
                    int(nvars, c_int64_t), e64, e64, &
                    int(nvars, c_int64_t), e64, e64, &
                    int(jb, c_int), int(je, c_int), &
                    int(jb, c_int), int(je, c_int), &
                    int(jb, c_int), int(je, c_int), &
                    int(nvars, c_int), &
                    int(nvars, c_int64_t), e64, e64)
      state_ext = ext; state_nvars = nvars
    end if

    call mfc_dace_fdiff_run(state_fdiff, d_gx, d_gy, d_gz, d_var, d_x, d_y, &
                            d_z, &
                            int(nvars, c_int64_t), e64, e64, &
                            int(nvars, c_int64_t), e64, e64, &
                            int(nvars, c_int64_t), e64, e64, &
                            int(jb, c_int), int(je, c_int), &
                            int(jb, c_int), int(je, c_int), &
                            int(jb, c_int), int(je, c_int), &
                            int(nvars, c_int), &
                            int(nvars, c_int64_t), e64, e64)
    ! (lib stream-syncs internally; unpack is acc-stream-ordered)

    ! unpack ON DEVICE: the kernel writes flat [1, ext-2]^3 per eqn; the
    ! ghosts keep the caller's values (the interior-only guard stays)
    call c_f_pointer(d_gx, d_gx_f, [nvars*ext**3])
    call c_f_pointer(d_gy, d_gy_f, [nvars*ext**3])
    call c_f_pointer(d_gz, d_gz_f, [nvars*ext**3])
    !$acc parallel loop collapse(4) deviceptr(d_gx_f, d_gy_f, d_gz_f)
    do l = 1, ext
      do k = 1, ext
        do s = 1, ext
          do e = 1, nvars
            lin = (e - 1) + nvars*((s - 1) + ext*((k - 1) + ext*(l - 1))) + 1
            if (s >= 2 .and. s <= ext - 1 .and. k >= 2 .and. k <= ext - 1 &
                .and. l >= 2 .and. l <= ext - 1) then
              grad_x_vf(e)%sf(s - buff_size - 1, k - buff_size - 1, &
                              l - buff_size - 1) = d_gx_f(lin)
              grad_y_vf(e)%sf(s - buff_size - 1, k - buff_size - 1, &
                              l - buff_size - 1) = d_gy_f(lin)
              grad_z_vf(e)%sf(s - buff_size - 1, k - buff_size - 1, &
                              l - buff_size - 1) = d_gz_f(lin)
            end if
          end do
        end do
      end do
    end do
    !$acc end parallel loop
    ! (no post-unpack sync: the next consumer is acc-stream-ordered)
  end subroutine s_dace_fd_gradient

  !> Release the cached device buffers and kernel state
  subroutine s_dace_finalize()
    integer(c_int) :: ierr
    if (c_associated(state_fdiff)) ierr = mfc_dace_fdiff_exit(state_fdiff)
    if (c_associated(d_var)) ierr = cudaFree_(d_var)
    if (c_associated(d_gx)) ierr = cudaFree_(d_gx)
    if (c_associated(d_gy)) ierr = cudaFree_(d_gy)
    if (c_associated(d_gz)) ierr = cudaFree_(d_gz)
    if (c_associated(d_x)) ierr = cudaFree_(d_x)
    if (c_associated(d_y)) ierr = cudaFree_(d_y)
    if (c_associated(d_z)) ierr = cudaFree_(d_z)
    state_fdiff = c_null_ptr
    d_var = c_null_ptr; d_gx = c_null_ptr; d_gy = c_null_ptr; d_gz = c_null_ptr
    d_x = c_null_ptr; d_y = c_null_ptr; d_z = c_null_ptr
    cap_f = 0_c_size_t; cap_c = 0_c_size_t
  end subroutine s_dace_finalize
#else
contains
  !> MFC_DACE=OFF: the DaCe kernel libraries are not linked and the
  !! dispatch sites are compiled out; reaching this stub is a build bug.
  subroutine s_dace_fd_gradient(q_prim_vf, grad_x_vf, grad_y_vf, grad_z_vf, &
                                nvars_in)
    use m_derived_types
    type(scalar_field), dimension(:), intent(in) :: q_prim_vf
    type(scalar_field), dimension(:), intent(inout) :: grad_x_vf, grad_y_vf, &
                                                        grad_z_vf
    integer, intent(in) :: nvars_in
    print *, 'm_dace_kernels: s_dace_fd_gradient reached with MFC_DACE=OFF'
    error stop 1
  end subroutine s_dace_fd_gradient

  subroutine s_dace_finalize()
  end subroutine s_dace_finalize
#endif

end module m_dace_kernels

#endif