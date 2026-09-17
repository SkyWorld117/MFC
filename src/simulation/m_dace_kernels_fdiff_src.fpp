#if defined(MFC_DACE)
module m_dace_kernels_fdiff_src
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, c_double, &
                                         c_associated, c_loc, c_null_ptr
  use m_derived_types
  use m_global_parameters
  use m_constants, only: adv_src_mode_vel_iface, model_eqns_5eq, hypo_nc_mode_dual_pass
  implicit none
  private
  public :: s_dace_fdiff_src, fdiff_src_dirs, fdiff_src_contract

  interface
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function
  end interface

  interface
    subroutine fdiff_src_run_x(state, &
          & dx, &
          & f1, &
          & f2, &
          & f3, &
          & f4, &
          & f5, &
          & f6, &
          & f7, &
          & f8, &
          & fsrc, &
          & qa1, &
          & qa2, &
          & rh1, &
          & rh2, &
          & rh3, &
          & rh4, &
          & rh5, &
          & rh6, &
          & rh7, &
          & rh8, &
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__program_mfc_dace_fdiff_src_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dx
      type(c_ptr), value :: f1
      type(c_ptr), value :: f2
      type(c_ptr), value :: f3
      type(c_ptr), value :: f4
      type(c_ptr), value :: f5
      type(c_ptr), value :: f6
      type(c_ptr), value :: f7
      type(c_ptr), value :: f8
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: qa1
      type(c_ptr), value :: qa2
      type(c_ptr), value :: rh1
      type(c_ptr), value :: rh2
      type(c_ptr), value :: rh3
      type(c_ptr), value :: rh4
      type(c_ptr), value :: rh5
      type(c_ptr), value :: rh6
      type(c_ptr), value :: rh7
      type(c_ptr), value :: rh8
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end subroutine

    function fdiff_src_init_x(&
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__dace_init_mfc_dace_fdiff_src_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: fdiff_src_init_x
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end function

    function fdiff_src_exit_x(state) bind(C, name='__dace_exit_mfc_dace_fdiff_src_x')
      import :: c_ptr, c_int
      integer(c_int) :: fdiff_src_exit_x
      type(c_ptr), value :: state
    end function
  end interface

  interface
    subroutine fdiff_src_run_y(state, &
          & dy, &
          & f1, &
          & f2, &
          & f3, &
          & f4, &
          & f5, &
          & f6, &
          & f7, &
          & f8, &
          & fsrc, &
          & qa1, &
          & qa2, &
          & rh1, &
          & rh2, &
          & rh3, &
          & rh4, &
          & rh5, &
          & rh6, &
          & rh7, &
          & rh8, &
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__program_mfc_dace_fdiff_src_y')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dy
      type(c_ptr), value :: f1
      type(c_ptr), value :: f2
      type(c_ptr), value :: f3
      type(c_ptr), value :: f4
      type(c_ptr), value :: f5
      type(c_ptr), value :: f6
      type(c_ptr), value :: f7
      type(c_ptr), value :: f8
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: qa1
      type(c_ptr), value :: qa2
      type(c_ptr), value :: rh1
      type(c_ptr), value :: rh2
      type(c_ptr), value :: rh3
      type(c_ptr), value :: rh4
      type(c_ptr), value :: rh5
      type(c_ptr), value :: rh6
      type(c_ptr), value :: rh7
      type(c_ptr), value :: rh8
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end subroutine

    function fdiff_src_init_y(&
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__dace_init_mfc_dace_fdiff_src_y')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: fdiff_src_init_y
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end function

    function fdiff_src_exit_y(state) bind(C, name='__dace_exit_mfc_dace_fdiff_src_y')
      import :: c_ptr, c_int
      integer(c_int) :: fdiff_src_exit_y
      type(c_ptr), value :: state
    end function
  end interface

  interface
    subroutine fdiff_src_run_z(state, &
          & dz, &
          & f1, &
          & f2, &
          & f3, &
          & f4, &
          & f5, &
          & f6, &
          & f7, &
          & f8, &
          & fsrc, &
          & qa1, &
          & qa2, &
          & rh1, &
          & rh2, &
          & rh3, &
          & rh4, &
          & rh5, &
          & rh6, &
          & rh7, &
          & rh8, &
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__program_mfc_dace_fdiff_src_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dz
      type(c_ptr), value :: f1
      type(c_ptr), value :: f2
      type(c_ptr), value :: f3
      type(c_ptr), value :: f4
      type(c_ptr), value :: f5
      type(c_ptr), value :: f6
      type(c_ptr), value :: f7
      type(c_ptr), value :: f8
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: qa1
      type(c_ptr), value :: qa2
      type(c_ptr), value :: rh1
      type(c_ptr), value :: rh2
      type(c_ptr), value :: rh3
      type(c_ptr), value :: rh4
      type(c_ptr), value :: rh5
      type(c_ptr), value :: rh6
      type(c_ptr), value :: rh7
      type(c_ptr), value :: rh8
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end subroutine

    function fdiff_src_init_z(&
          & f1_d0, &
          & f1_d1, &
          & f2_d0, &
          & f2_d1, &
          & f3_d0, &
          & f3_d1, &
          & f4_d0, &
          & f4_d1, &
          & f5_d0, &
          & f5_d1, &
          & f6_d0, &
          & f6_d1, &
          & f7_d0, &
          & f7_d1, &
          & f8_d0, &
          & f8_d1, &
          & fsrc_d0, &
          & fsrc_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & qa1_d0, &
          & qa1_d1, &
          & qa2_d0, &
          & qa2_d1, &
          & rh1_d0, &
          & rh1_d1, &
          & rh2_d0, &
          & rh2_d1, &
          & rh3_d0, &
          & rh3_d1, &
          & rh4_d0, &
          & rh4_d1, &
          & rh5_d0, &
          & rh5_d1, &
          & rh6_d0, &
          & rh6_d1, &
          & rh7_d0, &
          & rh7_d1, &
          & rh8_d0, &
          & rh8_d1) &
        bind(C, name='__dace_init_mfc_dace_fdiff_src_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: fdiff_src_init_z
      integer(c_int64_t), value :: f1_d0
      integer(c_int64_t), value :: f1_d1
      integer(c_int64_t), value :: f2_d0
      integer(c_int64_t), value :: f2_d1
      integer(c_int64_t), value :: f3_d0
      integer(c_int64_t), value :: f3_d1
      integer(c_int64_t), value :: f4_d0
      integer(c_int64_t), value :: f4_d1
      integer(c_int64_t), value :: f5_d0
      integer(c_int64_t), value :: f5_d1
      integer(c_int64_t), value :: f6_d0
      integer(c_int64_t), value :: f6_d1
      integer(c_int64_t), value :: f7_d0
      integer(c_int64_t), value :: f7_d1
      integer(c_int64_t), value :: f8_d0
      integer(c_int64_t), value :: f8_d1
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: qa1_d0
      integer(c_int64_t), value :: qa1_d1
      integer(c_int64_t), value :: qa2_d0
      integer(c_int64_t), value :: qa2_d1
      integer(c_int64_t), value :: rh1_d0
      integer(c_int64_t), value :: rh1_d1
      integer(c_int64_t), value :: rh2_d0
      integer(c_int64_t), value :: rh2_d1
      integer(c_int64_t), value :: rh3_d0
      integer(c_int64_t), value :: rh3_d1
      integer(c_int64_t), value :: rh4_d0
      integer(c_int64_t), value :: rh4_d1
      integer(c_int64_t), value :: rh5_d0
      integer(c_int64_t), value :: rh5_d1
      integer(c_int64_t), value :: rh6_d0
      integer(c_int64_t), value :: rh6_d1
      integer(c_int64_t), value :: rh7_d0
      integer(c_int64_t), value :: rh7_d1
      integer(c_int64_t), value :: rh8_d0
      integer(c_int64_t), value :: rh8_d1
    end function

    function fdiff_src_exit_z(state) bind(C, name='__dace_exit_mfc_dace_fdiff_src_z')
      import :: c_ptr, c_int
      integer(c_int) :: fdiff_src_exit_z
      type(c_ptr), value :: state
    end function
  end interface

  type(c_ptr), save :: x_state = c_null_ptr, y_state = c_null_ptr, z_state = c_null_ptr

contains

  !> M3's switch + case contract: MFC_DACE_FDIFF_SRC turns the fused flux-difference /
  !! alpha-advection kernel on (unset or 0 = the stock pair, unchanged) and
  !! MFC_DACE_FDIFF_SRC_DIRS is a "101"-style per-direction mask.  The contract lists every
  !! case flag the stock arithmetic the TU transcribes depends on; outside it the stock loops
  !! run exactly as before.
  function fdiff_src_dirs(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false.
    logical, save :: cached_val(3) = [.false., .false., .false.]

    if (.not. cached) then
      call get_environment_variable('MFC_DACE_FDIFF_SRC', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) cached_val = env(1:1) /= '0'
      call get_environment_variable('MFC_DACE_FDIFF_SRC_DIRS', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) then
        cached_val(1) = cached_val(1) .and. env(1:1) == '1'
        cached_val(2) = cached_val(2) .and. (len_trim(env) < 2 .or. env(2:2) == '1')
        cached_val(3) = cached_val(3) .and. (len_trim(env) < 3 .or. env(3:3) == '1')
      end if
      cached = .true.
    end if
    c = cached_val(nd)
  end function fdiff_src_dirs

  !> The bake's case contract, checked at the dispatch site.
  function fdiff_src_contract() result(c)
    logical :: c
    c = (model_eqns == model_eqns_5eq .and. num_fluids == 2 .and. num_dims == 3 .and. &
         & adv_src_mode == adv_src_mode_vel_iface .and. &
         & .not. alt_soundspeed .and. .not. cyl_coord .and. .not. igr .and. &
         & hypo_nc_mode /= hypo_nc_mode_dual_pass .and. &
         & .not. surface_tension .and. .not. chemistry .and. .not. bubbles_euler .and. &
         & .not. qbmm .and. .not. relativity .and. .not. hypoelasticity .and. &
         & .not. mpp_lim .and. .not. cont_damage)
  end function fdiff_src_contract


  !> M3: the fused directional flux difference + volume-fraction advection source.  `f1..f8` are
  !! the direction's face-flux rows, `fsrc` the advection flux_src row, `qa1/qa2` the conserved
  !! alphas, `rh1..rh8` the rhs rows and `dsp` the direction's cell spacing.  Every field crosses
  !! as the raw device pointer of the element at the raw (jb, kb, lb) -- the validated vsrc
  !! convention -- so the kernel's index 0 is that cell and the buff never appears here.
  subroutine s_dace_fdiff_src(f1, f2, f3, f4, f5, f6, f7, f8, fsrc, qa1, qa2, rh1, rh2, rh3, rh4, rh5, rh6, rh7, rh8, dsp, &
                              & jb_in, je_in, kb_in, ke_in, lb_in, le_in, dir_in)
    real(wp), dimension(:, :, :), intent(in), target :: f1
    real(wp), dimension(:, :, :), intent(in), target :: f2
    real(wp), dimension(:, :, :), intent(in), target :: f3
    real(wp), dimension(:, :, :), intent(in), target :: f4
    real(wp), dimension(:, :, :), intent(in), target :: f5
    real(wp), dimension(:, :, :), intent(in), target :: f6
    real(wp), dimension(:, :, :), intent(in), target :: f7
    real(wp), dimension(:, :, :), intent(in), target :: f8
    real(wp), dimension(:, :, :), intent(in), target :: fsrc
    real(wp), dimension(:, :, :), intent(in), target :: qa1
    real(wp), dimension(:, :, :), intent(in), target :: qa2
    real(wp), dimension(:, :, :), intent(inout), target :: rh1
    real(wp), dimension(:, :, :), intent(inout), target :: rh2
    real(wp), dimension(:, :, :), intent(inout), target :: rh3
    real(wp), dimension(:, :, :), intent(inout), target :: rh4
    real(wp), dimension(:, :, :), intent(inout), target :: rh5
    real(wp), dimension(:, :, :), intent(inout), target :: rh6
    real(wp), dimension(:, :, :), intent(inout), target :: rh7
    real(wp), dimension(:, :, :), intent(inout), target :: rh8
    real(wp), dimension(:), intent(in), target :: dsp
    integer, intent(in) :: jb_in, je_in, kb_in, ke_in, lb_in, le_in, dir_in

    integer :: lbnd(3), b(6)
    logical, save :: announced = .false.
    integer(c_int64_t) :: ext64
    integer(c_int) :: ierr
    type(c_ptr) :: f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, rh7_dev, rh8_dev, dsp_dev

    lbnd = [lbound(f1, 1), lbound(f1, 2), lbound(f1, 3)]
    ext64 = int(size(f1, 1), c_int64_t)
    b = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]

    f1_dev = acc_deviceptr_(c_loc(f1(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f2_dev = acc_deviceptr_(c_loc(f2(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f3_dev = acc_deviceptr_(c_loc(f3(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f4_dev = acc_deviceptr_(c_loc(f4(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f5_dev = acc_deviceptr_(c_loc(f5(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f6_dev = acc_deviceptr_(c_loc(f6(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f7_dev = acc_deviceptr_(c_loc(f7(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    f8_dev = acc_deviceptr_(c_loc(f8(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    fsrc_dev = acc_deviceptr_(c_loc(fsrc(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    qa1_dev = acc_deviceptr_(c_loc(qa1(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    qa2_dev = acc_deviceptr_(c_loc(qa2(jb_in - lbnd(1) + 1, &
                                    & kb_in - lbnd(2) + 1, &
                                    & lb_in - lbnd(3) + 1)))
    rh1_dev = acc_deviceptr_(c_loc(rh1(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh2_dev = acc_deviceptr_(c_loc(rh2(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh3_dev = acc_deviceptr_(c_loc(rh3(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh4_dev = acc_deviceptr_(c_loc(rh4(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh5_dev = acc_deviceptr_(c_loc(rh5(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh6_dev = acc_deviceptr_(c_loc(rh6(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh7_dev = acc_deviceptr_(c_loc(rh7(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    rh8_dev = acc_deviceptr_(c_loc(rh8(jb_in - 0 + 1, &
                                    & kb_in - 0 + 1, &
                                    & lb_in - 0 + 1)))
    dsp_dev = acc_deviceptr_(c_loc(dsp(jb_in + 1)))
    if (.not. c_associated(f1_dev) .or. .not. c_associated(f2_dev) .or. &
        & .not. c_associated(f3_dev) .or. .not. c_associated(f4_dev) .or. &
        & .not. c_associated(f5_dev) .or. .not. c_associated(f6_dev) .or. &
        & .not. c_associated(f7_dev) .or. .not. c_associated(f8_dev) .or. &
        & .not. c_associated(fsrc_dev) .or. .not. c_associated(qa1_dev) .or. &
        & .not. c_associated(qa2_dev) .or. .not. c_associated(rh1_dev) .or. &
        & .not. c_associated(dsp_dev)) then
      ! name the offender: the fields cross as raw device pointers, and a host-only array is the
      ! usual reason one of them is null
      if (.not. c_associated(f1_dev)) print *, 'm_dace_kernels_fdiff_src: f1 not device-present'
      if (.not. c_associated(f2_dev)) print *, 'm_dace_kernels_fdiff_src: f2 not device-present'
      if (.not. c_associated(f3_dev)) print *, 'm_dace_kernels_fdiff_src: f3 not device-present'
      if (.not. c_associated(f4_dev)) print *, 'm_dace_kernels_fdiff_src: f4 not device-present'
      if (.not. c_associated(f5_dev)) print *, 'm_dace_kernels_fdiff_src: f5 not device-present'
      if (.not. c_associated(f6_dev)) print *, 'm_dace_kernels_fdiff_src: f6 not device-present'
      if (.not. c_associated(f7_dev)) print *, 'm_dace_kernels_fdiff_src: f7 not device-present'
      if (.not. c_associated(f8_dev)) print *, 'm_dace_kernels_fdiff_src: f8 not device-present'
      if (.not. c_associated(fsrc_dev)) print *, 'm_dace_kernels_fdiff_src: fsrc not device-present'
      if (.not. c_associated(qa1_dev)) print *, 'm_dace_kernels_fdiff_src: qa1 not device-present'
      if (.not. c_associated(qa2_dev)) print *, 'm_dace_kernels_fdiff_src: qa2 not device-present'
      if (.not. c_associated(rh1_dev)) print *, 'm_dace_kernels_fdiff_src: rh1 not device-present'
      if (.not. c_associated(dsp_dev)) print *, 'm_dace_kernels_fdiff_src: dsp not device-present'
      error stop 1
    end if

    ! one line per run: a gate run's log then says which dispatch produced it (a stack of
    ! bit-identical comparisons cannot tell the fused path from the stock one)
    if (.not. announced) then
      print *, 'm_dace_kernels_fdiff_src: M3 fused fdiff+alpha dispatch active (x,y,z)=', &
               fdiff_src_dirs(1), fdiff_src_dirs(2), fdiff_src_dirs(3)
      announced = .true.
    end if

    select case (dir_in)
    case (1)   ! x
      x_state = fdiff_src_init_x(ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64)
      call fdiff_src_run_x(x_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64)
      ierr = fdiff_src_exit_x(x_state)
    case (2)   ! y
      y_state = fdiff_src_init_y(ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64)
      call fdiff_src_run_y(y_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64)
      ierr = fdiff_src_exit_y(y_state)
    case (3)   ! z
      z_state = fdiff_src_init_z(ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64, ext64)
      call fdiff_src_run_z(z_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64, ext64, ext64, &
          & ext64, ext64, ext64, ext64)
      ierr = fdiff_src_exit_z(z_state)
    case default
      print *, 'm_dace_kernels_fdiff_src: bad direction', dir_in
      error stop 1
    end select
  end subroutine s_dace_fdiff_src

end module m_dace_kernels_fdiff_src
#endif
