#if defined(MFC_DACE)
module m_dace_kernels_periodic
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, c_double, &
                                         c_associated, c_loc, c_null_ptr
  use m_derived_types
  use m_global_parameters
  use m_constants, only: BC_PERIODIC
  implicit none
  ! The buff the libraries were baked for; CMake refuses a build whose MFC_DACE_BAKED_BUFF differs
  ! from any library's recorded <lib>.baked_buff, so this cannot silently disagree.
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF
  private
  public :: s_dace_periodic, periodic_dace_enabled, periodic_dace_contract

  interface
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function

    subroutine periodic_run_x(state, q1, q2, q3, q4, q5, q6, q7, q8, bb, kb, ke, lb, le, loc, mm1, mw1, &
        & q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) bind(C, name='__program_mfc_dace_periodic_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      type(c_ptr), value :: q4
      type(c_ptr), value :: q5
      type(c_ptr), value :: q6
      type(c_ptr), value :: q7
      type(c_ptr), value :: q8
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end subroutine

    function periodic_init_x(bb, kb, ke, lb, le, loc, mm1, mw1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) &
        bind(C, name='__dace_init_mfc_dace_periodic_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: periodic_init_x
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end function

    function periodic_exit_x(state) bind(C, name='__dace_exit_mfc_dace_periodic_x')
      import :: c_ptr, c_int
      integer(c_int) :: periodic_exit_x
      type(c_ptr), value :: state
    end function

    subroutine periodic_run_y(state, q1, q2, q3, q4, q5, q6, q7, q8, bb, kb, ke, lb, le, loc, mm1, mw1, &
        & q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) bind(C, name='__program_mfc_dace_periodic_y')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      type(c_ptr), value :: q4
      type(c_ptr), value :: q5
      type(c_ptr), value :: q6
      type(c_ptr), value :: q7
      type(c_ptr), value :: q8
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end subroutine

    function periodic_init_y(bb, kb, ke, lb, le, loc, mm1, mw1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) &
        bind(C, name='__dace_init_mfc_dace_periodic_y')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: periodic_init_y
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end function

    function periodic_exit_y(state) bind(C, name='__dace_exit_mfc_dace_periodic_y')
      import :: c_ptr, c_int
      integer(c_int) :: periodic_exit_y
      type(c_ptr), value :: state
    end function

    subroutine periodic_run_z(state, q1, q2, q3, q4, q5, q6, q7, q8, bb, kb, ke, lb, le, loc, mm1, mw1, &
        & q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) bind(C, name='__program_mfc_dace_periodic_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      type(c_ptr), value :: q4
      type(c_ptr), value :: q5
      type(c_ptr), value :: q6
      type(c_ptr), value :: q7
      type(c_ptr), value :: q8
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end subroutine

    function periodic_init_z(bb, kb, ke, lb, le, loc, mm1, mw1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1) &
        bind(C, name='__dace_init_mfc_dace_periodic_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: periodic_init_z
      integer(c_int), value :: bb
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int), value :: loc
      integer(c_int), value :: mm1
      integer(c_int), value :: mw1
      integer(c_int), value :: q1_d0
      integer(c_int), value :: q1_d1
      integer(c_int), value :: q2_d0
      integer(c_int), value :: q2_d1
      integer(c_int), value :: q3_d0
      integer(c_int), value :: q3_d1
      integer(c_int), value :: q4_d0
      integer(c_int), value :: q4_d1
      integer(c_int), value :: q5_d0
      integer(c_int), value :: q5_d1
      integer(c_int), value :: q6_d0
      integer(c_int), value :: q6_d1
      integer(c_int), value :: q7_d0
      integer(c_int), value :: q7_d1
      integer(c_int), value :: q8_d0
      integer(c_int), value :: q8_d1
    end function

    function periodic_exit_z(state) bind(C, name='__dace_exit_mfc_dace_periodic_z')
      import :: c_ptr, c_int
      integer(c_int) :: periodic_exit_z
      type(c_ptr), value :: state
    end function
  end interface

  type(c_ptr), save :: x_state = c_null_ptr, y_state = c_null_ptr, z_state = c_null_ptr
  integer(c_int64_t), save :: x_sig(8) = [-1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t], y_sig(8) = [-1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t], &
                            & z_sig(8) = [-1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t, -1_c_int64_t]
  integer(c_int64_t) :: x_sig_new(8), y_sig_new(8), z_sig_new(8)
  ! The eight rows are the SAME arrays for every call and every direction, so their device addresses
  ! are resolved once and reused (eight lookups per call, over 216 calls a run, cost more than the
  ! kernel saves -- measured).
  type(c_ptr), save :: q1_dev, q2_dev, q3_dev, q4_dev, q5_dev, q6_dev, q7_dev, q8_dev

contains

  !> The switch and the case contract.
  !!
  !! `MFC_DACE_PERIODIC` (unset or 0 = the stock loop, unchanged) turns the kernel on for an edge
  !! whose BC is uniformly periodic; `MFC_DACE_PERIODIC_DIRS` masks a direction (x y z).
  function periodic_dace_enabled(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    logical, save :: cached_val(3) = [.true., .true., .true.]

    if (.not. cached) then
      ! ON BY DEFAULT (2026-09-18); MFC_DACE_PERIODIC=0 falls back to the stock loop.
      ! It was opt-in because an earlier A/B called it a wash -- the stage win was 1.51x then
      ! too (4127 -> 2725 us), but the run's GPU total was 30 ms and the BC stage is ~13% of
      ! it, so the win hid under the metric's noise.  With the other kernels since made
      ! cheaper the same absolute saving is 4.12 -> 2.72 ms of a 21.03 ms total (6.7%), and the
      ! stock kernel `m_boundary_common_s_populate_bc_direction` leaves the census entirely.
      cached_val = .true.
      call get_environment_variable('MFC_DACE_PERIODIC', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1 .and. env(1:1) /= '0') cached_val = .true.
      call get_environment_variable('MFC_DACE_PERIODIC_DIRS', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) then
        cached_val(1) = cached_val(1) .and. env(1:1) == '1'
        cached_val(2) = cached_val(2) .and. (len_trim(env) < 2 .or. env(2:2) == '1')
        cached_val(3) = cached_val(3) .and. (len_trim(env) < 3 .or. env(3:3) == '1')
      end if
      cached = .true.
    end if
    c = cached_val(nd)
  end function periodic_dace_enabled

  !> The bake's case contract.  No `.not. polytropic` clause: the only polytropic-dependent code in
  !! s_periodic is the QBMM block (which `.not. qbmm` already excludes) and polytropic is TRUE by
  !! default in MFC -- testing it made the dispatch silently never fire.
  function periodic_dace_contract() result(c)
    logical :: c
    c = (num_dims == 3 .and. sys_size == 8 .and. &
         & .not. chemistry .and. .not. qbmm .and. &
         & buff_size == BAKED_BUFF_SIZE)
  end function periodic_dace_contract

  !> Say ONCE per direction that the kernel engaged.  A stack of bit-identical comparisons cannot
  !! tell two paths apart -- a dispatch that never fired has passed a gate in this project -- so the
  !! run log has to carry which path it took.  (M3 and the fused averages already do this; the
  !! periodic dispatch was the one without it.)
  subroutine periodic_announce(nd)
    integer, intent(in) :: nd
    logical, save :: said(3) = [.false., .false., .false.]
    character(len=1), parameter :: tag(3) = ['x', 'y', 'z']
    if (.not. said(nd)) then
      said(nd) = .true.
      print '(a)', 'm_dace_kernels_periodic: ' // tag(nd) // ' engaged (MFC_DACE_PERIODIC)'
    end if
  end subroutine periodic_announce

  !> Populate the periodic ghost planes for one edge, replacing the stock per-cell loop.
  !!
  !! `k_beg..k_end` / `l_beg..l_end` are the RAW transverse ranges the caller's loop covers (they
  !! differ per direction, exactly as s_populate_bc_direction sets them) and are converted here into
  !! the kernel's frame -- `index = raw + buff_size`, hence `+ bb` on all four.
  subroutine s_dace_periodic(dir_in, loc_in, q1, q2, q3, q4, q5, q6, q7, q8, &
                             & k_beg, k_end, l_beg, l_end)
    integer, intent(in) :: dir_in, loc_in, k_beg, k_end, l_beg, l_end
    real(wp), dimension(idwbuff(1)%beg:, idwbuff(2)%beg:, idwbuff(3)%beg:), intent(inout), target :: &
        & q1, q2, q3, q4, q5, q6, q7, q8
    integer :: bb, kb, ke, lb, le, loc, mm1, mw1, nsweep, ierr

    bb = buff_size
    kb = k_beg + bb
    ke = k_end + bb
    lb = l_beg + bb
    le = l_end + bb
    loc = merge(-1, 1, loc_in == -1)
    select case (dir_in)
    case (2); nsweep = n
    case (3); nsweep = p
    case default; nsweep = m
    end select
    mm1 = nsweep + 1
    mw1 = nsweep + bb + 1

    call periodic_announce(dir_in)

    ! resolve the device addresses once: on the first call, and again only if some state was absent
    if (.not. (c_associated(x_state) .and. c_associated(y_state) .and. c_associated(z_state))) then
      q1_dev = acc_deviceptr_(c_loc(q1(lbound(q1, 1), lbound(q1, 2), lbound(q1, 3))))
      q2_dev = acc_deviceptr_(c_loc(q2(lbound(q2, 1), lbound(q2, 2), lbound(q2, 3))))
      q3_dev = acc_deviceptr_(c_loc(q3(lbound(q3, 1), lbound(q3, 2), lbound(q3, 3))))
      q4_dev = acc_deviceptr_(c_loc(q4(lbound(q4, 1), lbound(q4, 2), lbound(q4, 3))))
      q5_dev = acc_deviceptr_(c_loc(q5(lbound(q5, 1), lbound(q5, 2), lbound(q5, 3))))
      q6_dev = acc_deviceptr_(c_loc(q6(lbound(q6, 1), lbound(q6, 2), lbound(q6, 3))))
      q7_dev = acc_deviceptr_(c_loc(q7(lbound(q7, 1), lbound(q7, 2), lbound(q7, 3))))
      q8_dev = acc_deviceptr_(c_loc(q8(lbound(q8, 1), lbound(q8, 2), lbound(q8, 3))))
    end if

    select case (dir_in)
    case (1)   ! x
      x_sig_new(1:8) = [int(bb, c_int64_t), int(kb, c_int64_t), int(ke, c_int64_t), int(lb, c_int64_t), int(le, c_int64_t), int(loc, c_int64_t), int(mm1, c_int64_t), int(mw1, c_int64_t)]
      if (.not. c_associated(x_state) .or. any(x_sig(1:8) /= x_sig_new(1:8))) then
        if (c_associated(x_state)) ierr = periodic_exit_x(x_state)
        x_sig(1:8) = x_sig_new(1:8)
        x_state = periodic_init_x(int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
      end if
      call periodic_run_x(x_state, q1_dev, q2_dev, q3_dev, q4_dev, q5_dev, q6_dev, q7_dev, q8_dev, int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
    case (2)   ! y
      y_sig_new(1:8) = [int(bb, c_int64_t), int(kb, c_int64_t), int(ke, c_int64_t), int(lb, c_int64_t), int(le, c_int64_t), int(loc, c_int64_t), int(mm1, c_int64_t), int(mw1, c_int64_t)]
      if (.not. c_associated(y_state) .or. any(y_sig(1:8) /= y_sig_new(1:8))) then
        if (c_associated(y_state)) ierr = periodic_exit_y(y_state)
        y_sig(1:8) = y_sig_new(1:8)
        y_state = periodic_init_y(int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
      end if
      call periodic_run_y(y_state, q1_dev, q2_dev, q3_dev, q4_dev, q5_dev, q6_dev, q7_dev, q8_dev, int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
    case (3)   ! z
      z_sig_new(1:8) = [int(bb, c_int64_t), int(kb, c_int64_t), int(ke, c_int64_t), int(lb, c_int64_t), int(le, c_int64_t), int(loc, c_int64_t), int(mm1, c_int64_t), int(mw1, c_int64_t)]
      if (.not. c_associated(z_state) .or. any(z_sig(1:8) /= z_sig_new(1:8))) then
        if (c_associated(z_state)) ierr = periodic_exit_z(z_state)
        z_sig(1:8) = z_sig_new(1:8)
        z_state = periodic_init_z(int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
      end if
      call periodic_run_z(z_state, q1_dev, q2_dev, q3_dev, q4_dev, q5_dev, q6_dev, q7_dev, q8_dev, int(bb, c_int), int(kb, c_int), int(ke, c_int), int(lb, c_int), int(le, c_int), int(loc, c_int), int(mm1, c_int), int(mw1, c_int), int(size(q1, 1), c_int), int(size(q1, 2), c_int), int(size(q2, 1), c_int), int(size(q2, 2), c_int), int(size(q3, 1), c_int), int(size(q3, 2), c_int), int(size(q4, 1), c_int), int(size(q4, 2), c_int), int(size(q5, 1), c_int), int(size(q5, 2), c_int), int(size(q6, 1), c_int), int(size(q6, 2), c_int), int(size(q7, 1), c_int), int(size(q7, 2), c_int), int(size(q8, 1), c_int), int(size(q8, 2), c_int))
    end select
    if (ierr == -2) then
      print *, 'm_dace_kernels_periodic: a row is not device-present'
      error stop 1
    end if
  end subroutine s_dace_periodic

end module m_dace_kernels_periodic
#endif
