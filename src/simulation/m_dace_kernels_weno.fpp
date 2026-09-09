#if defined(MFC_DACE)
!! @brief Contains module m_dace_kernels_weno
!!
!! P2/L1 — the DaCe WENO5 reconstruction dispatch (x direction). The
!! libmfc_dace_weno_x.so kernel reads v_rs_weno and the cbL/cbR coefficient
!! tables IN PLACE (their MFC F-order flat addressing == the kernel's
!! assumed-shape strides) and writes vL/vR_rs_vf_x IN PLACE at the
!! (j+buff, k+buff, l+buff) subscripts, so the shim passes raw device
!! pointers with ZERO staging: no pack, no unpack, no transposes.
!!
!! The kernel is case-baked: weno_order=5, wenojs, uniform-grid beta,
!! buff_size = MFC_DACE_BAKED_BUFF, poly order (weno_polyn=2), the eqn
!! dimension 1..8 (sys_size).  weno_dace_contract() guards every one of
!! those; anything else falls back to the native OpenACC kernel.
module m_dace_kernels_weno
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, &
                                         c_associated, c_loc, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_weno_x, s_dace_weno_y, s_dace_weno_z, &
            weno_dace_contract, weno_dace_mode, weno_dace_dirs

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
    function mfc_dace_weno_x_init(d_cbl_x_d0, d_cbr_x_d0, jb, je, kb, ke, lb, le, &
                                  poly_coef_cbl_x_d0, poly_coef_cbl_x_d1, &
                                  poly_coef_cbr_x_d0, poly_coef_cbr_x_d1, &
                                  v_rs_d0, v_rs_d1, v_rs_d2, &
                                  vl_d0, vl_d1, vl_d2, &
                                  vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__dace_init_mfc_dace_weno_x')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: mfc_dace_weno_x_init
      integer(c_int64_t), value :: d_cbl_x_d0, d_cbr_x_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_x_d0, poly_coef_cbl_x_d1
      integer(c_int64_t), value :: poly_coef_cbr_x_d0, poly_coef_cbr_x_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end function
    function mfc_dace_weno_x_exit(state) bind(C, name='__dace_exit_mfc_dace_weno_x')
      import :: c_ptr, c_int
      integer(c_int) :: mfc_dace_weno_x_exit
      type(c_ptr), value :: state
    end function
    subroutine mfc_dace_weno_x_run(state, d_cbl_x, d_cbr_x, poly_coef_cbl_x, &
                                   poly_coef_cbr_x, v_rs, vl, vr, &
                                   d_cbl_x_d0, d_cbr_x_d0, jb, je, kb, ke, lb, le, &
                                   poly_coef_cbl_x_d0, poly_coef_cbl_x_d1, &
                                   poly_coef_cbr_x_d0, poly_coef_cbr_x_d1, &
                                   v_rs_d0, v_rs_d1, v_rs_d2, &
                                   vl_d0, vl_d1, vl_d2, &
                                   vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__program_mfc_dace_weno_x')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: d_cbl_x, d_cbr_x, poly_coef_cbl_x, poly_coef_cbr_x
      type(c_ptr), value :: v_rs, vl, vr
      integer(c_int64_t), value :: d_cbl_x_d0, d_cbr_x_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_x_d0, poly_coef_cbl_x_d1
      integer(c_int64_t), value :: poly_coef_cbr_x_d0, poly_coef_cbr_x_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end subroutine
  end interface

  interface
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function
    function mfc_dace_weno_y_init(d_cbl_y_d0, d_cbr_y_d0, jb, je, kb, ke, lb, le, &
                                  poly_coef_cbl_y_d0, poly_coef_cbl_y_d1, &
                                  poly_coef_cbr_y_d0, poly_coef_cbr_y_d1, &
                                  v_rs_d0, v_rs_d1, v_rs_d2, &
                                  vl_d0, vl_d1, vl_d2, &
                                  vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__dace_init_mfc_dace_weno_y')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: mfc_dace_weno_y_init
      integer(c_int64_t), value :: d_cbl_y_d0, d_cbr_y_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_y_d0, poly_coef_cbl_y_d1
      integer(c_int64_t), value :: poly_coef_cbr_y_d0, poly_coef_cbr_y_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end function
    function mfc_dace_weno_y_exit(state) bind(C, name='__dace_exit_mfc_dace_weno_y')
      import :: c_ptr, c_int
      integer(c_int) :: mfc_dace_weno_y_exit
      type(c_ptr), value :: state
    end function
    subroutine mfc_dace_weno_y_run(state, d_cbl_y, d_cbr_y, poly_coef_cbl_y, &
                                   poly_coef_cbr_y, v_rs, vl, vr, &
                                   d_cbl_y_d0, d_cbr_y_d0, jb, je, kb, ke, lb, le, &
                                   poly_coef_cbl_y_d0, poly_coef_cbl_y_d1, &
                                   poly_coef_cbr_y_d0, poly_coef_cbr_y_d1, &
                                   v_rs_d0, v_rs_d1, v_rs_d2, &
                                   vl_d0, vl_d1, vl_d2, &
                                   vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__program_mfc_dace_weno_y')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: d_cbl_y, d_cbr_y, poly_coef_cbl_y, poly_coef_cbr_y
      type(c_ptr), value :: v_rs, vl, vr
      integer(c_int64_t), value :: d_cbl_y_d0, d_cbr_y_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_y_d0, poly_coef_cbl_y_d1
      integer(c_int64_t), value :: poly_coef_cbr_y_d0, poly_coef_cbr_y_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end subroutine
  end interface

  interface
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function
    function mfc_dace_weno_z_init(d_cbl_z_d0, d_cbr_z_d0, jb, je, kb, ke, lb, le, &
                                  poly_coef_cbl_z_d0, poly_coef_cbl_z_d1, &
                                  poly_coef_cbr_z_d0, poly_coef_cbr_z_d1, &
                                  v_rs_d0, v_rs_d1, v_rs_d2, &
                                  vl_d0, vl_d1, vl_d2, &
                                  vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__dace_init_mfc_dace_weno_z')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr) :: mfc_dace_weno_z_init
      integer(c_int64_t), value :: d_cbl_z_d0, d_cbr_z_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_z_d0, poly_coef_cbl_z_d1
      integer(c_int64_t), value :: poly_coef_cbr_z_d0, poly_coef_cbr_z_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end function
    function mfc_dace_weno_z_exit(state) bind(C, name='__dace_exit_mfc_dace_weno_z')
      import :: c_ptr, c_int
      integer(c_int) :: mfc_dace_weno_z_exit
      type(c_ptr), value :: state
    end function
    subroutine mfc_dace_weno_z_run(state, d_cbl_z, d_cbr_z, poly_coef_cbl_z, &
                                   poly_coef_cbr_z, v_rs, vl, vr, &
                                   d_cbl_z_d0, d_cbr_z_d0, jb, je, kb, ke, lb, le, &
                                   poly_coef_cbl_z_d0, poly_coef_cbl_z_d1, &
                                   poly_coef_cbr_z_d0, poly_coef_cbr_z_d1, &
                                   v_rs_d0, v_rs_d1, v_rs_d2, &
                                   vl_d0, vl_d1, vl_d2, &
                                   vr_d0, vr_d1, vr_d2) &
        & bind(C, name='__program_mfc_dace_weno_z')
      import :: c_ptr, c_int, c_int64_t
      type(c_ptr), value :: state
      type(c_ptr), value :: d_cbl_z, d_cbr_z, poly_coef_cbl_z, poly_coef_cbr_z
      type(c_ptr), value :: v_rs, vl, vr
      integer(c_int64_t), value :: d_cbl_z_d0, d_cbr_z_d0
      integer(c_int), value :: jb, je, kb, ke, lb, le
      integer(c_int64_t), value :: poly_coef_cbl_z_d0, poly_coef_cbl_z_d1
      integer(c_int64_t), value :: poly_coef_cbr_z_d0, poly_coef_cbr_z_d1
      integer(c_int64_t), value :: v_rs_d0, v_rs_d1, v_rs_d2
      integer(c_int64_t), value :: vl_d0, vl_d1, vl_d2
      integer(c_int64_t), value :: vr_d0, vr_d1, vr_d2
    end subroutine
  end interface


#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 6
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF

  type(c_ptr), save :: state_weno_x = c_null_ptr, state_weno_y = c_null_ptr, &
                       & state_weno_z = c_null_ptr
  integer, save :: state_b_x(6) = -1, state_b_y(6) = -1, state_b_z(6) = -1
  integer, save :: state_ext_x = -1, state_ext_y = -1, state_ext_z = -1

contains

  subroutine s_dace_weno_x(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in), target :: v_rs
    real(wp), dimension(:, :, :), intent(in), target :: pcL, pcR
    real(wp), dimension(:, :), intent(in), target :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout), target :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in

    integer :: ext, d0pc, d1pc, d0d
    type(c_ptr) :: vrs_dev, vl_dev, vr_dev, pcl_dev, pcr_dev, dl_dev, dr_dev
    integer(c_int) :: ierr

    ext = size(v_rs, 1)
    d0pc = size(pcL, 1)
    d1pc = size(pcL, 2)
    d0d = size(dL, 1)

    if (size(v_rs, 2) /= ext .or. size(v_rs, 3) /= ext .or. &
        & size(vL, 1) /= ext .or. size(vL, 2) /= ext .or. &
        & size(vL, 3) /= ext) then
      print *, 'm_dace_kernels_weno: non-cubic weno extents', ext
      error stop 1
    end if

    vrs_dev = acc_deviceptr_(c_loc(v_rs(lbound(v_rs, 1), lbound(v_rs, 2), &
                                         & lbound(v_rs, 3), 1)))
    vl_dev = acc_deviceptr_(c_loc(vL(lbound(vL, 1), lbound(vL, 2), &
                                     & lbound(vL, 3), 1)))
    vr_dev = acc_deviceptr_(c_loc(vR(lbound(vR, 1), lbound(vR, 2), &
                                     & lbound(vR, 3), 1)))
    pcl_dev = acc_deviceptr_(c_loc(pcL(lbound(pcL, 1), lbound(pcL, 2), &
                                       & lbound(pcL, 3))))
    pcr_dev = acc_deviceptr_(c_loc(pcR(lbound(pcR, 1), lbound(pcR, 2), &
                                       & lbound(pcR, 3))))
    dl_dev = acc_deviceptr_(c_loc(dL(lbound(dL, 1), lbound(dL, 2))))
    dr_dev = acc_deviceptr_(c_loc(dR(lbound(dR, 1), lbound(dR, 2))))
    if (.not. c_associated(vrs_dev) .or. .not. c_associated(vl_dev) .or. &
        & .not. c_associated(vr_dev) .or. .not. c_associated(pcl_dev) .or. &
        & .not. c_associated(pcr_dev) .or. .not. c_associated(dl_dev) .or. &
        & .not. c_associated(dr_dev)) then
      print *, 'm_dace_kernels_weno: weno field not device-present'
      error stop 1
    end if

    if (.not. c_associated(state_weno_x) .or. any(state_b_x /= [jb_in, je_in, &
        & kb_in, ke_in, lb_in, le_in]) .or. state_ext_x /= ext) then
      if (c_associated(state_weno_x)) then
        ierr = mfc_dace_weno_x_exit(state_weno_x)
        state_weno_x = c_null_ptr
      end if
      state_weno_x = mfc_dace_weno_x_init( &
        & int(d0d, c_int64_t), int(d0d, c_int64_t), &
        & int(jb_in, c_int), int(je_in, c_int), int(kb_in, c_int), &
        & int(ke_in, c_int), int(lb_in, c_int), int(le_in, c_int), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t))
      state_b_x = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]
      state_ext_x = ext
    end if

    ! DACE<->ACC BOUNDARY SYNC: the pack (s_pack_weno_input_arr) writes
    ! v_rs_weno on the acc stream; the DaCe kernel reads it on its own
    ! stream.  Same entry-sync pattern as the sweeps dispatch.
    ierr = cudaDeviceSynchronize_()
    call mfc_dace_weno_x_run(state_weno_x, dl_dev, dr_dev, pcl_dev, pcr_dev, &
                             & vrs_dev, vl_dev, vr_dev, &
                             & int(d0d, c_int64_t), int(d0d, c_int64_t), &
                             & int(jb_in, c_int), int(je_in, c_int), &
                             & int(kb_in, c_int), int(ke_in, c_int), &
                             & int(lb_in, c_int), int(le_in, c_int), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t))
    ! Exit sync: the flux consumers may be native OpenACC kernels on the
    ! acc stream (e.g. when the HLLC dispatch contract is off) — the
    ! reconstruction output must be visible to them.
    ierr = cudaDeviceSynchronize_()
  end subroutine s_dace_weno_x

  subroutine s_dace_weno_y(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in), target :: v_rs
    real(wp), dimension(:, :, :), intent(in), target :: pcL, pcR
    real(wp), dimension(:, :), intent(in), target :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout), target :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in

    integer :: ext, d0pc, d1pc, d0d
    type(c_ptr) :: vrs_dev, vl_dev, vr_dev, pcl_dev, pcr_dev, dl_dev, dr_dev
    integer(c_int) :: ierr

    ext = size(v_rs, 1)
    d0pc = size(pcL, 1)
    d1pc = size(pcL, 2)
    d0d = size(dL, 1)

    if (size(v_rs, 2) /= ext .or. size(v_rs, 3) /= ext .or. &
        & size(vL, 1) /= ext .or. size(vL, 2) /= ext .or. &
        & size(vL, 3) /= ext) then
      print *, 'm_dace_kernels_weno: non-cubic weno extents', ext
      error stop 1
    end if

    vrs_dev = acc_deviceptr_(c_loc(v_rs(lbound(v_rs, 1), lbound(v_rs, 2), &
                                         & lbound(v_rs, 3), 1)))
    vl_dev = acc_deviceptr_(c_loc(vL(lbound(vL, 1), lbound(vL, 2), &
                                     & lbound(vL, 3), 1)))
    vr_dev = acc_deviceptr_(c_loc(vR(lbound(vR, 1), lbound(vR, 2), &
                                     & lbound(vR, 3), 1)))
    pcl_dev = acc_deviceptr_(c_loc(pcL(lbound(pcL, 1), lbound(pcL, 2), &
                                       & lbound(pcL, 3))))
    pcr_dev = acc_deviceptr_(c_loc(pcR(lbound(pcR, 1), lbound(pcR, 2), &
                                       & lbound(pcR, 3))))
    dl_dev = acc_deviceptr_(c_loc(dL(lbound(dL, 1), lbound(dL, 2))))
    dr_dev = acc_deviceptr_(c_loc(dR(lbound(dR, 1), lbound(dR, 2))))
    if (.not. c_associated(vrs_dev) .or. .not. c_associated(vl_dev) .or. &
        & .not. c_associated(vr_dev) .or. .not. c_associated(pcl_dev) .or. &
        & .not. c_associated(pcr_dev) .or. .not. c_associated(dl_dev) .or. &
        & .not. c_associated(dr_dev)) then
      print *, 'm_dace_kernels_weno: weno field not device-present'
      error stop 1
    end if

    if (.not. c_associated(state_weno_y) .or. any(state_b_y /= [jb_in, je_in, &
        & kb_in, ke_in, lb_in, le_in]) .or. state_ext_y /= ext) then
      if (c_associated(state_weno_y)) then
        ierr = mfc_dace_weno_y_exit(state_weno_y)
        state_weno_y = c_null_ptr
      end if
      state_weno_y = mfc_dace_weno_y_init( &
        & int(d0d, c_int64_t), int(d0d, c_int64_t), &
        & int(jb_in, c_int), int(je_in, c_int), int(kb_in, c_int), &
        & int(ke_in, c_int), int(lb_in, c_int), int(le_in, c_int), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t))
      state_b_y = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]
      state_ext_y = ext
    end if

    ! DACE<->ACC BOUNDARY SYNC: the pack (s_pack_weno_input_arr) writes
    ! v_rs_weno on the acc stream; the DaCe kernel reads it on its own
    ! stream.  Same entry-sync pattern as the sweeps dispatch.
    ierr = cudaDeviceSynchronize_()
    call mfc_dace_weno_y_run(state_weno_y, dl_dev, dr_dev, pcl_dev, pcr_dev, &
                             & vrs_dev, vl_dev, vr_dev, &
                             & int(d0d, c_int64_t), int(d0d, c_int64_t), &
                             & int(jb_in, c_int), int(je_in, c_int), &
                             & int(kb_in, c_int), int(ke_in, c_int), &
                             & int(lb_in, c_int), int(le_in, c_int), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t))
    ! Exit sync: the flux consumers may be native OpenACC kernels on the
    ! acc stream (e.g. when the HLLC dispatch contract is off) — the
    ! reconstruction output must be visible to them.
    ierr = cudaDeviceSynchronize_()
  end subroutine s_dace_weno_y

  subroutine s_dace_weno_z(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in), target :: v_rs
    real(wp), dimension(:, :, :), intent(in), target :: pcL, pcR
    real(wp), dimension(:, :), intent(in), target :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout), target :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in

    integer :: ext, d0pc, d1pc, d0d
    type(c_ptr) :: vrs_dev, vl_dev, vr_dev, pcl_dev, pcr_dev, dl_dev, dr_dev
    integer(c_int) :: ierr

    ext = size(v_rs, 1)
    d0pc = size(pcL, 1)
    d1pc = size(pcL, 2)
    d0d = size(dL, 1)

    if (size(v_rs, 2) /= ext .or. size(v_rs, 3) /= ext .or. &
        & size(vL, 1) /= ext .or. size(vL, 2) /= ext .or. &
        & size(vL, 3) /= ext) then
      print *, 'm_dace_kernels_weno: non-cubic weno extents', ext
      error stop 1
    end if

    vrs_dev = acc_deviceptr_(c_loc(v_rs(lbound(v_rs, 1), lbound(v_rs, 2), &
                                         & lbound(v_rs, 3), 1)))
    vl_dev = acc_deviceptr_(c_loc(vL(lbound(vL, 1), lbound(vL, 2), &
                                     & lbound(vL, 3), 1)))
    vr_dev = acc_deviceptr_(c_loc(vR(lbound(vR, 1), lbound(vR, 2), &
                                     & lbound(vR, 3), 1)))
    pcl_dev = acc_deviceptr_(c_loc(pcL(lbound(pcL, 1), lbound(pcL, 2), &
                                       & lbound(pcL, 3))))
    pcr_dev = acc_deviceptr_(c_loc(pcR(lbound(pcR, 1), lbound(pcR, 2), &
                                       & lbound(pcR, 3))))
    dl_dev = acc_deviceptr_(c_loc(dL(lbound(dL, 1), lbound(dL, 2))))
    dr_dev = acc_deviceptr_(c_loc(dR(lbound(dR, 1), lbound(dR, 2))))
    if (.not. c_associated(vrs_dev) .or. .not. c_associated(vl_dev) .or. &
        & .not. c_associated(vr_dev) .or. .not. c_associated(pcl_dev) .or. &
        & .not. c_associated(pcr_dev) .or. .not. c_associated(dl_dev) .or. &
        & .not. c_associated(dr_dev)) then
      print *, 'm_dace_kernels_weno: weno field not device-present'
      error stop 1
    end if

    if (.not. c_associated(state_weno_z) .or. any(state_b_z /= [jb_in, je_in, &
        & kb_in, ke_in, lb_in, le_in]) .or. state_ext_z /= ext) then
      if (c_associated(state_weno_z)) then
        ierr = mfc_dace_weno_z_exit(state_weno_z)
        state_weno_z = c_null_ptr
      end if
      state_weno_z = mfc_dace_weno_z_init( &
        & int(d0d, c_int64_t), int(d0d, c_int64_t), &
        & int(jb_in, c_int), int(je_in, c_int), int(kb_in, c_int), &
        & int(ke_in, c_int), int(lb_in, c_int), int(le_in, c_int), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t), &
        & int(ext, c_int64_t), int(ext, c_int64_t), int(ext, c_int64_t))
      state_b_z = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]
      state_ext_z = ext
    end if

    ! DACE<->ACC BOUNDARY SYNC: the pack (s_pack_weno_input_arr) writes
    ! v_rs_weno on the acc stream; the DaCe kernel reads it on its own
    ! stream.  Same entry-sync pattern as the sweeps dispatch.
    ierr = cudaDeviceSynchronize_()
    call mfc_dace_weno_z_run(state_weno_z, dl_dev, dr_dev, pcl_dev, pcr_dev, &
                             & vrs_dev, vl_dev, vr_dev, &
                             & int(d0d, c_int64_t), int(d0d, c_int64_t), &
                             & int(jb_in, c_int), int(je_in, c_int), &
                             & int(kb_in, c_int), int(ke_in, c_int), &
                             & int(lb_in, c_int), int(le_in, c_int), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(d0pc, c_int64_t), int(d1pc, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t), &
                             & int(ext, c_int64_t), int(ext, c_int64_t), &
                             & int(ext, c_int64_t))
    ! Exit sync: the flux consumers may be native OpenACC kernels on the
    ! acc stream (e.g. when the HLLC dispatch contract is off) — the
    ! reconstruction output must be visible to them.
    ierr = cudaDeviceSynchronize_()
  end subroutine s_dace_weno_z

  !> Per-direction kill switch: MFC_DACE_WENO_DIRS holds a mask string like
  !! "100" (x on, y/z off — the y/z libs are not captured yet); unset = "100".
  function weno_dace_dirs(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    logical, save :: cached_val(3) = [.true., .false., .false.]

    if (.not. cached) then
      call get_environment_variable('MFC_DACE_WENO_DIRS', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) then
        cached_val(1) = env(1:1) == '1'
        cached_val(2) = len_trim(env) < 2 .or. env(2:2) == '1'
        cached_val(3) = len_trim(env) < 3 .or. env(3:3) == '1'
      end if
      cached = .true.
    end if
    c = cached_val(nd)
  end function weno_dace_dirs

  !> Runtime mode: unset/"0" -> 1 (DaCe kernel only), "1" -> 0 (OpenACC
  !! only), "2" -> capture (run the DaCe kernel, then the OpenACC kernel,
  !! then compare — the fallback runs unconditionally in mode 2).
  function weno_dace_mode() result(m)
    integer :: m
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    integer, save :: cached_val = 1

    if (.not. cached) then
      cached_val = 1
      call get_environment_variable('MFC_DACE_WENO_RT_OFF', env, status=st)
      if (st == 0) then
        if (trim(env) == '1') then
          cached_val = 0
        else if (trim(env) == '2') then
          cached_val = 2
        end if
      end if
      cached = .true.
    end if
    m = cached_val
  end function weno_dace_mode

  !> The dispatch's bake contract: every case flag the captured kernel
  !! folded at build time. The eqn-count guard (v_size == 8) lives at the
  !! call site in m_weno (v_size is that module's private state).
  !! Any violation falls back to the OpenACC kernel.
  function weno_dace_contract() result(c)
    logical :: c
    c = (weno_order == 5 .and. wenojs .and. &
         & .not. mapped_weno .and. .not. wenoz .and. .not. teno .and. &
         & .not. mp_weno .and. .not. weno_avg .and. &
         & num_fluids == 2 .and. model_eqns == 2 .and. &
         & buff_size == BAKED_BUFF_SIZE .and. &
         & .not. cyl_coord .and. .not. chemistry .and. .not. qbmm)
  end function weno_dace_contract

end module m_dace_kernels_weno
#else
module m_dace_kernels_weno
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_weno_x, s_dace_weno_y, s_dace_weno_z, &
            weno_dace_contract, weno_dace_mode, weno_dace_dirs
contains
  subroutine s_dace_weno_x(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in) :: v_rs
    real(wp), dimension(:, :, :), intent(in) :: pcL, pcR
    real(wp), dimension(:, :), intent(in) :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout) :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in
    ! No-op stub: MFC_DACE builds only.
  end subroutine s_dace_weno_x
  subroutine s_dace_weno_y(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in) :: v_rs
    real(wp), dimension(:, :, :), intent(in) :: pcL, pcR
    real(wp), dimension(:, :), intent(in) :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout) :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in
    ! No-op stub: MFC_DACE builds only.
  end subroutine s_dace_weno_y
  subroutine s_dace_weno_z(v_rs, pcL, pcR, dL, dR, vL, vR, jb_in, je_in, &
                           & kb_in, ke_in, lb_in, le_in)
    real(wp), dimension(:, :, :, :), intent(in) :: v_rs
    real(wp), dimension(:, :, :), intent(in) :: pcL, pcR
    real(wp), dimension(:, :), intent(in) :: dL, dR
    real(wp), dimension(:, :, :, :), intent(inout) :: vL, vR
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in
    ! No-op stub: MFC_DACE builds only.
  end subroutine s_dace_weno_z
  function weno_dace_contract() result(c)
    logical :: c
    c = .false.
  end function weno_dace_contract
  function weno_dace_mode() result(m)
    integer :: m
    m = 0
  end function weno_dace_mode
  function weno_dace_dirs(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    c = .false.
  end function weno_dace_dirs
end module m_dace_kernels_weno
#endif
