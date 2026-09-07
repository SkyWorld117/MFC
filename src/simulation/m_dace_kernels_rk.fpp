!! @brief P2/T2.3 — the RK-stage dispatch shim (libmfc_dace_rk.so).
!!
!! The kernel is the casopt-baked build of the s_tvd_rk stage-combination
!! loop (rk_stage_mfc_prod TU): sys_size/stor/nstage/igr baked, dt passed by
!! value (case config), m/n/p runtime, rk_coef a device array.  The shim
!! packs the interior (0:m, 0:n, 0:p) of q_cons_ts(1)%vf / q_cons_ts(stor)%vf
!! and rhs_vf into the kernel's flat (stage, eqn, j, k, l) layout (1-based
!! flat = raw + 1), runs one stage, and unpacks both stages.
#if defined(MFC_DACE)
module m_dace_kernels_rk
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, &
                                         c_double, c_bool, c_associated, c_loc, &
                                         c_f_pointer, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_rk_stage

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

  interface
    subroutine rk_run(state, dt, igr, q1, q2, q3, q4, q5, q6, q7, q8, &
                      qs1, qs2, qs3, qs4, qs5, qs6, qs7, qs8, &
                      r1, r2, r3, r4, r5, r6, r7, r8, rk_coef, &
                      stor, sys_size, m, n, p, &
                      q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, &
                      q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1, &
                      qs1_d0, qs1_d1, qs2_d0, qs2_d1, qs3_d0, qs3_d1, qs4_d0, &
                      qs4_d1, qs5_d0, qs5_d1, qs6_d0, qs6_d1, qs7_d0, qs7_d1, &
                      qs8_d0, qs8_d1, r1_d0, r1_d1, r2_d0, r2_d1, r3_d0, r3_d1, &
                      r4_d0, r4_d1, r5_d0, r5_d1, r6_d0, r6_d1, r7_d0, r7_d1, &
                      r8_d0, r8_d1, s) &
        bind(C, name='__program_mfc_dace_rk')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dt, igr
      type(c_ptr), value :: q1, q2, q3, q4, q5, q6, q7, q8
      type(c_ptr), value :: qs1, qs2, qs3, qs4, qs5, qs6, qs7, qs8
      type(c_ptr), value :: r1, r2, r3, r4, r5, r6, r7, r8
      type(c_ptr), value :: rk_coef
      integer(c_int), value :: stor, sys_size
      integer(c_int), value :: m, n, p
      integer(c_int64_t), value :: q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, &
                                   q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, &
                                   q7_d0, q7_d1, q8_d0, q8_d1
      integer(c_int64_t), value :: qs1_d0, qs1_d1, qs2_d0, qs2_d1, qs3_d0, &
                                   qs3_d1, qs4_d0, qs4_d1, qs5_d0, qs5_d1, &
                                   qs6_d0, qs6_d1, qs7_d0, qs7_d1, qs8_d0, qs8_d1
      integer(c_int64_t), value :: r1_d0, r1_d1, r2_d0, r2_d1, r3_d0, r3_d1, &
                                   r4_d0, r4_d1, r5_d0, r5_d1, r6_d0, r6_d1, &
                                   r7_d0, r7_d1, r8_d0, r8_d1
      integer(c_int), value :: s
    end subroutine

    function rk_init(dt, igr, m, n, p, &
                     q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, q4_d0, q4_d1, &
                     q5_d0, q5_d1, q6_d0, q6_d1, q7_d0, q7_d1, q8_d0, q8_d1, &
                     qs1_d0, qs1_d1, qs2_d0, qs2_d1, qs3_d0, qs3_d1, qs4_d0, &
                     qs4_d1, qs5_d0, qs5_d1, qs6_d0, qs6_d1, qs7_d0, qs7_d1, &
                     qs8_d0, qs8_d1, r1_d0, r1_d1, r2_d0, r2_d1, r3_d0, r3_d1, &
                     r4_d0, r4_d1, r5_d0, r5_d1, r6_d0, r6_d1, r7_d0, r7_d1, &
                     r8_d0, r8_d1, s) &
        bind(C, name='__dace_init_mfc_dace_rk')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: rk_init
      type(c_ptr), value :: dt, igr
      integer(c_int), value :: m, n, p
      integer(c_int64_t), value :: q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, &
                                   q4_d0, q4_d1, q5_d0, q5_d1, q6_d0, q6_d1, &
                                   q7_d0, q7_d1, q8_d0, q8_d1
      integer(c_int64_t), value :: qs1_d0, qs1_d1, qs2_d0, qs2_d1, qs3_d0, &
                                   qs3_d1, qs4_d0, qs4_d1, qs5_d0, qs5_d1, &
                                   qs6_d0, qs6_d1, qs7_d0, qs7_d1, qs8_d0, qs8_d1
      integer(c_int64_t), value :: r1_d0, r1_d1, r2_d0, r2_d1, r3_d0, r3_d1, &
                                   r4_d0, r4_d1, r5_d0, r5_d1, r6_d0, r6_d1, &
                                   r7_d0, r7_d1, r8_d0, r8_d1
      integer(c_int), value :: s
    end function

    function rk_exit(state) bind(C, name='__dace_exit_mfc_dace_rk')
      import :: c_ptr, c_int
      integer(c_int) :: rk_exit
      type(c_ptr), value :: state
    end function
  end interface

  type(c_ptr), save :: d_qts = c_null_ptr, d_rhs = c_null_ptr
  interface
    !> NVHPC's OpenACC runtime: map a host address to its device address
    !! (c_null_ptr when the host address has no device copy)
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function
  end interface

  type(c_ptr), save :: d_rkc = c_null_ptr
  integer(c_size_t), save :: cap_q = 0_c_size_t, cap_r = 0_c_size_t
  type(c_ptr), save :: state_rk = c_null_ptr
  integer, save :: state_m = -1, state_s = -1
  real(c_double), target, save :: dt_host = 0.0_c_double
  logical(c_bool), target, save :: igr_host = .false.

