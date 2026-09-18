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

    ! Order the DaCe kernel against the OpenACC runtime.  The kernel runs on DaCe's OWN cudaStream,
    ! and `cudaStreamCreateWithFlags(..., cudaStreamNonBlocking)` means that stream does NOT
    ! synchronise with the legacy default stream the OpenACC loops use -- so without this the next
    ! OpenACC loop over the same arrays races the kernel that just wrote them.  The working
    ! `m_dace_kernels.fpp` shim calls this around its own staging ("sync pack"); the staging variant
    ! of THIS shim got the ordering for free from its copy-back `!$acc parallel loop`, which is why
    ! the direct form needed it and the staging form did not.
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
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

contains

  !> The master switch AND the per-direction mask in ONE predicate, so a call site CANNOT take the
  !! mask without the switch.  That is a real hazard here, not a stylistic one: the mask defaults to
  !! BOTH directions, so a guard written `visc_avg_dir_enabled(n)` alone turns the kernel on by
  !! default -- which is exactly what the first wiring of this dispatch did.
  !!
  !! `MFC_DACE_VISC_AVG` (unset = ON; `=0` runs the stock loops);
  !! `MFC_DACE_VISC_AVG_DIRS` masks a direction (x z; unset = both), for bisecting.
  function visc_avg_dir_enabled(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    logical, save :: val(2) = [.true., .true.]
    if (.not. cached) then
      ! ON BY DEFAULT (2026-09-18).  It was opt-in at 1.11x SLOWER, and that regression was the
      ! staging: the shim copied every row into a buffer it owned and back out, 2.54 ms of device
      ! time over 864 launches against 0.38 ms and 72 for the kernels themselves.  With the rows
      ! handed over directly -- the M3 dummy form plus a device sync, see the module header -- the
      ! four stock loops it replaces are 0.84 ms of the run's 19.7 ms and the dispatch is FASTER:
      ! the s_get_viscous family goes 3.784 -> 3.336 ms, 144 launches leave the census, and the
      ! field tree is bit-identical on every direction mask (104 files).
      call get_environment_variable('MFC_DACE_VISC_AVG', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) val = env(1:1) /= '0'
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
  !!
  !! `viscous` is not redundant with the caller's own guard.  MFC allocates these gradient arrays
  !! **1x1x1** on the inviscid path (m_rhs.fpp:347), so a dispatch that ever fired there would hand
  !! the kernel the full-size extents the SHIM computes from `size(...)` for a 1x1x1 array -- an
  !! out-of-bounds read, not a wrong number.  What stops that today is the guard on the call itself
  !! (`if (viscous .and. .not. igr)`, m_rhs.fpp:667); stating it here is what stops it after the
  !! next edit to that call site.
  function visc_avg_contract() result(c)
    logical :: c
    c = (num_dims == 3 .and. num_vels == 3 .and. .not. cyl_coord .and. viscous)
  end function visc_avg_contract

  !> The two level-2 x-gradient face averages (both sides of the y-face stencil), one kernel.
  !! The rows are MFC's own: the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0 and the ranges below are raw -- negative ones included, which walk into
  !! the parent's ghost ring by pointer arithmetic exactly as the stock loops do.  No buffers and no
  !! copies: staging every row in and back out cost 2.54 ms of device time over 864 launches
  !! against 0.38 ms and 72 for the kernels themselves.
  subroutine s_dace_visc_avg_x(dxl1, dxl2, dxl3, dxr1, dxr2, dxr3, oxl1, oxl2, oxl3, oxr1, oxr2, oxr3, ext_k, ext_j, k1b, k1e, k2b, k2e, k3b, k3e)
    real(c_double), dimension(:, :, :), intent(in), target :: dxl1
    real(c_double), dimension(:, :, :), intent(in), target :: dxl2
    real(c_double), dimension(:, :, :), intent(in), target :: dxl3
    real(c_double), dimension(:, :, :), intent(in), target :: dxr1
    real(c_double), dimension(:, :, :), intent(in), target :: dxr2
    real(c_double), dimension(:, :, :), intent(in), target :: dxr3
    real(c_double), dimension(:, :, :), intent(inout), target :: oxl1
    real(c_double), dimension(:, :, :), intent(inout), target :: oxl2
    real(c_double), dimension(:, :, :), intent(inout), target :: oxl3
    real(c_double), dimension(:, :, :), intent(inout), target :: oxr1
    real(c_double), dimension(:, :, :), intent(inout), target :: oxr2
    real(c_double), dimension(:, :, :), intent(inout), target :: oxr3
    integer, intent(in) :: ext_k, ext_j, k1b, k1e, k2b, k2e, k3b, k3e
    integer :: ierr, kxb, kxe, lxb, lxe, jlo, jhi, jlb, jre

    call visc_avg_announce(1)

    kxb = k1b + 1
    kxe = k1e - 1
    lxb = k3b
    lxe = k3e
    ! the two arms share ONE nest, so the kernel takes the UNION of their j ranges (jlo..jhi) plus
    ! the two guards that select each arm inside it.  The union is contiguous by construction: the L
    ! arm runs k2b+1..k2e and the R arm k2b..k2e-1.
    jlo = k2b;     jhi = k2e
    jlb = k2b + 1; jre = k2e - 1

    x_dxl1_dev = acc_deviceptr_(c_loc(dxl1(lbound(dxl1, 1), lbound(dxl1, 2), lbound(dxl1, 3))))
    x_dxl2_dev = acc_deviceptr_(c_loc(dxl2(lbound(dxl2, 1), lbound(dxl2, 2), lbound(dxl2, 3))))
    x_dxl3_dev = acc_deviceptr_(c_loc(dxl3(lbound(dxl3, 1), lbound(dxl3, 2), lbound(dxl3, 3))))
    x_dxr1_dev = acc_deviceptr_(c_loc(dxr1(lbound(dxr1, 1), lbound(dxr1, 2), lbound(dxr1, 3))))
    x_dxr2_dev = acc_deviceptr_(c_loc(dxr2(lbound(dxr2, 1), lbound(dxr2, 2), lbound(dxr2, 3))))
    x_dxr3_dev = acc_deviceptr_(c_loc(dxr3(lbound(dxr3, 1), lbound(dxr3, 2), lbound(dxr3, 3))))
    x_oxl1_dev = acc_deviceptr_(c_loc(oxl1(lbound(oxl1, 1), lbound(oxl1, 2), lbound(oxl1, 3))))
    x_oxl2_dev = acc_deviceptr_(c_loc(oxl2(lbound(oxl2, 1), lbound(oxl2, 2), lbound(oxl2, 3))))
    x_oxl3_dev = acc_deviceptr_(c_loc(oxl3(lbound(oxl3, 1), lbound(oxl3, 2), lbound(oxl3, 3))))
    x_oxr1_dev = acc_deviceptr_(c_loc(oxr1(lbound(oxr1, 1), lbound(oxr1, 2), lbound(oxr1, 3))))
    x_oxr2_dev = acc_deviceptr_(c_loc(oxr2(lbound(oxr2, 1), lbound(oxr2, 2), lbound(oxr2, 3))))
    x_oxr3_dev = acc_deviceptr_(c_loc(oxr3(lbound(oxr3, 1), lbound(oxr3, 2), lbound(oxr3, 3))))
    if (.not. c_associated(x_state)) then
      x_state = visc_avg_x_init(int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), int(jre, c_int), &
          & int(kxb, c_int), int(kxe, c_int), int(lxb, c_int), int(lxe, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t))
    end if
    call visc_avg_x_run(x_state, x_dxl1_dev, x_dxl2_dev, x_dxl3_dev, x_dxr1_dev, x_dxr2_dev, x_dxr3_dev, &
        & x_oxl1_dev, x_oxl2_dev, x_oxl3_dev, x_oxr1_dev, x_oxr2_dev, x_oxr3_dev, int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(jhi, c_int), &
        & int(jlb, c_int), int(jlo, c_int), int(jre, c_int), int(kxb, c_int), int(kxe, c_int), &
        & int(lxb, c_int), int(lxe, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t))
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_avg: x: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_x

  !> The two level-2 z-gradient face averages (both sides of the y-face stencil), one kernel.
  !! The rows are MFC's own: the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0 and the ranges below are raw -- negative ones included, which walk into
  !! the parent's ghost ring by pointer arithmetic exactly as the stock loops do.  No buffers and no
  !! copies: staging every row in and back out cost 2.54 ms of device time over 864 launches
  !! against 0.38 ms and 72 for the kernels themselves.
  subroutine s_dace_visc_avg_z(dzl1, dzl2, dzl3, dzr1, dzr2, dzr3, ozl1, ozl2, ozl3, ozr1, ozr2, ozr3, ext_k, ext_j, k1b, k1e, k2b, k2e, k3b, k3e)
    real(c_double), dimension(:, :, :), intent(in), target :: dzl1
    real(c_double), dimension(:, :, :), intent(in), target :: dzl2
    real(c_double), dimension(:, :, :), intent(in), target :: dzl3
    real(c_double), dimension(:, :, :), intent(in), target :: dzr1
    real(c_double), dimension(:, :, :), intent(in), target :: dzr2
    real(c_double), dimension(:, :, :), intent(in), target :: dzr3
    real(c_double), dimension(:, :, :), intent(inout), target :: ozl1
    real(c_double), dimension(:, :, :), intent(inout), target :: ozl2
    real(c_double), dimension(:, :, :), intent(inout), target :: ozl3
    real(c_double), dimension(:, :, :), intent(inout), target :: ozr1
    real(c_double), dimension(:, :, :), intent(inout), target :: ozr2
    real(c_double), dimension(:, :, :), intent(inout), target :: ozr3
    integer, intent(in) :: ext_k, ext_j, k1b, k1e, k2b, k2e, k3b, k3e
    integer :: ierr, kzb, kze, lzb, lze, jlo, jhi, jlb, jre

    call visc_avg_announce(2)

    kzb = k1b
    kze = k1e
    lzb = k3b + 1
    lze = k3e - 1
    ! the two arms share ONE nest, so the kernel takes the UNION of their j ranges (jlo..jhi) plus
    ! the two guards that select each arm inside it.  The union is contiguous by construction: the L
    ! arm runs k2b+1..k2e and the R arm k2b..k2e-1.
    jlo = k2b;     jhi = k2e
    jlb = k2b + 1; jre = k2e - 1

    z_dzl1_dev = acc_deviceptr_(c_loc(dzl1(lbound(dzl1, 1), lbound(dzl1, 2), lbound(dzl1, 3))))
    z_dzl2_dev = acc_deviceptr_(c_loc(dzl2(lbound(dzl2, 1), lbound(dzl2, 2), lbound(dzl2, 3))))
    z_dzl3_dev = acc_deviceptr_(c_loc(dzl3(lbound(dzl3, 1), lbound(dzl3, 2), lbound(dzl3, 3))))
    z_dzr1_dev = acc_deviceptr_(c_loc(dzr1(lbound(dzr1, 1), lbound(dzr1, 2), lbound(dzr1, 3))))
    z_dzr2_dev = acc_deviceptr_(c_loc(dzr2(lbound(dzr2, 1), lbound(dzr2, 2), lbound(dzr2, 3))))
    z_dzr3_dev = acc_deviceptr_(c_loc(dzr3(lbound(dzr3, 1), lbound(dzr3, 2), lbound(dzr3, 3))))
    z_ozl1_dev = acc_deviceptr_(c_loc(ozl1(lbound(ozl1, 1), lbound(ozl1, 2), lbound(ozl1, 3))))
    z_ozl2_dev = acc_deviceptr_(c_loc(ozl2(lbound(ozl2, 1), lbound(ozl2, 2), lbound(ozl2, 3))))
    z_ozl3_dev = acc_deviceptr_(c_loc(ozl3(lbound(ozl3, 1), lbound(ozl3, 2), lbound(ozl3, 3))))
    z_ozr1_dev = acc_deviceptr_(c_loc(ozr1(lbound(ozr1, 1), lbound(ozr1, 2), lbound(ozr1, 3))))
    z_ozr2_dev = acc_deviceptr_(c_loc(ozr2(lbound(ozr2, 1), lbound(ozr2, 2), lbound(ozr2, 3))))
    z_ozr3_dev = acc_deviceptr_(c_loc(ozr3(lbound(ozr3, 1), lbound(ozr3, 2), lbound(ozr3, 3))))
    if (.not. c_associated(z_state)) then
      z_state = visc_avg_z_init(int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(jhi, c_int), int(jlb, c_int), int(jlo, c_int), int(jre, c_int), &
          & int(kzb, c_int), int(kze, c_int), int(lzb, c_int), int(lze, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t))
    end if
    call visc_avg_z_run(z_state, z_dzl1_dev, z_dzl2_dev, z_dzl3_dev, z_dzr1_dev, z_dzr2_dev, z_dzr3_dev, &
        & z_ozl1_dev, z_ozl2_dev, z_ozl3_dev, z_ozr1_dev, z_ozr2_dev, z_ozr3_dev, int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(jhi, c_int), &
        & int(jlb, c_int), int(jlo, c_int), int(jre, c_int), int(kzb, c_int), int(kze, c_int), &
        & int(lzb, c_int), int(lze, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t))
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_avg: z: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_z

end module m_dace_kernels_visc_avg
#endif
