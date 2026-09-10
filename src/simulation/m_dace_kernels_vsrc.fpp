#if defined(MFC_DACE)
!! @brief Contains module m_dace_kernels_vsrc
!!
!! P2/L2 — the DaCe Cartesian viscous-source dispatch (x direction). The
!! libmfc_dace_vsrc_x.so kernel reads the 18 dvel 3-D fields + re_avg +
!! vel_src IN PLACE and read-modify-writes the 4 fsrc rows IN PLACE, so
!! the shim passes raw device pointers with ZERO staging. The y/z dirs
!! fall back to the native OpenACC kernel (the transposed-index variants
!! are a follow-up).
module m_dace_kernels_vsrc
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, &
                                         c_associated, c_loc, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_vsrc_x, vsrc_dace_contract, vsrc_dace_mode

  interface
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function
    function vsrc_init( &
        dvl_dx1_d0, dvl_dx1_d1, dvl_dx2_d0, dvl_dx2_d1, dvl_dx3_d0, dvl_dx3_d1, &
        dvl_dy1_d0, dvl_dy1_d1, dvl_dy2_d0, dvl_dy2_d1, dvl_dy3_d0, dvl_dy3_d1, &
        dvl_dz1_d0, dvl_dz1_d1, dvl_dz2_d0, dvl_dz2_d1, dvl_dz3_d0, dvl_dz3_d1, &
        dvr_dx1_d0, dvr_dx1_d1, dvr_dx2_d0, dvr_dx2_d1, dvr_dx3_d0, dvr_dx3_d1, &
        dvr_dy1_d0, dvr_dy1_d1, dvr_dy2_d0, dvr_dy2_d1, dvr_dy3_d0, dvr_dy3_d1, &
        dvr_dz1_d0, dvr_dz1_d1, dvr_dz2_d0, dvr_dz2_d1, dvr_dz3_d0, dvr_dz3_d1, &
        fsrc3_d0, fsrc3_d1, fsrc4_d0, fsrc4_d1, fsrc5_d0, fsrc5_d1, &
        fsrc6_d0, fsrc6_d1, jb, je, kb, ke, lb, le, &
        re_avg_d0, re_avg_d1, re_avg_d2, vel_src_d0, vel_src_d1, vel_src_d2) &
        & bind(C, name='__dace_init_mfc_dace_vsrc_x')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: vsrc_init
      integer(c_int64_t), value :: dvl_dx1_d0, dvl_dx1_d1
      integer(c_int64_t), value :: dvl_dx2_d0, dvl_dx2_d1
      integer(c_int64_t), value :: dvl_dx3_d0, dvl_dx3_d1
      integer(c_int64_t), value :: dvl_dy1_d0, dvl_dy1_d1
      integer(c_int64_t), value :: dvl_dy2_d0, dvl_dy2_d1
      integer(c_int64_t), value :: dvl_dy3_d0, dvl_dy3_d1
      integer(c_int64_t), value :: dvl_dz1_d0, dvl_dz1_d1
      integer(c_int64_t), value :: dvl_dz2_d0, dvl_dz2_d1
      integer(c_int64_t), value :: dvl_dz3_d0, dvl_dz3_d1
      integer(c_int64_t), value :: dvr_dx1_d0, dvr_dx1_d1
      integer(c_int64_t), value :: dvr_dx2_d0, dvr_dx2_d1
      integer(c_int64_t), value :: dvr_dx3_d0, dvr_dx3_d1
      integer(c_int64_t), value :: dvr_dy1_d0, dvr_dy1_d1
      integer(c_int64_t), value :: dvr_dy2_d0, dvr_dy2_d1
      integer(c_int64_t), value :: dvr_dy3_d0, dvr_dy3_d1
      integer(c_int64_t), value :: dvr_dz1_d0, dvr_dz1_d1
      integer(c_int64_t), value :: dvr_dz2_d0, dvr_dz2_d1
      integer(c_int64_t), value :: dvr_dz3_d0, dvr_dz3_d1
      integer(c_int64_t), value :: fsrc3_d0, fsrc3_d1
      integer(c_int64_t), value :: fsrc4_d0, fsrc4_d1
      integer(c_int64_t), value :: fsrc5_d0, fsrc5_d1
      integer(c_int64_t), value :: fsrc6_d0, fsrc6_d1
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: re_avg_d0, re_avg_d1, re_avg_d2
      integer(c_int64_t), value :: vel_src_d0, vel_src_d1, vel_src_d2
    end function
    function vsrc_exit(state) bind(C, name='__dace_exit_mfc_dace_vsrc_x')
      import :: c_ptr, c_int
      integer(c_int) :: vsrc_exit
      type(c_ptr), value :: state
    end function
    subroutine vsrc_run(state, &
        dvl_dx1, dvl_dx2, dvl_dx3, dvl_dy1, dvl_dy2, dvl_dy3, &
        dvl_dz1, dvl_dz2, dvl_dz3, dvr_dx1, dvr_dx2, dvr_dx3, &
        dvr_dy1, dvr_dy2, dvr_dy3, dvr_dz1, dvr_dz2, dvr_dz3, &
        fsrc3, fsrc4, fsrc5, fsrc6, re_avg, vel_src, &
        dvl_dx1_d0, dvl_dx1_d1, dvl_dx2_d0, dvl_dx2_d1, dvl_dx3_d0, dvl_dx3_d1, &
        dvl_dy1_d0, dvl_dy1_d1, dvl_dy2_d0, dvl_dy2_d1, dvl_dy3_d0, dvl_dy3_d1, &
        dvl_dz1_d0, dvl_dz1_d1, dvl_dz2_d0, dvl_dz2_d1, dvl_dz3_d0, dvl_dz3_d1, &
        dvr_dx1_d0, dvr_dx1_d1, dvr_dx2_d0, dvr_dx2_d1, dvr_dx3_d0, dvr_dx3_d1, &
        dvr_dy1_d0, dvr_dy1_d1, dvr_dy2_d0, dvr_dy2_d1, dvr_dy3_d0, dvr_dy3_d1, &
        dvr_dz1_d0, dvr_dz1_d1, dvr_dz2_d0, dvr_dz2_d1, dvr_dz3_d0, dvr_dz3_d1, &
        fsrc3_d0, fsrc3_d1, fsrc4_d0, fsrc4_d1, fsrc5_d0, fsrc5_d1, &
        fsrc6_d0, fsrc6_d1, jb, je, kb, ke, lb, le, &
        re_avg_d0, re_avg_d1, re_avg_d2, vel_src_d0, vel_src_d1, vel_src_d2) &
        & bind(C, name='__program_mfc_dace_vsrc_x')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: dvl_dx1, dvl_dx2, dvl_dx3
      type(c_ptr), value :: dvl_dy1, dvl_dy2, dvl_dy3
      type(c_ptr), value :: dvl_dz1, dvl_dz2, dvl_dz3
      type(c_ptr), value :: dvr_dx1, dvr_dx2, dvr_dx3
      type(c_ptr), value :: dvr_dy1, dvr_dy2, dvr_dy3
      type(c_ptr), value :: dvr_dz1, dvr_dz2, dvr_dz3
      type(c_ptr), value :: fsrc3, fsrc4, fsrc5, fsrc6
      type(c_ptr), value :: re_avg, vel_src
      integer(c_int64_t), value :: dvl_dx1_d0, dvl_dx1_d1
      integer(c_int64_t), value :: dvl_dx2_d0, dvl_dx2_d1
      integer(c_int64_t), value :: dvl_dx3_d0, dvl_dx3_d1
      integer(c_int64_t), value :: dvl_dy1_d0, dvl_dy1_d1
      integer(c_int64_t), value :: dvl_dy2_d0, dvl_dy2_d1
      integer(c_int64_t), value :: dvl_dy3_d0, dvl_dy3_d1
      integer(c_int64_t), value :: dvl_dz1_d0, dvl_dz1_d1
      integer(c_int64_t), value :: dvl_dz2_d0, dvl_dz2_d1
      integer(c_int64_t), value :: dvl_dz3_d0, dvl_dz3_d1
      integer(c_int64_t), value :: dvr_dx1_d0, dvr_dx1_d1
      integer(c_int64_t), value :: dvr_dx2_d0, dvr_dx2_d1
      integer(c_int64_t), value :: dvr_dx3_d0, dvr_dx3_d1
      integer(c_int64_t), value :: dvr_dy1_d0, dvr_dy1_d1
      integer(c_int64_t), value :: dvr_dy2_d0, dvr_dy2_d1
      integer(c_int64_t), value :: dvr_dy3_d0, dvr_dy3_d1
      integer(c_int64_t), value :: dvr_dz1_d0, dvr_dz1_d1
      integer(c_int64_t), value :: dvr_dz2_d0, dvr_dz2_d1
      integer(c_int64_t), value :: dvr_dz3_d0, dvr_dz3_d1
      integer(c_int64_t), value :: fsrc3_d0, fsrc3_d1
      integer(c_int64_t), value :: fsrc4_d0, fsrc4_d1
      integer(c_int64_t), value :: fsrc5_d0, fsrc5_d1
      integer(c_int64_t), value :: fsrc6_d0, fsrc6_d1
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: re_avg_d0, re_avg_d1, re_avg_d2
      integer(c_int64_t), value :: vel_src_d0, vel_src_d1, vel_src_d2
    end subroutine
  end interface