contains

  subroutine chk(ierr, what)
    integer(c_int), intent(in) :: ierr
    character(*), intent(in) :: what
    if (ierr /= 0_c_int) then
      print *, 'm_dace_kernels_rk: CUDA error in ', what, ': code=', ierr
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

  !> One TVD-RK stage over the interior (0:m, 0:n, 0:p).  s = stage index.
  !! The time-stepper module data comes in as arguments: the shim must not
  !! `use m_time_steppers` (m_time_steppers uses this module — a circular
  !! module use is uncompilable Fortran).
  subroutine s_dace_rk_stage(s_in, rk_coef_l, q_cons_ts_l, rhs_vf_l, &
                             stor_l, sys_size_l)
    !> DIRECT MFC-layout dispatch: the kernel takes the 24 interior field
    !! sections as raw device pointers (acc_deviceptr of c_loc'd interior
    !! starts) — no staging buffers, no transposes.  The combine is
    !! pointwise and the bridge maps each branch to ONE coalesced kernel.
    integer, intent(in) :: s_in
    real(wp), intent(in) :: rk_coef_l(:, :)
    type(vector_field), intent(inout) :: q_cons_ts_l(:)
    type(scalar_field), intent(in) :: rhs_vf_l(:)
    integer, intent(in) :: stor_l, sys_size_l

    real(c_double), allocatable, target :: rkcf(:, :)
    integer :: i, j, mi, ni, pi
    integer(c_size_t) :: bytes_c
    integer(c_int) :: ierr
    integer(c_int64_t) :: mext, d0, d1, rd0, rd1
    type(c_ptr) :: qptr(8), qsptr(8), rptr(8)
    real(wp), pointer :: fp(:,:,:)
    character(len=32) :: pr_env
    integer :: pr_st
    real(c_double) :: pr_dev

    call get_environment_variable('MFC_EVOLVE_DEBUG', pr_env, status=pr_st)
    if (pr_st == 0) then
      pr_dev = -1.0_c_double
      !$acc parallel loop
      do j = 0, 0
        pr_dev = q_cons_ts_l(1)%vf(6)%sf(16, 16, 16)
      end do
      !$acc end parallel loop
      ierr = cudaDeviceSynchronize_()
      print *, 'EVDBG stage', s_in, ' E(16,16,16) device=', pr_dev
    end if

    mi = m; ni = n; pi = p
    if (s_in > size(rk_coef_l, 1)) then
      print *, 'm_dace_kernels_rk: rk_coef rows=', size(rk_coef_l, 1), &
               ' < stage=', s_in
      error stop 1
    end if

    allocate(rkcf(size(rk_coef_l, 1), 4))
    rkcf = real(rk_coef_l(1:size(rk_coef_l, 1), 1:4), c_double)
    bytes_c = int(size(rk_coef_l, 1)*4*8, c_size_t)
    call ensure_buf(d_rkc, cap_r, bytes_c, 'rk_coef')
    ierr = cudaMemcpy_(d_rkc, c_loc(rkcf), bytes_c, cpH2D)
    call chk(ierr, 'H2D rk_coef')

    ! interior field sections' device addresses (the declare-created
    ! device copies; the raw-pointer pattern from the sweeps dispatch)
    do i = 1, 8
      fp => q_cons_ts_l(1)%vf(i)%sf
      qptr(i) = acc_deviceptr_(c_loc(fp(0, 0, 0)))
      fp => q_cons_ts_l(stor_l)%vf(i)%sf
      qsptr(i) = acc_deviceptr_(c_loc(fp(0, 0, 0)))
      fp => rhs_vf_l(i)%sf
      rptr(i) = acc_deviceptr_(c_loc(fp(0, 0, 0)))
    end do
    do i = 1, 8
      if (qptr(i) == c_null_ptr .or. qsptr(i) == c_null_ptr .or. &
          rptr(i) == c_null_ptr) then
        print *, 'm_dace_kernels_rk: rk field not device-present'
        error stop 1
      end if
    end do

    if (pr_st == 0) then
      block
        real(c_double), pointer :: pr6(:,:,:)
        integer :: ex, ey
        integer(c_size_t) :: off
        real(c_double) :: pr_raw
        call c_f_pointer(qptr(6), pr6, [int(size(q_cons_ts_l(1)%vf(6)%sf, 1)), &
                                        int(size(q_cons_ts_l(1)%vf(6)%sf, 2)), &
                                        int(size(q_cons_ts_l(1)%vf(6)%sf, 3))])
        ex = size(q_cons_ts_l(1)%vf(6)%sf, 1)
        ey = size(q_cons_ts_l(1)%vf(6)%sf, 2)
        ! the kernel's interior (16,16,16) = the raw offset 16 + ex*(16 + ey*16)
        off = int(16, c_size_t) + int(ex, c_size_t)* &
              (int(16, c_size_t) + int(ey, c_size_t)*int(16, c_size_t))
        block
          integer(c_int64_t) :: iaddr
          type(c_ptr) :: padd
          iaddr = transfer(qptr(6), 0_c_int64_t) + off*8_c_int64_t
          padd = transfer(iaddr, c_null_ptr)
          ierr = cudaMemcpy_(c_loc(pr_raw), padd, 8_c_size_t, cpD2H)
          call chk(ierr, 'probe raw')
        end block
        print *, 'EVDBG rawptr E(16,16,16)=', pr_raw
      end block
    end if

    ! the kernel's (0:,0:,0:) dummies: stride(j) = 1, stride(k) = d0,
    ! stride(l) = d0*d1 — the strides of the FULL padded field (the ghost
    ! cells sit between the interior rows), not the interior extent
    fp => q_cons_ts_l(1)%vf(1)%sf
    d0 = int(size(fp, 1), c_int64_t)
    d1 = int(size(fp, 2), c_int64_t)
    mext = d0
    ! the rhs fields are allocated EXACTLY (0:m, 0:n, 0:p) when igr=F —
    ! their strides differ from the ghost-padded q fields
    fp => rhs_vf_l(1)%sf
    rd0 = int(size(fp, 1), c_int64_t)
    rd1 = int(size(fp, 2), c_int64_t)

    if (state_m /= mi .or. state_s /= s_in) then
      if (c_associated(state_rk)) then
        ierr = rk_exit(state_rk)
      end if
      dt_host = real(dt, c_double)
      igr_host = .false.
      state_rk = rk_init(c_loc(dt_host), c_loc(igr_host), &
                         int(mi, c_int), int(ni, c_int), int(pi, c_int), &
                         d0, d1, d0, d1, d0, d1, d0, d1, &
                         d0, d1, d0, d1, d0, d1, d0, d1, &
                         d0, d1, d0, d1, d0, d1, d0, d1, &
                         d0, d1, d0, d1, d0, d1, d0, d1, &
                         rd0, rd1, rd0, rd1, rd0, rd1, rd0, rd1, &
                         rd0, rd1, rd0, rd1, rd0, rd1, rd0, rd1, &
                         int(s_in, c_int))
      state_m = mi; state_s = s_in
    end if

    call rk_run(state_rk, c_loc(dt_host), c_loc(igr_host), &
                qptr(1), qptr(2), qptr(3), qptr(4), &
                qptr(5), qptr(6), qptr(7), qptr(8), &
                qsptr(1), qsptr(2), qsptr(3), qsptr(4), &
                qsptr(5), qsptr(6), qsptr(7), qsptr(8), &
                rptr(1), rptr(2), rptr(3), rptr(4), &
                rptr(5), rptr(6), rptr(7), rptr(8), &
                d_rkc, int(stor_l, c_int), int(sys_size_l, c_int), &
                int(mi, c_int), int(ni, c_int), int(pi, c_int), &
                d0, d1, d0, d1, d0, d1, d0, d1, &
                d0, d1, d0, d1, d0, d1, d0, d1, &
                d0, d1, d0, d1, d0, d1, d0, d1, &
                d0, d1, d0, d1, d0, d1, d0, d1, &
                rd0, rd1, rd0, rd1, rd0, rd1, rd0, rd1, &
                rd0, rd1, rd0, rd1, rd0, rd1, rd0, rd1, &
                int(s_in, c_int))
    ! (no post-kernel sync: the lib stream-syncs internally)

    deallocate (rkcf)
  end subroutine s_dace_rk_stage

end module m_dace_kernels_rk

#endif