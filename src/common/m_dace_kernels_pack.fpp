!! @brief P2/T2.3 — the halo-pack dispatch shim (libmfc_dace_pack.so).
!!
!! The kernel is the casopt-baked build of the m_mpi_common dir-1 plain pack
!! loop (pack_mod::pack_buffers, T2.2-validated TU): buff_size baked (the
!! MFC_DACE_BAKED_BUFF case contract), nvar baked 8 (the bridge folds an
!! unbaked loop bound to 0 — the i-loop 1..nVar must be baked; the dispatch
!! site runtime-guards nVar == 8), m/n/p/pack_offset/v_size runtime.  The
!! shim packs the INTERIOR cells (sf subscripts 0:m, 0:n, 0:p — the TU's
!! q_comm dims are (i, 0:, 0:, 0:) 0-based) and unpacks into the caller's
!! buff_send(0:buffer_count-1); the caller then acc-update-devices it so the
!! GPU_HOST_DATA(use_device_addr) MPI sendrecv sees the packed data.
#if defined(MFC_DACE)
module m_dace_kernels_pack
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, &
                                         c_double, c_associated, c_loc, &
                                         c_f_pointer, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_pack_send

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
  integer(c_int), parameter :: cpD2D = 3_c_int
#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 2
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF
#ifndef MFC_DACE_BAKED_NVAR
#define MFC_DACE_BAKED_NVAR 8
#endif
  integer, parameter :: BAKED_NVAR = MFC_DACE_BAKED_NVAR

  interface
    subroutine pack_run(state, buff_send, m_l, q_comm, n_l, p_l, pack_offset_l, &
                        q_comm_d0, q_comm_d1, q_comm_d2, v_size_l) &
        bind(C, name='__program_mfc_dace_pack')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: buff_send, q_comm
      integer(c_int), value :: m_l, n_l, p_l, pack_offset_l, v_size_l
      integer(c_int64_t), value :: q_comm_d0, q_comm_d1, q_comm_d2
    end subroutine

    function pack_init(m_l, n_l, p_l, pack_offset_l, &
                       q_comm_d0, q_comm_d1, q_comm_d2, v_size_l) &
        bind(C, name='__dace_init_mfc_dace_pack')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: pack_init
      integer(c_int), value :: m_l, n_l, p_l, pack_offset_l, v_size_l
      integer(c_int64_t), value :: q_comm_d0, q_comm_d1, q_comm_d2
    end function

    function pack_exit(state) bind(C, name='__dace_exit_mfc_dace_pack')
      import :: c_ptr, c_int
      integer(c_int) :: pack_exit
      type(c_ptr), value :: state
    end function
  end interface

  type(c_ptr), save :: d_q = c_null_ptr, d_s = c_null_ptr
  integer(c_size_t), save :: cap_q = 0_c_size_t, cap_s = 0_c_size_t
  type(c_ptr), save :: state_pack = c_null_ptr
  integer, save :: state_m = -1, state_n = -1, state_p = -1, state_off = -1

contains

  subroutine chk(ierr, what)
    integer(c_int), intent(in) :: ierr
    character(*), intent(in) :: what
    if (ierr /= 0_c_int) then
      print *, 'm_dace_kernels_pack: CUDA error in ', what, ': code=', ierr
      error stop 1
    end if
  end subroutine chk

  subroutine ensure_buf(p, cap, want, what)
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

  !> Pack the plain q_comm halo slab for the dir-1 x-faces.  q_comm_l holds
  !! exactly nVar fields (the dispatch guard pins nVar == BAKED_NVAR and
  !! v_size == nVar — the chem/qbmm extras keep the OpenACC loop).
  subroutine s_dace_pack_send(q_comm_l, buff_send_l, pack_offset_l)
    type(scalar_field), dimension(:), intent(in) :: q_comm_l
    real(wp), intent(out) :: buff_send_l(0:)
    integer, intent(in) :: pack_offset_l

    real(c_double), pointer :: d_q_f(:)
    integer :: i, j, k, l, nvar_l, v_size_l
    integer(c_size_t) :: bytes_q, bytes_s
    integer(c_int) :: ierr
    integer(c_int64_t) :: d0, d1, d2

    if (buff_size /= BAKED_BUFF_SIZE) then
      print *, 'm_dace_kernels_pack: kernel baked with buff_size=', &
               BAKED_BUFF_SIZE, ' but case uses', buff_size
      error stop 1
    end if

    nvar_l = size(q_comm_l)
    if (nvar_l /= BAKED_NVAR) then
      print *, 'm_dace_kernels_pack: kernel baked with nVar=', BAKED_NVAR, &
               ' but call has', nvar_l
      error stop 1
    end if
    v_size_l = nvar_l

    bytes_q = int(nvar_l*(m + 1)*(n + 1)*(p + 1)*8, c_size_t)
    bytes_s = int(buff_size*v_size_l*(n + 1)*(p + 1)*8, c_size_t)
    call ensure_buf(d_q, cap_q, bytes_q, 'q_comm')
    call ensure_buf(d_s, cap_s, bytes_s, 'buff_send')

    ! P2/T2.3 DEVICE-RESIDENT STAGING: q_comm is declare-create'd
    ! (device-resident in the OpenACC build) — the interior (0:m, 0:n, 0:p)
    ! pack into the kernel's (i, 0:, 0:, 0:) layout runs ON DEVICE via an
    ! acc kernel, and the packed result crosses to the caller's device
    ! buff_send as a device-to-device copy (no host staging at all).
    call c_f_pointer(d_q, d_q_f, [nvar_l*(m + 1)*(n + 1)*(p + 1)])
    !$acc parallel loop collapse(4) deviceptr(d_q_f)
    do l = 0, p
      do k = 0, n
        do j = 0, m
          do i = 1, nvar_l
            d_q_f((i - 1) + nvar_l*(j + (m + 1)*(k + (m + 1)*l)) + 1) = &
                real(q_comm_l(i)%sf(j, k, l), c_double)
          end do
        end do
      end do
    end do
    !$acc end parallel loop
    ierr = cudaDeviceSynchronize_(); call chk(ierr, 'sync pack')

    d0 = int(nvar_l, c_int64_t)
    d1 = int(m + 1, c_int64_t)
    d2 = int(n + 1, c_int64_t)

    if (state_m /= m .or. state_n /= n .or. state_p /= p &
        .or. state_off /= pack_offset_l) then
      if (c_associated(state_pack)) then
        ierr = pack_exit(state_pack)
      end if
      state_pack = pack_init(int(m, c_int), int(n, c_int), int(p, c_int), &
                             int(pack_offset_l, c_int), &
                             d0, d1, d2, int(v_size_l, c_int))
      state_m = m; state_n = n; state_p = p; state_off = pack_offset_l
    end if

    call pack_run(state_pack, d_s, int(m, c_int), d_q, int(n, c_int), &
                  int(p, c_int), int(pack_offset_l, c_int), d0, d1, d2, &
                  int(v_size_l, c_int))
    ierr = cudaDeviceSynchronize_(); call chk(ierr, 'sync')

    !$acc host_data use_device(buff_send_l)
    ierr = cudaMemcpy_(c_loc(buff_send_l(0)), d_s, bytes_s, cpD2D)
    !$acc end host_data
    call chk(ierr, 'D2D buff_send')
  end subroutine s_dace_pack_send

end module m_dace_kernels_pack

#endif