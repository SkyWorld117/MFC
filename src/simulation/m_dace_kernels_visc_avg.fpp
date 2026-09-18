#if defined(MFC_DACE)
module m_dace_kernels_visc_avg
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_double, c_size_t, &
                                         c_associated, c_loc, c_null_ptr, c_f_pointer
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_visc_avg_x, s_dace_visc_avg_z, visc_avg_enabled, visc_avg_contract, &
         & visc_avg_dir_enabled

  interface
    function cudaMalloc_(p, n) bind(C, name='cudaMalloc')
      import :: c_ptr, c_size_t, c_int
      integer(c_int) :: cudaMalloc_
      type(c_ptr) :: p
      integer(c_size_t), value :: n
    end function

    ! The runtime's own lookup: the address the OpenACC runtime will use for a host variable.
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function

    subroutine visc_avg_x_run(state, dxl1, dxl2, dxl3, dxr1, dxr2, dxr3, oxl1, oxl2, oxl3, oxr1, oxr2, oxr3, dxl1_d0, dxl1_d1, dxl2_d0, dxl2_d1, dxl3_d0, dxl3_d1, dxr1_d0, dxr1_d1, dxr2_d0, dxr2_d1, dxr3_d0, dxr3_d1, jhi, jlb, jlo, jre, kxb, kxe, lxb, lxe, oxl1_d0, oxl1_d1, oxl2_d0, oxl2_d1, oxl3_d0, oxl3_d1, oxr1_d0, oxr1_d1, oxr2_d0, oxr2_d1, oxr3_d0, oxr3_d1) &
        bind(C, name='__program_mfc_dace_visc_avg_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dxl1
      type(c_ptr), value :: dxl2
      type(c_ptr), value :: dxl3
      type(c_ptr), value :: dxr1
      type(c_ptr), value :: dxr2
      type(c_ptr), value :: dxr3
      type(c_ptr), value :: oxl1
      type(c_ptr), value :: oxl2
      type(c_ptr), value :: oxl3
      type(c_ptr), value :: oxr1
      type(c_ptr), value :: oxr2
      type(c_ptr), value :: oxr3
      integer(c_int64_t), value :: dxl1_d0
      integer(c_int64_t), value :: dxl1_d1
      integer(c_int64_t), value :: dxl2_d0
      integer(c_int64_t), value :: dxl2_d1
      integer(c_int64_t), value :: dxl3_d0
      integer(c_int64_t), value :: dxl3_d1
      integer(c_int64_t), value :: dxr1_d0
      integer(c_int64_t), value :: dxr1_d1
      integer(c_int64_t), value :: dxr2_d0
      integer(c_int64_t), value :: dxr2_d1
      integer(c_int64_t), value :: dxr3_d0
      integer(c_int64_t), value :: dxr3_d1
      integer(c_int), value :: jhi
      integer(c_int), value :: jlb
      integer(c_int), value :: jlo
      integer(c_int), value :: jre
      integer(c_int), value :: kxb
      integer(c_int), value :: kxe
      integer(c_int), value :: lxb
      integer(c_int), value :: lxe
      integer(c_int64_t), value :: oxl1_d0
      integer(c_int64_t), value :: oxl1_d1
      integer(c_int64_t), value :: oxl2_d0
      integer(c_int64_t), value :: oxl2_d1
      integer(c_int64_t), value :: oxl3_d0
      integer(c_int64_t), value :: oxl3_d1
      integer(c_int64_t), value :: oxr1_d0
      integer(c_int64_t), value :: oxr1_d1
      integer(c_int64_t), value :: oxr2_d0
      integer(c_int64_t), value :: oxr2_d1
      integer(c_int64_t), value :: oxr3_d0
      integer(c_int64_t), value :: oxr3_d1
    end subroutine

    function visc_avg_x_init(dxl1_d0, dxl1_d1, dxl2_d0, dxl2_d1, dxl3_d0, dxl3_d1, dxr1_d0, dxr1_d1, dxr2_d0, dxr2_d1, dxr3_d0, dxr3_d1, jhi, jlb, jlo, jre, kxb, kxe, lxb, lxe, oxl1_d0, oxl1_d1, oxl2_d0, oxl2_d1, oxl3_d0, oxl3_d1, oxr1_d0, oxr1_d1, oxr2_d0, oxr2_d1, oxr3_d0, oxr3_d1) bind(C, name='__dace_init_mfc_dace_visc_avg_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_avg_x_init
      integer(c_int64_t), value :: dxl1_d0
      integer(c_int64_t), value :: dxl1_d1
      integer(c_int64_t), value :: dxl2_d0
      integer(c_int64_t), value :: dxl2_d1
      integer(c_int64_t), value :: dxl3_d0
      integer(c_int64_t), value :: dxl3_d1
      integer(c_int64_t), value :: dxr1_d0
      integer(c_int64_t), value :: dxr1_d1
      integer(c_int64_t), value :: dxr2_d0
      integer(c_int64_t), value :: dxr2_d1
      integer(c_int64_t), value :: dxr3_d0
      integer(c_int64_t), value :: dxr3_d1
      integer(c_int), value :: jhi
      integer(c_int), value :: jlb
      integer(c_int), value :: jlo
      integer(c_int), value :: jre
      integer(c_int), value :: kxb
      integer(c_int), value :: kxe
      integer(c_int), value :: lxb
      integer(c_int), value :: lxe
      integer(c_int64_t), value :: oxl1_d0
      integer(c_int64_t), value :: oxl1_d1
      integer(c_int64_t), value :: oxl2_d0
      integer(c_int64_t), value :: oxl2_d1
      integer(c_int64_t), value :: oxl3_d0
      integer(c_int64_t), value :: oxl3_d1
      integer(c_int64_t), value :: oxr1_d0
      integer(c_int64_t), value :: oxr1_d1
      integer(c_int64_t), value :: oxr2_d0
      integer(c_int64_t), value :: oxr2_d1
      integer(c_int64_t), value :: oxr3_d0
      integer(c_int64_t), value :: oxr3_d1
    end function

    function visc_avg_x_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_avg_x')
      import :: c_ptr, c_int
      integer(c_int) :: visc_avg_x_exit
      type(c_ptr), value :: state
    end function

    subroutine visc_avg_z_run(state, dzl1, dzl2, dzl3, dzr1, dzr2, dzr3, ozl1, ozl2, ozl3, ozr1, ozr2, ozr3, dzl1_d0, dzl1_d1, dzl2_d0, dzl2_d1, dzl3_d0, dzl3_d1, dzr1_d0, dzr1_d1, dzr2_d0, dzr2_d1, dzr3_d0, dzr3_d1, jhi, jlb, jlo, jre, kzb, kze, lzb, lze, ozl1_d0, ozl1_d1, ozl2_d0, ozl2_d1, ozl3_d0, ozl3_d1, ozr1_d0, ozr1_d1, ozr2_d0, ozr2_d1, ozr3_d0, ozr3_d1) &
        bind(C, name='__program_mfc_dace_visc_avg_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dzl1
      type(c_ptr), value :: dzl2
      type(c_ptr), value :: dzl3
      type(c_ptr), value :: dzr1
      type(c_ptr), value :: dzr2
      type(c_ptr), value :: dzr3
      type(c_ptr), value :: ozl1
      type(c_ptr), value :: ozl2
      type(c_ptr), value :: ozl3
      type(c_ptr), value :: ozr1
      type(c_ptr), value :: ozr2
      type(c_ptr), value :: ozr3
      integer(c_int64_t), value :: dzl1_d0
      integer(c_int64_t), value :: dzl1_d1
      integer(c_int64_t), value :: dzl2_d0
      integer(c_int64_t), value :: dzl2_d1
      integer(c_int64_t), value :: dzl3_d0
      integer(c_int64_t), value :: dzl3_d1
      integer(c_int64_t), value :: dzr1_d0
      integer(c_int64_t), value :: dzr1_d1
      integer(c_int64_t), value :: dzr2_d0
      integer(c_int64_t), value :: dzr2_d1
      integer(c_int64_t), value :: dzr3_d0
      integer(c_int64_t), value :: dzr3_d1
      integer(c_int), value :: jhi
      integer(c_int), value :: jlb
      integer(c_int), value :: jlo
      integer(c_int), value :: jre
      integer(c_int), value :: kzb
      integer(c_int), value :: kze
      integer(c_int), value :: lzb
      integer(c_int), value :: lze
      integer(c_int64_t), value :: ozl1_d0
      integer(c_int64_t), value :: ozl1_d1
      integer(c_int64_t), value :: ozl2_d0
      integer(c_int64_t), value :: ozl2_d1
      integer(c_int64_t), value :: ozl3_d0
      integer(c_int64_t), value :: ozl3_d1
      integer(c_int64_t), value :: ozr1_d0
      integer(c_int64_t), value :: ozr1_d1
      integer(c_int64_t), value :: ozr2_d0
      integer(c_int64_t), value :: ozr2_d1
      integer(c_int64_t), value :: ozr3_d0
      integer(c_int64_t), value :: ozr3_d1
    end subroutine

    function visc_avg_z_init(dzl1_d0, dzl1_d1, dzl2_d0, dzl2_d1, dzl3_d0, dzl3_d1, dzr1_d0, dzr1_d1, dzr2_d0, dzr2_d1, dzr3_d0, dzr3_d1, jhi, jlb, jlo, jre, kzb, kze, lzb, lze, ozl1_d0, ozl1_d1, ozl2_d0, ozl2_d1, ozl3_d0, ozl3_d1, ozr1_d0, ozr1_d1, ozr2_d0, ozr2_d1, ozr3_d0, ozr3_d1) bind(C, name='__dace_init_mfc_dace_visc_avg_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_avg_z_init
      integer(c_int64_t), value :: dzl1_d0
      integer(c_int64_t), value :: dzl1_d1
      integer(c_int64_t), value :: dzl2_d0
      integer(c_int64_t), value :: dzl2_d1
      integer(c_int64_t), value :: dzl3_d0
      integer(c_int64_t), value :: dzl3_d1
      integer(c_int64_t), value :: dzr1_d0
      integer(c_int64_t), value :: dzr1_d1
      integer(c_int64_t), value :: dzr2_d0
      integer(c_int64_t), value :: dzr2_d1
      integer(c_int64_t), value :: dzr3_d0
      integer(c_int64_t), value :: dzr3_d1
      integer(c_int), value :: jhi
      integer(c_int), value :: jlb
      integer(c_int), value :: jlo
      integer(c_int), value :: jre
      integer(c_int), value :: kzb
      integer(c_int), value :: kze
      integer(c_int), value :: lzb
      integer(c_int), value :: lze
      integer(c_int64_t), value :: ozl1_d0
      integer(c_int64_t), value :: ozl1_d1
      integer(c_int64_t), value :: ozl2_d0
      integer(c_int64_t), value :: ozl2_d1
      integer(c_int64_t), value :: ozl3_d0
      integer(c_int64_t), value :: ozl3_d1
      integer(c_int64_t), value :: ozr1_d0
      integer(c_int64_t), value :: ozr1_d1
      integer(c_int64_t), value :: ozr2_d0
      integer(c_int64_t), value :: ozr2_d1
      integer(c_int64_t), value :: ozr3_d0
      integer(c_int64_t), value :: ozr3_d1
    end function

    function visc_avg_z_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_avg_z')
      import :: c_ptr, c_int
      integer(c_int) :: visc_avg_z_exit
      type(c_ptr), value :: state
    end function

  end interface

  type(c_ptr), save :: x_state = c_null_ptr, z_state = c_null_ptr
  type(c_ptr), save :: x_dxl1_dev
  type(c_ptr), save :: x_dxl2_dev
  type(c_ptr), save :: x_dxl3_dev
  type(c_ptr), save :: x_dxr1_dev
  type(c_ptr), save :: x_dxr2_dev
  type(c_ptr), save :: x_dxr3_dev
  type(c_ptr), save :: x_oxl1_dev
  type(c_ptr), save :: x_oxl2_dev
  type(c_ptr), save :: x_oxl3_dev
  type(c_ptr), save :: x_oxr1_dev
  type(c_ptr), save :: x_oxr2_dev
  type(c_ptr), save :: x_oxr3_dev
  real(c_double), pointer :: x_dxl1_fp(:)
  real(c_double), pointer :: x_dxl2_fp(:)
  real(c_double), pointer :: x_dxl3_fp(:)
  real(c_double), pointer :: x_dxr1_fp(:)
  real(c_double), pointer :: x_dxr2_fp(:)
  real(c_double), pointer :: x_dxr3_fp(:)
  real(c_double), pointer :: x_oxl1_fp(:)
  real(c_double), pointer :: x_oxl2_fp(:)
  real(c_double), pointer :: x_oxl3_fp(:)
  real(c_double), pointer :: x_oxr1_fp(:)
  real(c_double), pointer :: x_oxr2_fp(:)
  real(c_double), pointer :: x_oxr3_fp(:)
  type(c_ptr), save :: z_dzl1_dev
  type(c_ptr), save :: z_dzl2_dev
  type(c_ptr), save :: z_dzl3_dev
  type(c_ptr), save :: z_dzr1_dev
  type(c_ptr), save :: z_dzr2_dev
  type(c_ptr), save :: z_dzr3_dev
  type(c_ptr), save :: z_ozl1_dev
  type(c_ptr), save :: z_ozl2_dev
  type(c_ptr), save :: z_ozl3_dev
  type(c_ptr), save :: z_ozr1_dev
  type(c_ptr), save :: z_ozr2_dev
  type(c_ptr), save :: z_ozr3_dev
  real(c_double), pointer :: z_dzl1_fp(:)
  real(c_double), pointer :: z_dzl2_fp(:)
  real(c_double), pointer :: z_dzl3_fp(:)
  real(c_double), pointer :: z_dzr1_fp(:)
  real(c_double), pointer :: z_dzr2_fp(:)
  real(c_double), pointer :: z_dzr3_fp(:)
  real(c_double), pointer :: z_ozl1_fp(:)
  real(c_double), pointer :: z_ozl2_fp(:)
  real(c_double), pointer :: z_ozl3_fp(:)
  real(c_double), pointer :: z_ozr1_fp(:)
  real(c_double), pointer :: z_ozr2_fp(:)
  real(c_double), pointer :: z_ozr3_fp(:)

contains

  !> The master switch AND the per-direction mask in ONE predicate, so a call site CANNOT take the
  !! mask without the switch.  That is a real hazard here, not a stylistic one: the mask defaults to
  !! BOTH directions, so a guard written `visc_avg_dir_enabled(n)` alone turns the kernel on by
  !! default -- which is exactly what the first wiring of this dispatch did.
  !!
  !! `MFC_DACE_VISC_AVG` (unset or 0 = the stock loops, unchanged);
  !! `MFC_DACE_VISC_AVG_DIRS` masks a direction (x z; unset = both), for bisecting.
  function visc_avg_dir_enabled(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    logical, save :: val(2) = [.false., .false.]
    if (.not. cached) then
      call get_environment_variable('MFC_DACE_VISC_AVG', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1 .and. env(1:1) /= '0') val = .true.
      call get_environment_variable('MFC_DACE_VISC_AVG_DIRS', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) then
        val(1) = val(1) .and. env(1:1) == '1'
        val(2) = val(2) .and. (len_trim(env) < 2 .or. env(2:2) == '1')
      end if
      cached = .true.
    end if
    c = val(nd)
  end function visc_avg_dir_enabled

  !> `MFC_DACE_VISC_AVG` (unset or 0 = the stock loops, unchanged) -- the switch alone, for the
  !! once-per-run announcement.
  function visc_avg_enabled() result(c)
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false., val = .false.
    if (.not. cached) then
      call get_environment_variable('MFC_DACE_VISC_AVG', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1 .and. env(1:1) /= '0') val = .true.
      cached = .true.
    end if
    c = val
  end function visc_avg_enabled

  !> Say ONCE per direction that the kernel engaged.  A stack of bit-identical comparisons cannot
  !! tell two paths apart -- a dispatch that never fired passed a gate in this project that way --
  !! so the run log has to carry which path it took.
  subroutine visc_avg_announce(nd)
    integer, intent(in) :: nd
    logical, save :: said(2) = [.false., .false.]
    if (.not. said(nd)) then
      said(nd) = .true.
      print '(a)', 'm_dace_kernels_visc_avg: ' // merge('x', 'z', nd == 1) // &
          & ' engaged (MFC_DACE_VISC_AVG)'
    end if
  end subroutine visc_avg_announce

  !> The bake's contract: the TUs unroll the three momentum rows and touch no ghost cells.
  function visc_avg_contract() result(c)
    logical :: c
    c = (num_dims == 3 .and. num_vels == 3 .and. .not. cyl_coord)
  end function visc_avg_contract

  !> The two level-2 x-gradient face averages (both sides of the y-face stencil), one kernel.
  !! The rows are staged into buffers THIS shim owns with !$acc parallel loops, so the kernel never sees an acc_deviceptr of MFC's arrays.
  !! Set MFC_DACE_VISC_AVG_STAGE=0 and re-bake to drop the staging.
  subroutine s_dace_visc_avg_x(vxL, vxR, oxL, oxR, ivb, ive, k1b, k1e, k2b, k2e, k3b, k3e)
    type(vector_field), intent(in) :: vxL, vxR
    type(vector_field), intent(inout) :: oxL, oxR
    integer, intent(in) :: ivb, ive, k1b, k1e, k2b, k2e, k3b, k3e
    integer :: ierr, kxb, kxe, kzb, kze, lxb, lxe, lzb, lze, jlo, jhi, jlb, jre, b1, b2, b3
    integer :: ii, jj, kk

    call visc_avg_announce(1)

    b1 = lbound(vxL%vf(ivb)%sf, 1)
    b2 = lbound(vxL%vf(ivb)%sf, 2)
    b3 = lbound(vxL%vf(ivb)%sf, 3)

    ! every range is relative to the row's lbound corner, and the extents handed to the kernel are
    ! the row's full extents -- the two must agree or the stride arithmetic runs past the buffer
    kxb = k1b + 1 - b1; kxe = k1e - 1 - b1
    kzb = k1b - b1;     kze = k1e - b1
    lxb = k3b - b3;     lxe = k3e - b3
    lzb = k3b + 1 - b3; lze = k3e - 1 - b3
    ! the two arms share ONE nest, so the kernel takes the UNION of their j ranges (jlo..jhi) plus
    ! the two guards that select each arm inside it.  The union is contiguous by construction:
    ! the L arm runs k2b+1..k2e and the R arm k2b..k2e-1.
    jlo = k2b - b2;     jhi = k2e - b2
    jlb = k2b + 1 - b2; jre = k2e - 1 - b2

      if (.not. c_associated(x_dxl1_dev)) then
        ierr = cudaMalloc_(x_dxl1_dev, int(8_c_size_t*int(size(vxl%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(vxl%vf(ivb + 0)%sf, 2), c_size_t)*int(size(vxl%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxl1_dev, x_dxl1_fp, [size(vxl%vf(ivb + 0)%sf, 1)*size(vxl%vf(ivb + 0)%sf, 2)*size(vxl%vf(ivb + 0)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxl1_fp)
      do kk = 1, size(vxl%vf(ivb + 0)%sf, 3)
        do jj = 1, size(vxl%vf(ivb + 0)%sf, 2)
          do ii = 1, size(vxl%vf(ivb + 0)%sf, 1)
            x_dxl1_fp((ii - 1) + size(vxl%vf(ivb + 0)%sf, 1)*((jj - 1) + size(vxl%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1) = vxl%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_dxl2_dev)) then
        ierr = cudaMalloc_(x_dxl2_dev, int(8_c_size_t*int(size(vxl%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(vxl%vf(ivb + 1)%sf, 2), c_size_t)*int(size(vxl%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxl2_dev, x_dxl2_fp, [size(vxl%vf(ivb + 1)%sf, 1)*size(vxl%vf(ivb + 1)%sf, 2)*size(vxl%vf(ivb + 1)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxl2_fp)
      do kk = 1, size(vxl%vf(ivb + 1)%sf, 3)
        do jj = 1, size(vxl%vf(ivb + 1)%sf, 2)
          do ii = 1, size(vxl%vf(ivb + 1)%sf, 1)
            x_dxl2_fp((ii - 1) + size(vxl%vf(ivb + 1)%sf, 1)*((jj - 1) + size(vxl%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1) = vxl%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_dxl3_dev)) then
        ierr = cudaMalloc_(x_dxl3_dev, int(8_c_size_t*int(size(vxl%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(vxl%vf(ivb + 2)%sf, 2), c_size_t)*int(size(vxl%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxl3_dev, x_dxl3_fp, [size(vxl%vf(ivb + 2)%sf, 1)*size(vxl%vf(ivb + 2)%sf, 2)*size(vxl%vf(ivb + 2)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxl3_fp)
      do kk = 1, size(vxl%vf(ivb + 2)%sf, 3)
        do jj = 1, size(vxl%vf(ivb + 2)%sf, 2)
          do ii = 1, size(vxl%vf(ivb + 2)%sf, 1)
            x_dxl3_fp((ii - 1) + size(vxl%vf(ivb + 2)%sf, 1)*((jj - 1) + size(vxl%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1) = vxl%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_dxr1_dev)) then
        ierr = cudaMalloc_(x_dxr1_dev, int(8_c_size_t*int(size(vxr%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(vxr%vf(ivb + 0)%sf, 2), c_size_t)*int(size(vxr%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxr1_dev, x_dxr1_fp, [size(vxr%vf(ivb + 0)%sf, 1)*size(vxr%vf(ivb + 0)%sf, 2)*size(vxr%vf(ivb + 0)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxr1_fp)
      do kk = 1, size(vxr%vf(ivb + 0)%sf, 3)
        do jj = 1, size(vxr%vf(ivb + 0)%sf, 2)
          do ii = 1, size(vxr%vf(ivb + 0)%sf, 1)
            x_dxr1_fp((ii - 1) + size(vxr%vf(ivb + 0)%sf, 1)*((jj - 1) + size(vxr%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1) = vxr%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_dxr2_dev)) then
        ierr = cudaMalloc_(x_dxr2_dev, int(8_c_size_t*int(size(vxr%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(vxr%vf(ivb + 1)%sf, 2), c_size_t)*int(size(vxr%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxr2_dev, x_dxr2_fp, [size(vxr%vf(ivb + 1)%sf, 1)*size(vxr%vf(ivb + 1)%sf, 2)*size(vxr%vf(ivb + 1)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxr2_fp)
      do kk = 1, size(vxr%vf(ivb + 1)%sf, 3)
        do jj = 1, size(vxr%vf(ivb + 1)%sf, 2)
          do ii = 1, size(vxr%vf(ivb + 1)%sf, 1)
            x_dxr2_fp((ii - 1) + size(vxr%vf(ivb + 1)%sf, 1)*((jj - 1) + size(vxr%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1) = vxr%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_dxr3_dev)) then
        ierr = cudaMalloc_(x_dxr3_dev, int(8_c_size_t*int(size(vxr%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(vxr%vf(ivb + 2)%sf, 2), c_size_t)*int(size(vxr%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_dxr3_dev, x_dxr3_fp, [size(vxr%vf(ivb + 2)%sf, 1)*size(vxr%vf(ivb + 2)%sf, 2)*size(vxr%vf(ivb + 2)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(x_dxr3_fp)
      do kk = 1, size(vxr%vf(ivb + 2)%sf, 3)
        do jj = 1, size(vxr%vf(ivb + 2)%sf, 2)
          do ii = 1, size(vxr%vf(ivb + 2)%sf, 1)
            x_dxr3_fp((ii - 1) + size(vxr%vf(ivb + 2)%sf, 1)*((jj - 1) + size(vxr%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1) = vxr%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(x_oxl1_dev)) then
        ierr = cudaMalloc_(x_oxl1_dev, int(8_c_size_t*int(size(oxl%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(oxl%vf(ivb + 0)%sf, 2), c_size_t)*int(size(oxl%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxl1_dev, x_oxl1_fp, [size(oxl%vf(ivb + 0)%sf, 1)*size(oxl%vf(ivb + 0)%sf, 2)*size(oxl%vf(ivb + 0)%sf, 3)])
      end if
      if (.not. c_associated(x_oxl2_dev)) then
        ierr = cudaMalloc_(x_oxl2_dev, int(8_c_size_t*int(size(oxl%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(oxl%vf(ivb + 1)%sf, 2), c_size_t)*int(size(oxl%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxl2_dev, x_oxl2_fp, [size(oxl%vf(ivb + 1)%sf, 1)*size(oxl%vf(ivb + 1)%sf, 2)*size(oxl%vf(ivb + 1)%sf, 3)])
      end if
      if (.not. c_associated(x_oxl3_dev)) then
        ierr = cudaMalloc_(x_oxl3_dev, int(8_c_size_t*int(size(oxl%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(oxl%vf(ivb + 2)%sf, 2), c_size_t)*int(size(oxl%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxl3_dev, x_oxl3_fp, [size(oxl%vf(ivb + 2)%sf, 1)*size(oxl%vf(ivb + 2)%sf, 2)*size(oxl%vf(ivb + 2)%sf, 3)])
      end if
      if (.not. c_associated(x_oxr1_dev)) then
        ierr = cudaMalloc_(x_oxr1_dev, int(8_c_size_t*int(size(oxr%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(oxr%vf(ivb + 0)%sf, 2), c_size_t)*int(size(oxr%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxr1_dev, x_oxr1_fp, [size(oxr%vf(ivb + 0)%sf, 1)*size(oxr%vf(ivb + 0)%sf, 2)*size(oxr%vf(ivb + 0)%sf, 3)])
      end if
      if (.not. c_associated(x_oxr2_dev)) then
        ierr = cudaMalloc_(x_oxr2_dev, int(8_c_size_t*int(size(oxr%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(oxr%vf(ivb + 1)%sf, 2), c_size_t)*int(size(oxr%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxr2_dev, x_oxr2_fp, [size(oxr%vf(ivb + 1)%sf, 1)*size(oxr%vf(ivb + 1)%sf, 2)*size(oxr%vf(ivb + 1)%sf, 3)])
      end if
      if (.not. c_associated(x_oxr3_dev)) then
        ierr = cudaMalloc_(x_oxr3_dev, int(8_c_size_t*int(size(oxr%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(oxr%vf(ivb + 2)%sf, 2), c_size_t)*int(size(oxr%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(x_oxr3_dev, x_oxr3_fp, [size(oxr%vf(ivb + 2)%sf, 1)*size(oxr%vf(ivb + 2)%sf, 2)*size(oxr%vf(ivb + 2)%sf, 3)])
      end if
    if (.not. c_associated(x_state)) then
      x_state = visc_avg_x_init(int(size(vxl%vf(ivb + 0)%sf, 1), c_int64_t), &
          & int(size(vxl%vf(ivb + 0)%sf, 2), c_int64_t), int(size(vxl%vf(ivb + 1)%sf, 1), c_int64_t), &
          & int(size(vxl%vf(ivb + 1)%sf, 2), c_int64_t), int(size(vxl%vf(ivb + 2)%sf, 1), c_int64_t), &
          & int(size(vxl%vf(ivb + 2)%sf, 2), c_int64_t), int(size(vxr%vf(ivb + 0)%sf, 1), c_int64_t), &
          & int(size(vxr%vf(ivb + 0)%sf, 2), c_int64_t), int(size(vxr%vf(ivb + 1)%sf, 1), c_int64_t), &
          & int(size(vxr%vf(ivb + 1)%sf, 2), c_int64_t), int(size(vxr%vf(ivb + 2)%sf, 1), c_int64_t), &
          & int(size(vxr%vf(ivb + 2)%sf, 2), c_int64_t), int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), &
          & int(jre, c_int), int(kxb, c_int), int(kxe, c_int), int(lxb, c_int), int(lxe, c_int), &
          & int(size(oxl%vf(ivb + 0)%sf, 1), c_int64_t), int(size(oxl%vf(ivb + 0)%sf, 2), c_int64_t), &
          & int(size(oxl%vf(ivb + 1)%sf, 1), c_int64_t), int(size(oxl%vf(ivb + 1)%sf, 2), c_int64_t), &
          & int(size(oxl%vf(ivb + 2)%sf, 1), c_int64_t), int(size(oxl%vf(ivb + 2)%sf, 2), c_int64_t), &
          & int(size(oxr%vf(ivb + 0)%sf, 1), c_int64_t), int(size(oxr%vf(ivb + 0)%sf, 2), c_int64_t), &
          & int(size(oxr%vf(ivb + 1)%sf, 1), c_int64_t), int(size(oxr%vf(ivb + 1)%sf, 2), c_int64_t), &
          & int(size(oxr%vf(ivb + 2)%sf, 1), c_int64_t), int(size(oxr%vf(ivb + 2)%sf, 2), c_int64_t))
    end if
    call visc_avg_x_run(x_state, x_dxl1_dev, x_dxl2_dev, x_dxl3_dev, x_dxr1_dev, x_dxr2_dev, x_dxr3_dev, &
        & x_oxl1_dev, x_oxl2_dev, x_oxl3_dev, x_oxr1_dev, x_oxr2_dev, x_oxr3_dev, &
        & int(size(vxl%vf(ivb + 0)%sf, 1), c_int64_t), int(size(vxl%vf(ivb + 0)%sf, 2), c_int64_t), &
        & int(size(vxl%vf(ivb + 1)%sf, 1), c_int64_t), int(size(vxl%vf(ivb + 1)%sf, 2), c_int64_t), &
        & int(size(vxl%vf(ivb + 2)%sf, 1), c_int64_t), int(size(vxl%vf(ivb + 2)%sf, 2), c_int64_t), &
        & int(size(vxr%vf(ivb + 0)%sf, 1), c_int64_t), int(size(vxr%vf(ivb + 0)%sf, 2), c_int64_t), &
        & int(size(vxr%vf(ivb + 1)%sf, 1), c_int64_t), int(size(vxr%vf(ivb + 1)%sf, 2), c_int64_t), &
        & int(size(vxr%vf(ivb + 2)%sf, 1), c_int64_t), int(size(vxr%vf(ivb + 2)%sf, 2), c_int64_t), &
        & int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), int(jre, c_int), int(kxb, c_int), &
        & int(kxe, c_int), int(lxb, c_int), int(lxe, c_int), int(size(oxl%vf(ivb + 0)%sf, 1), c_int64_t), &
        & int(size(oxl%vf(ivb + 0)%sf, 2), c_int64_t), int(size(oxl%vf(ivb + 1)%sf, 1), c_int64_t), &
        & int(size(oxl%vf(ivb + 1)%sf, 2), c_int64_t), int(size(oxl%vf(ivb + 2)%sf, 1), c_int64_t), &
        & int(size(oxl%vf(ivb + 2)%sf, 2), c_int64_t), int(size(oxr%vf(ivb + 0)%sf, 1), c_int64_t), &
        & int(size(oxr%vf(ivb + 0)%sf, 2), c_int64_t), int(size(oxr%vf(ivb + 1)%sf, 1), c_int64_t), &
        & int(size(oxr%vf(ivb + 1)%sf, 2), c_int64_t), int(size(oxr%vf(ivb + 2)%sf, 1), c_int64_t), &
        & int(size(oxr%vf(ivb + 2)%sf, 2), c_int64_t))
      !$acc parallel loop collapse(3) deviceptr(x_oxl1_fp)
      do kk = 1, size(oxl%vf(ivb + 0)%sf, 3)
        do jj = 1, size(oxl%vf(ivb + 0)%sf, 2)
          do ii = 1, size(oxl%vf(ivb + 0)%sf, 1)
            oxl%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxl1_fp((ii - 1) + size(oxl%vf(ivb + 0)%sf, 1)*((jj - 1) + size(oxl%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(x_oxl2_fp)
      do kk = 1, size(oxl%vf(ivb + 1)%sf, 3)
        do jj = 1, size(oxl%vf(ivb + 1)%sf, 2)
          do ii = 1, size(oxl%vf(ivb + 1)%sf, 1)
            oxl%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxl2_fp((ii - 1) + size(oxl%vf(ivb + 1)%sf, 1)*((jj - 1) + size(oxl%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(x_oxl3_fp)
      do kk = 1, size(oxl%vf(ivb + 2)%sf, 3)
        do jj = 1, size(oxl%vf(ivb + 2)%sf, 2)
          do ii = 1, size(oxl%vf(ivb + 2)%sf, 1)
            oxl%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxl3_fp((ii - 1) + size(oxl%vf(ivb + 2)%sf, 1)*((jj - 1) + size(oxl%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(x_oxr1_fp)
      do kk = 1, size(oxr%vf(ivb + 0)%sf, 3)
        do jj = 1, size(oxr%vf(ivb + 0)%sf, 2)
          do ii = 1, size(oxr%vf(ivb + 0)%sf, 1)
            oxr%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxr1_fp((ii - 1) + size(oxr%vf(ivb + 0)%sf, 1)*((jj - 1) + size(oxr%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(x_oxr2_fp)
      do kk = 1, size(oxr%vf(ivb + 1)%sf, 3)
        do jj = 1, size(oxr%vf(ivb + 1)%sf, 2)
          do ii = 1, size(oxr%vf(ivb + 1)%sf, 1)
            oxr%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxr2_fp((ii - 1) + size(oxr%vf(ivb + 1)%sf, 1)*((jj - 1) + size(oxr%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(x_oxr3_fp)
      do kk = 1, size(oxr%vf(ivb + 2)%sf, 3)
        do jj = 1, size(oxr%vf(ivb + 2)%sf, 2)
          do ii = 1, size(oxr%vf(ivb + 2)%sf, 1)
            oxr%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = x_oxr3_fp((ii - 1) + size(oxr%vf(ivb + 2)%sf, 1)*((jj - 1) + size(oxr%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_avg: x: a staging copy failed'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_x

  !> The two level-2 z-gradient face averages (both sides of the y-face stencil), one kernel.
  !! The rows are staged into buffers THIS shim owns with !$acc parallel loops, so the kernel never sees an acc_deviceptr of MFC's arrays.
  !! Set MFC_DACE_VISC_AVG_STAGE=0 and re-bake to drop the staging.
  subroutine s_dace_visc_avg_z(vzL, vzR, ozL, ozR, ivb, ive, k1b, k1e, k2b, k2e, k3b, k3e)
    type(vector_field), intent(in) :: vzL, vzR
    type(vector_field), intent(inout) :: ozL, ozR
    integer, intent(in) :: ivb, ive, k1b, k1e, k2b, k2e, k3b, k3e
    integer :: ierr, kxb, kxe, kzb, kze, lxb, lxe, lzb, lze, jlo, jhi, jlb, jre, b1, b2, b3
    integer :: ii, jj, kk

    call visc_avg_announce(2)

    b1 = lbound(vzL%vf(ivb)%sf, 1)
    b2 = lbound(vzL%vf(ivb)%sf, 2)
    b3 = lbound(vzL%vf(ivb)%sf, 3)

    ! every range is relative to the row's lbound corner, and the extents handed to the kernel are
    ! the row's full extents -- the two must agree or the stride arithmetic runs past the buffer
    kxb = k1b + 1 - b1; kxe = k1e - 1 - b1
    kzb = k1b - b1;     kze = k1e - b1
    lxb = k3b - b3;     lxe = k3e - b3
    lzb = k3b + 1 - b3; lze = k3e - 1 - b3
    ! the two arms share ONE nest, so the kernel takes the UNION of their j ranges (jlo..jhi) plus
    ! the two guards that select each arm inside it.  The union is contiguous by construction:
    ! the L arm runs k2b+1..k2e and the R arm k2b..k2e-1.
    jlo = k2b - b2;     jhi = k2e - b2
    jlb = k2b + 1 - b2; jre = k2e - 1 - b2

      if (.not. c_associated(z_dzl1_dev)) then
        ierr = cudaMalloc_(z_dzl1_dev, int(8_c_size_t*int(size(vzl%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(vzl%vf(ivb + 0)%sf, 2), c_size_t)*int(size(vzl%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzl1_dev, z_dzl1_fp, [size(vzl%vf(ivb + 0)%sf, 1)*size(vzl%vf(ivb + 0)%sf, 2)*size(vzl%vf(ivb + 0)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzl1_fp)
      do kk = 1, size(vzl%vf(ivb + 0)%sf, 3)
        do jj = 1, size(vzl%vf(ivb + 0)%sf, 2)
          do ii = 1, size(vzl%vf(ivb + 0)%sf, 1)
            z_dzl1_fp((ii - 1) + size(vzl%vf(ivb + 0)%sf, 1)*((jj - 1) + size(vzl%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1) = vzl%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_dzl2_dev)) then
        ierr = cudaMalloc_(z_dzl2_dev, int(8_c_size_t*int(size(vzl%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(vzl%vf(ivb + 1)%sf, 2), c_size_t)*int(size(vzl%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzl2_dev, z_dzl2_fp, [size(vzl%vf(ivb + 1)%sf, 1)*size(vzl%vf(ivb + 1)%sf, 2)*size(vzl%vf(ivb + 1)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzl2_fp)
      do kk = 1, size(vzl%vf(ivb + 1)%sf, 3)
        do jj = 1, size(vzl%vf(ivb + 1)%sf, 2)
          do ii = 1, size(vzl%vf(ivb + 1)%sf, 1)
            z_dzl2_fp((ii - 1) + size(vzl%vf(ivb + 1)%sf, 1)*((jj - 1) + size(vzl%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1) = vzl%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_dzl3_dev)) then
        ierr = cudaMalloc_(z_dzl3_dev, int(8_c_size_t*int(size(vzl%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(vzl%vf(ivb + 2)%sf, 2), c_size_t)*int(size(vzl%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzl3_dev, z_dzl3_fp, [size(vzl%vf(ivb + 2)%sf, 1)*size(vzl%vf(ivb + 2)%sf, 2)*size(vzl%vf(ivb + 2)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzl3_fp)
      do kk = 1, size(vzl%vf(ivb + 2)%sf, 3)
        do jj = 1, size(vzl%vf(ivb + 2)%sf, 2)
          do ii = 1, size(vzl%vf(ivb + 2)%sf, 1)
            z_dzl3_fp((ii - 1) + size(vzl%vf(ivb + 2)%sf, 1)*((jj - 1) + size(vzl%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1) = vzl%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_dzr1_dev)) then
        ierr = cudaMalloc_(z_dzr1_dev, int(8_c_size_t*int(size(vzr%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(vzr%vf(ivb + 0)%sf, 2), c_size_t)*int(size(vzr%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzr1_dev, z_dzr1_fp, [size(vzr%vf(ivb + 0)%sf, 1)*size(vzr%vf(ivb + 0)%sf, 2)*size(vzr%vf(ivb + 0)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzr1_fp)
      do kk = 1, size(vzr%vf(ivb + 0)%sf, 3)
        do jj = 1, size(vzr%vf(ivb + 0)%sf, 2)
          do ii = 1, size(vzr%vf(ivb + 0)%sf, 1)
            z_dzr1_fp((ii - 1) + size(vzr%vf(ivb + 0)%sf, 1)*((jj - 1) + size(vzr%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1) = vzr%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_dzr2_dev)) then
        ierr = cudaMalloc_(z_dzr2_dev, int(8_c_size_t*int(size(vzr%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(vzr%vf(ivb + 1)%sf, 2), c_size_t)*int(size(vzr%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzr2_dev, z_dzr2_fp, [size(vzr%vf(ivb + 1)%sf, 1)*size(vzr%vf(ivb + 1)%sf, 2)*size(vzr%vf(ivb + 1)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzr2_fp)
      do kk = 1, size(vzr%vf(ivb + 1)%sf, 3)
        do jj = 1, size(vzr%vf(ivb + 1)%sf, 2)
          do ii = 1, size(vzr%vf(ivb + 1)%sf, 1)
            z_dzr2_fp((ii - 1) + size(vzr%vf(ivb + 1)%sf, 1)*((jj - 1) + size(vzr%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1) = vzr%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_dzr3_dev)) then
        ierr = cudaMalloc_(z_dzr3_dev, int(8_c_size_t*int(size(vzr%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(vzr%vf(ivb + 2)%sf, 2), c_size_t)*int(size(vzr%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_dzr3_dev, z_dzr3_fp, [size(vzr%vf(ivb + 2)%sf, 1)*size(vzr%vf(ivb + 2)%sf, 2)*size(vzr%vf(ivb + 2)%sf, 3)])
      end if
      !$acc parallel loop collapse(3) deviceptr(z_dzr3_fp)
      do kk = 1, size(vzr%vf(ivb + 2)%sf, 3)
        do jj = 1, size(vzr%vf(ivb + 2)%sf, 2)
          do ii = 1, size(vzr%vf(ivb + 2)%sf, 1)
            z_dzr3_fp((ii - 1) + size(vzr%vf(ivb + 2)%sf, 1)*((jj - 1) + size(vzr%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1) = vzr%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1)
          end do
        end do
      end do
      !$acc end parallel loop
      if (.not. c_associated(z_ozl1_dev)) then
        ierr = cudaMalloc_(z_ozl1_dev, int(8_c_size_t*int(size(ozl%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(ozl%vf(ivb + 0)%sf, 2), c_size_t)*int(size(ozl%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozl1_dev, z_ozl1_fp, [size(ozl%vf(ivb + 0)%sf, 1)*size(ozl%vf(ivb + 0)%sf, 2)*size(ozl%vf(ivb + 0)%sf, 3)])
      end if
      if (.not. c_associated(z_ozl2_dev)) then
        ierr = cudaMalloc_(z_ozl2_dev, int(8_c_size_t*int(size(ozl%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(ozl%vf(ivb + 1)%sf, 2), c_size_t)*int(size(ozl%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozl2_dev, z_ozl2_fp, [size(ozl%vf(ivb + 1)%sf, 1)*size(ozl%vf(ivb + 1)%sf, 2)*size(ozl%vf(ivb + 1)%sf, 3)])
      end if
      if (.not. c_associated(z_ozl3_dev)) then
        ierr = cudaMalloc_(z_ozl3_dev, int(8_c_size_t*int(size(ozl%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(ozl%vf(ivb + 2)%sf, 2), c_size_t)*int(size(ozl%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozl3_dev, z_ozl3_fp, [size(ozl%vf(ivb + 2)%sf, 1)*size(ozl%vf(ivb + 2)%sf, 2)*size(ozl%vf(ivb + 2)%sf, 3)])
      end if
      if (.not. c_associated(z_ozr1_dev)) then
        ierr = cudaMalloc_(z_ozr1_dev, int(8_c_size_t*int(size(ozr%vf(ivb + 0)%sf, 1), c_size_t)* &
             & int(size(ozr%vf(ivb + 0)%sf, 2), c_size_t)*int(size(ozr%vf(ivb + 0)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozr1_dev, z_ozr1_fp, [size(ozr%vf(ivb + 0)%sf, 1)*size(ozr%vf(ivb + 0)%sf, 2)*size(ozr%vf(ivb + 0)%sf, 3)])
      end if
      if (.not. c_associated(z_ozr2_dev)) then
        ierr = cudaMalloc_(z_ozr2_dev, int(8_c_size_t*int(size(ozr%vf(ivb + 1)%sf, 1), c_size_t)* &
             & int(size(ozr%vf(ivb + 1)%sf, 2), c_size_t)*int(size(ozr%vf(ivb + 1)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozr2_dev, z_ozr2_fp, [size(ozr%vf(ivb + 1)%sf, 1)*size(ozr%vf(ivb + 1)%sf, 2)*size(ozr%vf(ivb + 1)%sf, 3)])
      end if
      if (.not. c_associated(z_ozr3_dev)) then
        ierr = cudaMalloc_(z_ozr3_dev, int(8_c_size_t*int(size(ozr%vf(ivb + 2)%sf, 1), c_size_t)* &
             & int(size(ozr%vf(ivb + 2)%sf, 2), c_size_t)*int(size(ozr%vf(ivb + 2)%sf, 3), c_size_t), c_size_t))
        call c_f_pointer(z_ozr3_dev, z_ozr3_fp, [size(ozr%vf(ivb + 2)%sf, 1)*size(ozr%vf(ivb + 2)%sf, 2)*size(ozr%vf(ivb + 2)%sf, 3)])
      end if
    if (.not. c_associated(z_state)) then
      z_state = visc_avg_z_init(int(size(vzl%vf(ivb + 0)%sf, 1), c_int64_t), &
          & int(size(vzl%vf(ivb + 0)%sf, 2), c_int64_t), int(size(vzl%vf(ivb + 1)%sf, 1), c_int64_t), &
          & int(size(vzl%vf(ivb + 1)%sf, 2), c_int64_t), int(size(vzl%vf(ivb + 2)%sf, 1), c_int64_t), &
          & int(size(vzl%vf(ivb + 2)%sf, 2), c_int64_t), int(size(vzr%vf(ivb + 0)%sf, 1), c_int64_t), &
          & int(size(vzr%vf(ivb + 0)%sf, 2), c_int64_t), int(size(vzr%vf(ivb + 1)%sf, 1), c_int64_t), &
          & int(size(vzr%vf(ivb + 1)%sf, 2), c_int64_t), int(size(vzr%vf(ivb + 2)%sf, 1), c_int64_t), &
          & int(size(vzr%vf(ivb + 2)%sf, 2), c_int64_t), int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), &
          & int(jre, c_int), int(kzb, c_int), int(kze, c_int), int(lzb, c_int), int(lze, c_int), &
          & int(size(ozl%vf(ivb + 0)%sf, 1), c_int64_t), int(size(ozl%vf(ivb + 0)%sf, 2), c_int64_t), &
          & int(size(ozl%vf(ivb + 1)%sf, 1), c_int64_t), int(size(ozl%vf(ivb + 1)%sf, 2), c_int64_t), &
          & int(size(ozl%vf(ivb + 2)%sf, 1), c_int64_t), int(size(ozl%vf(ivb + 2)%sf, 2), c_int64_t), &
          & int(size(ozr%vf(ivb + 0)%sf, 1), c_int64_t), int(size(ozr%vf(ivb + 0)%sf, 2), c_int64_t), &
          & int(size(ozr%vf(ivb + 1)%sf, 1), c_int64_t), int(size(ozr%vf(ivb + 1)%sf, 2), c_int64_t), &
          & int(size(ozr%vf(ivb + 2)%sf, 1), c_int64_t), int(size(ozr%vf(ivb + 2)%sf, 2), c_int64_t))
    end if
    call visc_avg_z_run(z_state, z_dzl1_dev, z_dzl2_dev, z_dzl3_dev, z_dzr1_dev, z_dzr2_dev, z_dzr3_dev, &
        & z_ozl1_dev, z_ozl2_dev, z_ozl3_dev, z_ozr1_dev, z_ozr2_dev, z_ozr3_dev, &
        & int(size(vzl%vf(ivb + 0)%sf, 1), c_int64_t), int(size(vzl%vf(ivb + 0)%sf, 2), c_int64_t), &
        & int(size(vzl%vf(ivb + 1)%sf, 1), c_int64_t), int(size(vzl%vf(ivb + 1)%sf, 2), c_int64_t), &
        & int(size(vzl%vf(ivb + 2)%sf, 1), c_int64_t), int(size(vzl%vf(ivb + 2)%sf, 2), c_int64_t), &
        & int(size(vzr%vf(ivb + 0)%sf, 1), c_int64_t), int(size(vzr%vf(ivb + 0)%sf, 2), c_int64_t), &
        & int(size(vzr%vf(ivb + 1)%sf, 1), c_int64_t), int(size(vzr%vf(ivb + 1)%sf, 2), c_int64_t), &
        & int(size(vzr%vf(ivb + 2)%sf, 1), c_int64_t), int(size(vzr%vf(ivb + 2)%sf, 2), c_int64_t), &
        & int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), int(jre, c_int), int(kzb, c_int), &
        & int(kze, c_int), int(lzb, c_int), int(lze, c_int), int(size(ozl%vf(ivb + 0)%sf, 1), c_int64_t), &
        & int(size(ozl%vf(ivb + 0)%sf, 2), c_int64_t), int(size(ozl%vf(ivb + 1)%sf, 1), c_int64_t), &
        & int(size(ozl%vf(ivb + 1)%sf, 2), c_int64_t), int(size(ozl%vf(ivb + 2)%sf, 1), c_int64_t), &
        & int(size(ozl%vf(ivb + 2)%sf, 2), c_int64_t), int(size(ozr%vf(ivb + 0)%sf, 1), c_int64_t), &
        & int(size(ozr%vf(ivb + 0)%sf, 2), c_int64_t), int(size(ozr%vf(ivb + 1)%sf, 1), c_int64_t), &
        & int(size(ozr%vf(ivb + 1)%sf, 2), c_int64_t), int(size(ozr%vf(ivb + 2)%sf, 1), c_int64_t), &
        & int(size(ozr%vf(ivb + 2)%sf, 2), c_int64_t))
      !$acc parallel loop collapse(3) deviceptr(z_ozl1_fp)
      do kk = 1, size(ozl%vf(ivb + 0)%sf, 3)
        do jj = 1, size(ozl%vf(ivb + 0)%sf, 2)
          do ii = 1, size(ozl%vf(ivb + 0)%sf, 1)
            ozl%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozl1_fp((ii - 1) + size(ozl%vf(ivb + 0)%sf, 1)*((jj - 1) + size(ozl%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(z_ozl2_fp)
      do kk = 1, size(ozl%vf(ivb + 1)%sf, 3)
        do jj = 1, size(ozl%vf(ivb + 1)%sf, 2)
          do ii = 1, size(ozl%vf(ivb + 1)%sf, 1)
            ozl%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozl2_fp((ii - 1) + size(ozl%vf(ivb + 1)%sf, 1)*((jj - 1) + size(ozl%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(z_ozl3_fp)
      do kk = 1, size(ozl%vf(ivb + 2)%sf, 3)
        do jj = 1, size(ozl%vf(ivb + 2)%sf, 2)
          do ii = 1, size(ozl%vf(ivb + 2)%sf, 1)
            ozl%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozl3_fp((ii - 1) + size(ozl%vf(ivb + 2)%sf, 1)*((jj - 1) + size(ozl%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(z_ozr1_fp)
      do kk = 1, size(ozr%vf(ivb + 0)%sf, 3)
        do jj = 1, size(ozr%vf(ivb + 0)%sf, 2)
          do ii = 1, size(ozr%vf(ivb + 0)%sf, 1)
            ozr%vf(ivb + 0)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozr1_fp((ii - 1) + size(ozr%vf(ivb + 0)%sf, 1)*((jj - 1) + size(ozr%vf(ivb + 0)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(z_ozr2_fp)
      do kk = 1, size(ozr%vf(ivb + 1)%sf, 3)
        do jj = 1, size(ozr%vf(ivb + 1)%sf, 2)
          do ii = 1, size(ozr%vf(ivb + 1)%sf, 1)
            ozr%vf(ivb + 1)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozr2_fp((ii - 1) + size(ozr%vf(ivb + 1)%sf, 1)*((jj - 1) + size(ozr%vf(ivb + 1)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
      !$acc parallel loop collapse(3) deviceptr(z_ozr3_fp)
      do kk = 1, size(ozr%vf(ivb + 2)%sf, 3)
        do jj = 1, size(ozr%vf(ivb + 2)%sf, 2)
          do ii = 1, size(ozr%vf(ivb + 2)%sf, 1)
            ozr%vf(ivb + 2)%sf(b1 + ii - 1, b2 + jj - 1, b3 + kk - 1) = z_ozr3_fp((ii - 1) + size(ozr%vf(ivb + 2)%sf, 1)*((jj - 1) + size(ozr%vf(ivb + 2)%sf, 2)*(kk - 1)) + 1)
          end do
        end do
      end do
      !$acc end parallel loop
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_avg: z: a staging copy failed'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_z

end module m_dace_kernels_visc_avg
#endif
