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
    function cudaMemcpy_(dst, src, count, kind) bind(C, name='cudaMemcpy')
      import :: c_ptr, c_size_t, c_int
      integer(c_int) :: cudaMemcpy_
      type(c_ptr), value :: dst, src
      integer(c_size_t), value :: count
      integer(c_int), value :: kind
    end function

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
  !! MFC_DACE_FDIFF_SRC_DIRS is a "101"-style per-direction mask.
  !! The Z DIRECTION IS DISABLED regardless of the mask (see the guard in the body).  The contract lists every
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
      ! ---- z is ENABLED again (2026-09-18): the divergence it was contained for was an
      ! artefact.  The shim declared its twenty device pointers and never assigned them, so the
      ! null-check read uninitialised stack and the kernel was launched with stack garbage.  With
      ! the assignments emitted, all three directions are bit-identical against the stock loops on
      ! the real viscous case (vis32R, buff=6: masks 100 / 010 / 001 and the full mask, 104 field
      ! files each, double filter).  The repro that used to "show" the z bug
      ! (scripts/m3z_repro.sh, a transposed-IC fixture) now diverges for *x* as well, so it was
      ! testing its own fixture, not the direction: its ICs have been consumed by earlier runs
      ! (they read as denormals) and it no longer distinguishes anything.  Validate a direction on
      ! the real case, with an IC regenerated from the config, never on that fixture.
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
                              & jb_in, je_in, kb_in, ke_in, lb_in, le_in, dir_in, &
                              & ext_f, ext_r, ext_s)
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
    character(len=8) :: dbg_env, dbg_env2
    integer :: m3k, m3j, m3_nc
    logical, save :: m3_dumped = .false.
    integer :: dbg_st
    logical, save :: m3_probed = .false.
    real(c_double), allocatable :: m3_probe_buf(:)
    type(c_ptr) :: m3_probe_dst
    integer(c_int) :: m3_probe_ierr
    ! device->host copy kind, and the ABI, for reading the device data directly
    integer(c_int), parameter :: cpD2H = 2_c_int
    !> leading dimension of each bound class: the flux/alpha rows share MFC's idwbuff
    !! bounds, the rhs rows are (0:m, 0:n, 0:p) and the spacing is (-buff:m+buff).
    !! The dummies are sections (see `ptr`), so their own size is not the parent's.
    integer, intent(in) :: ext_f, ext_r, ext_s

    integer :: lbnd(3), b(6)
    logical, save :: announced = .false.
    integer(c_int64_t) :: ext64
    integer(c_int) :: ierr
    type(c_ptr) :: f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, rh7_dev, rh8_dev, dsp_dev

    ! Resolve each field's device address.  THIS ASSIGNMENT IS LOAD-BEARING and used to be missing:
    ! `ptr` was built and never emitted, so every *_dev stayed uninitialised stack, the null-check
    ! below then reported whichever garbage happened to be zero, and the kernel was launched with
    ! whatever the stack held.  It looked exactly like "the runtime did not map these arrays" --
    ! partial, non-patterned nulls one run and all-null the next -- and sent a long hunt after an
    ! OpenACC mapping problem that did not exist.  Whatever else changes here, keep this emitted.
    f1_dev = acc_deviceptr_(c_loc(f1(lbound(f1, 1), &
                                    & lbound(f1, 2), &
                                    & lbound(f1, 3))))
    f2_dev = acc_deviceptr_(c_loc(f2(lbound(f2, 1), &
                                    & lbound(f2, 2), &
                                    & lbound(f2, 3))))
    f3_dev = acc_deviceptr_(c_loc(f3(lbound(f3, 1), &
                                    & lbound(f3, 2), &
                                    & lbound(f3, 3))))
    f4_dev = acc_deviceptr_(c_loc(f4(lbound(f4, 1), &
                                    & lbound(f4, 2), &
                                    & lbound(f4, 3))))
    f5_dev = acc_deviceptr_(c_loc(f5(lbound(f5, 1), &
                                    & lbound(f5, 2), &
                                    & lbound(f5, 3))))
    f6_dev = acc_deviceptr_(c_loc(f6(lbound(f6, 1), &
                                    & lbound(f6, 2), &
                                    & lbound(f6, 3))))
    f7_dev = acc_deviceptr_(c_loc(f7(lbound(f7, 1), &
                                    & lbound(f7, 2), &
                                    & lbound(f7, 3))))
    f8_dev = acc_deviceptr_(c_loc(f8(lbound(f8, 1), &
                                    & lbound(f8, 2), &
                                    & lbound(f8, 3))))
    fsrc_dev = acc_deviceptr_(c_loc(fsrc(lbound(fsrc, 1), &
                                    & lbound(fsrc, 2), &
                                    & lbound(fsrc, 3))))
    qa1_dev = acc_deviceptr_(c_loc(qa1(lbound(qa1, 1), &
                                    & lbound(qa1, 2), &
                                    & lbound(qa1, 3))))
    qa2_dev = acc_deviceptr_(c_loc(qa2(lbound(qa2, 1), &
                                    & lbound(qa2, 2), &
                                    & lbound(qa2, 3))))
    rh1_dev = acc_deviceptr_(c_loc(rh1(lbound(rh1, 1), &
                                    & lbound(rh1, 2), &
                                    & lbound(rh1, 3))))
    rh2_dev = acc_deviceptr_(c_loc(rh2(lbound(rh2, 1), &
                                    & lbound(rh2, 2), &
                                    & lbound(rh2, 3))))
    rh3_dev = acc_deviceptr_(c_loc(rh3(lbound(rh3, 1), &
                                    & lbound(rh3, 2), &
                                    & lbound(rh3, 3))))
    rh4_dev = acc_deviceptr_(c_loc(rh4(lbound(rh4, 1), &
                                    & lbound(rh4, 2), &
                                    & lbound(rh4, 3))))
    rh5_dev = acc_deviceptr_(c_loc(rh5(lbound(rh5, 1), &
                                    & lbound(rh5, 2), &
                                    & lbound(rh5, 3))))
    rh6_dev = acc_deviceptr_(c_loc(rh6(lbound(rh6, 1), &
                                    & lbound(rh6, 2), &
                                    & lbound(rh6, 3))))
    rh7_dev = acc_deviceptr_(c_loc(rh7(lbound(rh7, 1), &
                                    & lbound(rh7, 2), &
                                    & lbound(rh7, 3))))
    rh8_dev = acc_deviceptr_(c_loc(rh8(lbound(rh8, 1), &
                                    & lbound(rh8, 2), &
                                    & lbound(rh8, 3))))
    dsp_dev = acc_deviceptr_(c_loc(dsp(lbound(dsp, 1))))

    lbnd = [lbound(f1, 1), lbound(f1, 2), lbound(f1, 3)]
    b = [jb_in, je_in, kb_in, ke_in, lb_in, le_in]

    ! ---- optional ABI probe (MFC_DACE_FDIFF_SRC_PROBE): the bounds, extents and dummy extents the
    ! kernel is handed for each direction.  These are case-independent, which is what makes them
    ! worth printing once: a per-direction difference here is invisible in the call text (the
    ! caller's arguments read the same for all three) but changes what the kernel addresses.
    call get_environment_variable('MFC_DACE_FDIFF_SRC_PROBE', dbg_env, status=dbg_st)
    if (dbg_st == 0 .and. len_trim(dbg_env) > 0 .and. trim(dbg_env) /= '0' .and. .not. m3_probed) then
      m3_probed = .true.
      print '(A,I2,A,6(I0,1X))', 'M3PROBE dir=', dir_in, ' b=', b
      print '(A,3(I0,1X))', 'M3PROBE ext_f/ext_r/ext_s=', ext_f, ext_r, ext_s
      print '(A,6(I0,1X))', 'M3PROBE f1 lb/shape, dsp lb/size =', lbound(f1, 1), lbound(f1, 2), lbound(f1, 3), &
              size(f1, 1), size(f1, 2), size(f1, 3)
      print '(A,4(I0,1X))', 'M3PROBE rh1 lb/shape =', lbound(rh1, 1), lbound(rh1, 2), lbound(rh1, 3), size(rh1, 1)
      print '(A,2(I0,1X))', 'M3PROBE dsp lb/size =', lbound(dsp, 1), size(dsp, 1)
      ! ---- the kernel's INPUT, off the device (MFC_DACE_FDIFF_SRC_DUMP): a flux row and the two
      ! advection inputs, copied one CONTIGUOUS ROW at a time.  A flat memcpy would be wrong -- the
      ! dummy spans the section but the parent's stride is ext_f, so a block copy would splice the
      ! ghost planes into the interior.  The result is a clean (nc,nc,nc) block per array.
      call get_environment_variable('MFC_DACE_FDIFF_SRC_DUMP', dbg_env2, status=dbg_st)
      if (dbg_st == 0 .and. len_trim(dbg_env2) > 0 .and. trim(dbg_env2) /= '0' .and. .not. m3_dumped) then
        m3_dumped = .true.
        m3_nc = b(2) - b(1) + 1
        allocate (m3_probe_buf(int(3*m3_nc*m3_nc*m3_nc, c_int64_t)))
        do m3k = 0, m3_nc - 1
          do m3j = 0, m3_nc - 1
            m3_probe_ierr = cudaMemcpy_(c_loc(m3_probe_buf(1 + m3k*m3_nc*m3_nc + m3j*m3_nc)), &
                                        transfer(transfer(f6_dev, 0_c_int64_t) + &
                                                 8_c_int64_t*int(m3j*ext_f + m3k*ext_f*ext_f, c_int64_t), c_null_ptr), &
                                        int(m3_nc*8, c_size_t), cpD2H)
            m3_probe_ierr = cudaMemcpy_(c_loc(m3_probe_buf(1 + m3_nc**3 + m3k*m3_nc*m3_nc + m3j*m3_nc)), &
                                        transfer(transfer(fsrc_dev, 0_c_int64_t) + &
                                                 8_c_int64_t*int(m3j*ext_f + m3k*ext_f*ext_f, c_int64_t), c_null_ptr), &
                                        int(m3_nc*8, c_size_t), cpD2H)
            m3_probe_ierr = cudaMemcpy_(c_loc(m3_probe_buf(1 + 2*m3_nc**3 + m3k*m3_nc*m3_nc + m3j*m3_nc)), &
                                        transfer(transfer(qa1_dev, 0_c_int64_t) + &
                                                 8_c_int64_t*int(m3j*ext_f + m3k*ext_f*ext_f, c_int64_t), c_null_ptr), &
                                        int(m3_nc*8, c_size_t), cpD2H)
          end do
        end do
        ! A failed copy leaves the buffer at its allocated value, so an unchecked memcpy from a
        ! null/unmapped device pointer reads as a clean "all zeros" -- which is exactly how the
        ! first version of this probe produced the (wrong) conclusion that the kernel sees qa=0.
        ! Print the status and the three pointers, and stop: a dump that cannot be trusted must
        ! never look like data.
        if (m3_probe_ierr /= 0) then
          print '(A,I0,A,3(I0,1X))', 'M3DUMP cudaMemcpy FAILED ierr=', m3_probe_ierr, &
                  ' f6/fsrc/qa1 dev =', transfer(f6_dev, 0_c_int64_t), transfer(fsrc_dev, 0_c_int64_t), &
                  transfer(qa1_dev, 0_c_int64_t)
          deallocate (m3_probe_buf)
          error stop 3
        end if
        open (85, file='/tmp/M3DUMP.bin', form='unformatted', access='stream')
        write (85) m3_nc, ext_f, dir_in, m3_probe_buf
        close (85)
        print '(A,3(I0,1X))', 'M3DUMP wrote nc/ext_f/dir =', m3_nc, ext_f, dir_in
        deallocate (m3_probe_buf)
      end if
    end if
    if (.not. c_associated(f1_dev) .or. .not. c_associated(f2_dev) .or. &
        & .not. c_associated(f3_dev) .or. .not. c_associated(f4_dev) .or. &
        & .not. c_associated(f5_dev) .or. .not. c_associated(f6_dev) .or. &
        & .not. c_associated(f7_dev) .or. .not. c_associated(f8_dev) .or. &
        & .not. c_associated(fsrc_dev) .or. .not. c_associated(qa1_dev) .or. &
        & .not. c_associated(qa2_dev) .or. .not. c_associated(rh1_dev) .or. &
        & .not. c_associated(dsp_dev)) then
      ! name the offender: the fields cross as raw device pointers, and a host-only array is the
      ! usual reason one of them is null.  The direction and the dummy's own bounds go in the
      ! header line: whether every direction fails (a plumbing fault) or only one (an addressing
      ! fault), and what the shim was handed, is the first thing a reader needs.
      print '(A,I0,A,6(I0,1X),A,3(I0,1X))', 'm_dace_kernels_fdiff_src: not device-present: dir=', dir_in, &
              ' b=', b, ' f1 lb=', lbound(f1, 1), lbound(f1, 2), lbound(f1, 3)
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
      x_state = fdiff_src_init_x(int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
                                  int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t))
      call fdiff_src_run_x(x_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t))
      ierr = fdiff_src_exit_x(x_state)
    case (2)   ! y
      y_state = fdiff_src_init_y(int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
                                  int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t))
      call fdiff_src_run_y(y_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t))
      ierr = fdiff_src_exit_y(y_state)
    case (3)   ! z
      z_state = fdiff_src_init_z(int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
                                  int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), &
                                  int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
                                  int(ext_r, c_int64_t))
      call fdiff_src_run_z(z_state, &
          & dsp_dev, f1_dev, f2_dev, f3_dev, f4_dev, f5_dev, &
          & f6_dev, f7_dev, f8_dev, fsrc_dev, qa1_dev, qa2_dev, &
          & rh1_dev, rh2_dev, rh3_dev, rh4_dev, rh5_dev, rh6_dev, &
          & rh7_dev, rh8_dev, int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(b(1), c_int), int(b(2), c_int), int(b(3), c_int), int(b(4), c_int), &
          & int(b(5), c_int), int(b(6), c_int), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), int(ext_f, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), &
          & int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t), int(ext_r, c_int64_t))
      ierr = fdiff_src_exit_z(z_state)
    case default
      print *, 'm_dace_kernels_fdiff_src: bad direction', dir_in
      error stop 1
    end select

  end subroutine s_dace_fdiff_src

end module m_dace_kernels_fdiff_src
#endif