#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 4
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF

  type(c_ptr), save :: state_vsrc = c_null_ptr
  integer, save :: state_b(6) = -1, state_ext = -1

contains

  !> Runtime mode: unset/"0" -> 1 (the DaCe kernel), "1" -> 0 (the OpenACC).
  function vsrc_dace_mode() result(m)
    integer :: m
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    integer, save :: cached_val = 1
    if (.not. cached) then
      cached_val = 1
      call get_environment_variable('MFC_DACE_VSRC_OFF', env, status=st)
      if (st == 0) then
        if (trim(env) == '1') cached_val = 0
      end if
      cached = .true.
    end if
    m = cached_val
  end function vsrc_dace_mode

  !> The dispatch's bake contract: the 3-D Cartesian, the non-Newtonian OFF,
  !! the shear+bulk ON, the 5-eq. Any violation falls back to the OpenACC.
  function vsrc_dace_contract() result(c)
    logical :: c
    c = (num_dims == 3 .and. model_eqns == 2 .and. &
         & .not. any_non_newtonian .and. shear_stress .and. bulk_stress .and. &
         & .not. cyl_coord .and. .not. chemistry .and. .not. qbmm)
  end function vsrc_dace_contract

  !> DaCe Cartesian viscous-source (dir 1). The dvel fields = the
  !! scalar_field 3-D arrays (the fdiff outputs); the fsrc rows = the
  !! flux_src_n(id)%vf(3..6)%sf; re_avg/vel_src = the module rsx arrays.
  subroutine s_dace_vsrc_x(dvL_dx1, dvL_dx2, dvL_dx3, dvL_dy1, dvL_dy2, dvL_dy3, &
                           & dvL_dz1, dvL_dz2, dvL_dz3, dvR_dx1, dvR_dx2, dvR_dx3, &
                           & dvR_dy1, dvR_dy2, dvR_dy3, dvR_dz1, dvR_dz2, dvR_dz3, &
                           & fsrc3, fsrc4, fsrc5, fsrc6, re_avg, vel_src, &
                           & jb_in, je_in, kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :), intent(in), target :: dvL_dx1(1:, 1:, 1:), dvL_dx2(1:, 1:, 1:), dvL_dx3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(in), target :: dvL_dy1(1:, 1:, 1:), dvL_dy2(1:, 1:, 1:), dvL_dy3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(in), target :: dvL_dz1(1:, 1:, 1:), dvL_dz2(1:, 1:, 1:), dvL_dz3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(in), target :: dvR_dx1(1:, 1:, 1:), dvR_dx2(1:, 1:, 1:), dvR_dx3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(in), target :: dvR_dy1(1:, 1:, 1:), dvR_dy2(1:, 1:, 1:), dvR_dy3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(in), target :: dvR_dz1(1:, 1:, 1:), dvR_dz2(1:, 1:, 1:), dvR_dz3(1:, 1:, 1:)
    real(wp), dimension(:, :, :), intent(inout), target :: fsrc3(1:, 1:, 1:), fsrc4(1:, 1:, 1:), fsrc5(1:, 1:, 1:), fsrc6(1:, 1:, 1:)
    real(wp), dimension(:, :, :, :), intent(in), target :: re_avg(0:, 0:, 0:, 1:), vel_src(0:, 0:, 0:, 1:)
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in

    integer :: ext, b(6)
    type(c_ptr) :: dp(18), fp(4), ra_dev, vs_dev
    integer(c_int) :: ierr
    integer :: i

    ext = size(dvL_dx1, 1)
    if (size(dvL_dx1, 2) /= ext .or. size(dvL_dx1, 3) /= ext .or. &
        & size(fsrc3, 1) /= ext .or. size(fsrc3, 2) /= ext .or. &
        & size(fsrc3, 3) /= ext) then
      print *, 'm_dace_kernels_vsrc: non-cubic vsrc extents', ext
      error stop 1
    end if

    ! the bases = the element (raw jb) of each array: the kernel's [j0] = the raw jb+j0.
    ! The dvel/fsrc = (idwbuff%beg:) = the raw - (-1-buff); the re/vel = (-1:) = the raw+1.
    ! buff = BAKED_BUFF_SIZE; the raw jb = -1 (the dir 1) → the dvel/fsrc base = the
    ! lbound + buff; the re/vel base = the lbound.
    dp(1) = acc_deviceptr_(c_loc(dvL_dx1(lbound(dvL_dx1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dx1,2)+BAKED_BUFF_SIZE, lbound(dvL_dx1,3)+BAKED_BUFF_SIZE)))
    dp(2) = acc_deviceptr_(c_loc(dvL_dx2(lbound(dvL_dx2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dx2,2)+BAKED_BUFF_SIZE, lbound(dvL_dx2,3)+BAKED_BUFF_SIZE)))
    dp(3) = acc_deviceptr_(c_loc(dvL_dx3(lbound(dvL_dx3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dx3,2)+BAKED_BUFF_SIZE, lbound(dvL_dx3,3)+BAKED_BUFF_SIZE)))
    dp(4) = acc_deviceptr_(c_loc(dvL_dy1(lbound(dvL_dy1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dy1,2)+BAKED_BUFF_SIZE, lbound(dvL_dy1,3)+BAKED_BUFF_SIZE)))
    dp(5) = acc_deviceptr_(c_loc(dvL_dy2(lbound(dvL_dy2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dy2,2)+BAKED_BUFF_SIZE, lbound(dvL_dy2,3)+BAKED_BUFF_SIZE)))
    dp(6) = acc_deviceptr_(c_loc(dvL_dy3(lbound(dvL_dy3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dy3,2)+BAKED_BUFF_SIZE, lbound(dvL_dy3,3)+BAKED_BUFF_SIZE)))
    dp(7) = acc_deviceptr_(c_loc(dvL_dz1(lbound(dvL_dz1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dz1,2)+BAKED_BUFF_SIZE, lbound(dvL_dz1,3)+BAKED_BUFF_SIZE)))
    dp(8) = acc_deviceptr_(c_loc(dvL_dz2(lbound(dvL_dz2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dz2,2)+BAKED_BUFF_SIZE, lbound(dvL_dz2,3)+BAKED_BUFF_SIZE)))
    dp(9) = acc_deviceptr_(c_loc(dvL_dz3(lbound(dvL_dz3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvL_dz3,2)+BAKED_BUFF_SIZE, lbound(dvL_dz3,3)+BAKED_BUFF_SIZE)))
    dp(10) = acc_deviceptr_(c_loc(dvR_dx1(lbound(dvR_dx1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dx1,2)+BAKED_BUFF_SIZE, lbound(dvR_dx1,3)+BAKED_BUFF_SIZE)))
    dp(11) = acc_deviceptr_(c_loc(dvR_dx2(lbound(dvR_dx2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dx2,2)+BAKED_BUFF_SIZE, lbound(dvR_dx2,3)+BAKED_BUFF_SIZE)))
    dp(12) = acc_deviceptr_(c_loc(dvR_dx3(lbound(dvR_dx3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dx3,2)+BAKED_BUFF_SIZE, lbound(dvR_dx3,3)+BAKED_BUFF_SIZE)))
    dp(13) = acc_deviceptr_(c_loc(dvR_dy1(lbound(dvR_dy1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dy1,2)+BAKED_BUFF_SIZE, lbound(dvR_dy1,3)+BAKED_BUFF_SIZE)))
    dp(14) = acc_deviceptr_(c_loc(dvR_dy2(lbound(dvR_dy2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dy2,2)+BAKED_BUFF_SIZE, lbound(dvR_dy2,3)+BAKED_BUFF_SIZE)))
    dp(15) = acc_deviceptr_(c_loc(dvR_dy3(lbound(dvR_dy3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dy3,2)+BAKED_BUFF_SIZE, lbound(dvR_dy3,3)+BAKED_BUFF_SIZE)))
    dp(16) = acc_deviceptr_(c_loc(dvR_dz1(lbound(dvR_dz1,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dz1,2)+BAKED_BUFF_SIZE, lbound(dvR_dz1,3)+BAKED_BUFF_SIZE)))
    dp(17) = acc_deviceptr_(c_loc(dvR_dz2(lbound(dvR_dz2,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dz2,2)+BAKED_BUFF_SIZE, lbound(dvR_dz2,3)+BAKED_BUFF_SIZE)))
    dp(18) = acc_deviceptr_(c_loc(dvR_dz3(lbound(dvR_dz3,1)+BAKED_BUFF_SIZE, &
        & lbound(dvR_dz3,2)+BAKED_BUFF_SIZE, lbound(dvR_dz3,3)+BAKED_BUFF_SIZE)))
    fp(1) = acc_deviceptr_(c_loc(fsrc3(lbound(fsrc3,1)+BAKED_BUFF_SIZE, &
        & lbound(fsrc3,2)+BAKED_BUFF_SIZE, lbound(fsrc3,3)+BAKED_BUFF_SIZE)))
    fp(2) = acc_deviceptr_(c_loc(fsrc4(lbound(fsrc4,1)+BAKED_BUFF_SIZE, &
        & lbound(fsrc4,2)+BAKED_BUFF_SIZE, lbound(fsrc4,3)+BAKED_BUFF_SIZE)))
    fp(3) = acc_deviceptr_(c_loc(fsrc5(lbound(fsrc5,1)+BAKED_BUFF_SIZE, &
        & lbound(fsrc5,2)+BAKED_BUFF_SIZE, lbound(fsrc5,3)+BAKED_BUFF_SIZE)))
    fp(4) = acc_deviceptr_(c_loc(fsrc6(lbound(fsrc6,1)+BAKED_BUFF_SIZE, &
        & lbound(fsrc6,2)+BAKED_BUFF_SIZE, lbound(fsrc6,3)+BAKED_BUFF_SIZE)))
    ra_dev = acc_deviceptr_(c_loc(re_avg(lbound(re_avg,1), &
        & lbound(re_avg,2), lbound(re_avg,3), 1)))
    vs_dev = acc_deviceptr_(c_loc(vel_src(lbound(vel_src,1), &
        & lbound(vel_src,2), lbound(vel_src,3), 1)))
    do i = 1, 18
      if (.not. c_associated(dp(i))) then
        print *, 'm_dace_kernels_vsrc: dvel field not device-present'
        error stop 1
      end if
    end do
    if (.not. c_associated(ra_dev) .or. .not. c_associated(vs_dev)) then
      print *, 'm_dace_kernels_vsrc: viscous arrays not device-present'
      error stop 1
    end if

    b = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]
    if (.not. c_associated(state_vsrc) .or. any(state_b /= b) .or. state_ext /= ext) then
      if (c_associated(state_vsrc)) then
        ierr = vsrc_exit(state_vsrc)
        state_vsrc = c_null_ptr
      end if
      state_vsrc = vsrc_init( &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(jb_in, c_int), int(je_in, c_int), int(kb_in, c_int), &
        & int(ke_in, c_int), int(lb_in, c_int), int(le_in, c_int), &
        & int(size(re_avg,1), c_int64_t), int(size(re_avg,2), c_int64_t), &
        & int(size(re_avg,3), c_int64_t), &
        & int(size(vel_src,1), c_int64_t), int(size(vel_src,2), c_int64_t), &
        & int(size(vel_src,3), c_int64_t))
      state_b = b
      state_ext = ext
    end if

    ! the fdiff producer (the acc/dace) writes the dvels; the sync = before the read
    ierr = cudaDeviceSynchronize_()
    call vsrc_run(state_vsrc, &
          & dp(1), &
          & dp(2), &
          & dp(3), &
          & dp(4), &
          & dp(5), &
          & dp(6), &
          & dp(7), &
          & dp(8), &
          & dp(9), &
          & dp(10), &
          & dp(11), &
          & dp(12), &
          & dp(13), &
          & dp(14), &
          & dp(15), &
          & dp(16), &
          & dp(17), &
          & dp(18), &
          & fp(1), &
          & fp(2), &
          & fp(3), &
          & fp(4), &
          & ra_dev, &
          & vs_dev, &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(ext, c_int64_t), &
          & int(jb_in, c_int), &
          & int(je_in, c_int), &
          & int(kb_in, c_int), &
          & int(ke_in, c_int), &
          & int(lb_in, c_int), &
          & int(le_in, c_int), &
          & int(size(re_avg,1), c_int64_t), &
          & int(size(re_avg,2), c_int64_t), &
          & int(size(re_avg,3), c_int64_t), &
          & int(size(vel_src,1), c_int64_t), &
          & int(size(vel_src,2), c_int64_t), &
          & int(size(vel_src,3), c_int64_t))
    ! the exit sync: the RHS consumers = the acc kernels on the acc stream
    ierr = cudaDeviceSynchronize_()
  end subroutine s_dace_vsrc_x

end module m_dace_kernels_vsrc
#else
module m_dace_kernels_vsrc
  implicit none
  private
  public :: s_dace_vsrc_x, vsrc_dace_contract, vsrc_dace_mode
contains
  subroutine s_dace_vsrc_x(dvL_dx1, dvL_dx2, dvL_dx3, dvL_dy1, dvL_dy2, dvL_dy3, &
                           & dvL_dz1, dvL_dz2, dvL_dz3, dvR_dx1, dvR_dx2, dvR_dx3, &
                           & dvR_dy1, dvR_dy2, dvR_dy3, dvR_dz1, dvR_dz2, dvR_dz3, &
                           & fsrc3, fsrc4, fsrc5, fsrc6, re_avg, vel_src, &
                           & jb_in, je_in, kb_in, ke_in, lb_in, le_in)
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in
  end subroutine s_dace_vsrc_x
  function vsrc_dace_contract() result(c)
    logical :: c
    c = .false.
  end function vsrc_dace_contract
  function vsrc_dace_mode() result(m)
    integer :: m
    m = 0
  end function vsrc_dace_mode
end module m_dace_kernels_vsrc
#endif
