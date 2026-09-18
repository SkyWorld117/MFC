#if defined(MFC_DACE)
module m_dace_kernels_visc_family
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_double, c_associated, &
                                         c_loc, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_visc_avg_d0, s_dace_visc_avg_d2, s_dace_visc_grad_d0, s_dace_visc_grad_d1, &
         & s_dace_visc_grad_d2, visc_family_enabled, visc_family_contract

  interface
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function

    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function

    subroutine visc_avg_d0_run(state, dl1, dl2, dl3, dr1, dr2, dr3, ol1, ol2, ol3, or1, or2, or3, a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, dl1_d0, dl1_d1, dl2_d0, dl2_d1, dl3_d0, dl3_d1, dr1_d0, dr1_d1, dr2_d0, dr2_d1, dr3_d0, dr3_d1, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, ulb, ure) &
        bind(C, name='__program_mfc_dace_visc_avg_d0')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dl1
      type(c_ptr), value :: dl2
      type(c_ptr), value :: dl3
      type(c_ptr), value :: dr1
      type(c_ptr), value :: dr2
      type(c_ptr), value :: dr3
      type(c_ptr), value :: ol1
      type(c_ptr), value :: ol2
      type(c_ptr), value :: ol3
      type(c_ptr), value :: or1
      type(c_ptr), value :: or2
      type(c_ptr), value :: or3
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: dl1_d0
      integer(c_int64_t), value :: dl1_d1
      integer(c_int64_t), value :: dl2_d0
      integer(c_int64_t), value :: dl2_d1
      integer(c_int64_t), value :: dl3_d0
      integer(c_int64_t), value :: dl3_d1
      integer(c_int64_t), value :: dr1_d0
      integer(c_int64_t), value :: dr1_d1
      integer(c_int64_t), value :: dr2_d0
      integer(c_int64_t), value :: dr2_d1
      integer(c_int64_t), value :: dr3_d0
      integer(c_int64_t), value :: dr3_d1
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end subroutine

    function visc_avg_d0_init(a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, dl1_d0, dl1_d1, dl2_d0, dl2_d1, dl3_d0, dl3_d1, dr1_d0, dr1_d1, dr2_d0, dr2_d1, dr3_d0, dr3_d1, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, ulb, ure) &
        bind(C, name='__dace_init_mfc_dace_visc_avg_d0')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_avg_d0_init
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: dl1_d0
      integer(c_int64_t), value :: dl1_d1
      integer(c_int64_t), value :: dl2_d0
      integer(c_int64_t), value :: dl2_d1
      integer(c_int64_t), value :: dl3_d0
      integer(c_int64_t), value :: dl3_d1
      integer(c_int64_t), value :: dr1_d0
      integer(c_int64_t), value :: dr1_d1
      integer(c_int64_t), value :: dr2_d0
      integer(c_int64_t), value :: dr2_d1
      integer(c_int64_t), value :: dr3_d0
      integer(c_int64_t), value :: dr3_d1
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end function

    function visc_avg_d0_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_avg_d0')
      import :: c_ptr, c_int
      integer(c_int) :: visc_avg_d0_exit
      type(c_ptr), value :: state
    end function

    subroutine visc_avg_d2_run(state, dl1, dl2, dl3, dr1, dr2, dr3, ol1, ol2, ol3, or1, or2, or3, a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, dl1_d0, dl1_d1, dl2_d0, dl2_d1, dl3_d0, dl3_d1, dr1_d0, dr1_d1, dr2_d0, dr2_d1, dr3_d0, dr3_d1, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, ulb, ure) &
        bind(C, name='__program_mfc_dace_visc_avg_d2')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: dl1
      type(c_ptr), value :: dl2
      type(c_ptr), value :: dl3
      type(c_ptr), value :: dr1
      type(c_ptr), value :: dr2
      type(c_ptr), value :: dr3
      type(c_ptr), value :: ol1
      type(c_ptr), value :: ol2
      type(c_ptr), value :: ol3
      type(c_ptr), value :: or1
      type(c_ptr), value :: or2
      type(c_ptr), value :: or3
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: dl1_d0
      integer(c_int64_t), value :: dl1_d1
      integer(c_int64_t), value :: dl2_d0
      integer(c_int64_t), value :: dl2_d1
      integer(c_int64_t), value :: dl3_d0
      integer(c_int64_t), value :: dl3_d1
      integer(c_int64_t), value :: dr1_d0
      integer(c_int64_t), value :: dr1_d1
      integer(c_int64_t), value :: dr2_d0
      integer(c_int64_t), value :: dr2_d1
      integer(c_int64_t), value :: dr3_d0
      integer(c_int64_t), value :: dr3_d1
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end subroutine

    function visc_avg_d2_init(a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, dl1_d0, dl1_d1, dl2_d0, dl2_d1, dl3_d0, dl3_d1, dr1_d0, dr1_d1, dr2_d0, dr2_d1, dr3_d0, dr3_d1, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, ulb, ure) &
        bind(C, name='__dace_init_mfc_dace_visc_avg_d2')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_avg_d2_init
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: dl1_d0
      integer(c_int64_t), value :: dl1_d1
      integer(c_int64_t), value :: dl2_d0
      integer(c_int64_t), value :: dl2_d1
      integer(c_int64_t), value :: dl3_d0
      integer(c_int64_t), value :: dl3_d1
      integer(c_int64_t), value :: dr1_d0
      integer(c_int64_t), value :: dr1_d1
      integer(c_int64_t), value :: dr2_d0
      integer(c_int64_t), value :: dr2_d1
      integer(c_int64_t), value :: dr3_d0
      integer(c_int64_t), value :: dr3_d1
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end function

    function visc_avg_d2_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_avg_d2')
      import :: c_ptr, c_int
      integer(c_int) :: visc_avg_d2_exit
      type(c_ptr), value :: state
    end function

    subroutine visc_grad_d0_run(state, cc, ol1, ol2, ol3, or1, or2, or3, q1, q2, q3, a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__program_mfc_dace_visc_grad_d0')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: cc
      type(c_ptr), value :: ol1
      type(c_ptr), value :: ol2
      type(c_ptr), value :: ol3
      type(c_ptr), value :: or1
      type(c_ptr), value :: or2
      type(c_ptr), value :: or3
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end subroutine

    function visc_grad_d0_init(a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__dace_init_mfc_dace_visc_grad_d0')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_grad_d0_init
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end function

    function visc_grad_d0_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_grad_d0')
      import :: c_ptr, c_int
      integer(c_int) :: visc_grad_d0_exit
      type(c_ptr), value :: state
    end function

    subroutine visc_grad_d1_run(state, cc, ol1, ol2, ol3, or1, or2, or3, q1, q2, q3, a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__program_mfc_dace_visc_grad_d1')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: cc
      type(c_ptr), value :: ol1
      type(c_ptr), value :: ol2
      type(c_ptr), value :: ol3
      type(c_ptr), value :: or1
      type(c_ptr), value :: or2
      type(c_ptr), value :: or3
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end subroutine

    function visc_grad_d1_init(a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__dace_init_mfc_dace_visc_grad_d1')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_grad_d1_init
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end function

    function visc_grad_d1_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_grad_d1')
      import :: c_ptr, c_int
      integer(c_int) :: visc_grad_d1_exit
      type(c_ptr), value :: state
    end function

    subroutine visc_grad_d2_run(state, cc, ol1, ol2, ol3, or1, or2, or3, q1, q2, q3, a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__program_mfc_dace_visc_grad_d2')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: cc
      type(c_ptr), value :: ol1
      type(c_ptr), value :: ol2
      type(c_ptr), value :: ol3
      type(c_ptr), value :: or1
      type(c_ptr), value :: or2
      type(c_ptr), value :: or3
      type(c_ptr), value :: q1
      type(c_ptr), value :: q2
      type(c_ptr), value :: q3
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end subroutine

    function visc_grad_d2_init(a_hi, a_lo, b_hi, b_lo, c_hi, c_lo, ol1_d0, ol1_d1, ol2_d0, ol2_d1, ol3_d0, ol3_d1, or1_d0, or1_d1, or2_d0, or2_d1, or3_d0, or3_d1, q1_d0, q1_d1, q2_d0, q2_d1, q3_d0, q3_d1, ulb, ure) &
        bind(C, name='__dace_init_mfc_dace_visc_grad_d2')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: visc_grad_d2_init
      integer(c_int), value :: a_hi
      integer(c_int), value :: a_lo
      integer(c_int), value :: b_hi
      integer(c_int), value :: b_lo
      integer(c_int), value :: c_hi
      integer(c_int), value :: c_lo
      integer(c_int64_t), value :: ol1_d0
      integer(c_int64_t), value :: ol1_d1
      integer(c_int64_t), value :: ol2_d0
      integer(c_int64_t), value :: ol2_d1
      integer(c_int64_t), value :: ol3_d0
      integer(c_int64_t), value :: ol3_d1
      integer(c_int64_t), value :: or1_d0
      integer(c_int64_t), value :: or1_d1
      integer(c_int64_t), value :: or2_d0
      integer(c_int64_t), value :: or2_d1
      integer(c_int64_t), value :: or3_d0
      integer(c_int64_t), value :: or3_d1
      integer(c_int64_t), value :: q1_d0
      integer(c_int64_t), value :: q1_d1
      integer(c_int64_t), value :: q2_d0
      integer(c_int64_t), value :: q2_d1
      integer(c_int64_t), value :: q3_d0
      integer(c_int64_t), value :: q3_d1
      integer(c_int), value :: ulb
      integer(c_int), value :: ure
    end function

    function visc_grad_d2_exit(state) bind(C, name='__dace_exit_mfc_dace_visc_grad_d2')
      import :: c_ptr, c_int
      integer(c_int) :: visc_grad_d2_exit
      type(c_ptr), value :: state
    end function

  end interface

  type(c_ptr), save :: visc_avg_d0_state = c_null_ptr
  type(c_ptr), save :: visc_avg_d0_dl1_dev
  type(c_ptr), save :: visc_avg_d0_dl2_dev
  type(c_ptr), save :: visc_avg_d0_dl3_dev
  type(c_ptr), save :: visc_avg_d0_dr1_dev
  type(c_ptr), save :: visc_avg_d0_dr2_dev
  type(c_ptr), save :: visc_avg_d0_dr3_dev
  type(c_ptr), save :: visc_avg_d0_ol1_dev
  type(c_ptr), save :: visc_avg_d0_ol2_dev
  type(c_ptr), save :: visc_avg_d0_ol3_dev
  type(c_ptr), save :: visc_avg_d0_or1_dev
  type(c_ptr), save :: visc_avg_d0_or2_dev
  type(c_ptr), save :: visc_avg_d0_or3_dev
  type(c_ptr), save :: visc_avg_d2_state = c_null_ptr
  type(c_ptr), save :: visc_avg_d2_dl1_dev
  type(c_ptr), save :: visc_avg_d2_dl2_dev
  type(c_ptr), save :: visc_avg_d2_dl3_dev
  type(c_ptr), save :: visc_avg_d2_dr1_dev
  type(c_ptr), save :: visc_avg_d2_dr2_dev
  type(c_ptr), save :: visc_avg_d2_dr3_dev
  type(c_ptr), save :: visc_avg_d2_ol1_dev
  type(c_ptr), save :: visc_avg_d2_ol2_dev
  type(c_ptr), save :: visc_avg_d2_ol3_dev
  type(c_ptr), save :: visc_avg_d2_or1_dev
  type(c_ptr), save :: visc_avg_d2_or2_dev
  type(c_ptr), save :: visc_avg_d2_or3_dev
  type(c_ptr), save :: visc_grad_d0_state = c_null_ptr
  type(c_ptr), save :: visc_grad_d0_cc_dev
  type(c_ptr), save :: visc_grad_d0_ol1_dev
  type(c_ptr), save :: visc_grad_d0_ol2_dev
  type(c_ptr), save :: visc_grad_d0_ol3_dev
  type(c_ptr), save :: visc_grad_d0_or1_dev
  type(c_ptr), save :: visc_grad_d0_or2_dev
  type(c_ptr), save :: visc_grad_d0_or3_dev
  type(c_ptr), save :: visc_grad_d0_q1_dev
  type(c_ptr), save :: visc_grad_d0_q2_dev
  type(c_ptr), save :: visc_grad_d0_q3_dev
  type(c_ptr), save :: visc_grad_d1_state = c_null_ptr
  type(c_ptr), save :: visc_grad_d1_cc_dev
  type(c_ptr), save :: visc_grad_d1_ol1_dev
  type(c_ptr), save :: visc_grad_d1_ol2_dev
  type(c_ptr), save :: visc_grad_d1_ol3_dev
  type(c_ptr), save :: visc_grad_d1_or1_dev
  type(c_ptr), save :: visc_grad_d1_or2_dev
  type(c_ptr), save :: visc_grad_d1_or3_dev
  type(c_ptr), save :: visc_grad_d1_q1_dev
  type(c_ptr), save :: visc_grad_d1_q2_dev
  type(c_ptr), save :: visc_grad_d1_q3_dev
  type(c_ptr), save :: visc_grad_d2_state = c_null_ptr
  type(c_ptr), save :: visc_grad_d2_cc_dev
  type(c_ptr), save :: visc_grad_d2_ol1_dev
  type(c_ptr), save :: visc_grad_d2_ol2_dev
  type(c_ptr), save :: visc_grad_d2_ol3_dev
  type(c_ptr), save :: visc_grad_d2_or1_dev
  type(c_ptr), save :: visc_grad_d2_or2_dev
  type(c_ptr), save :: visc_grad_d2_or3_dev
  type(c_ptr), save :: visc_grad_d2_q1_dev
  type(c_ptr), save :: visc_grad_d2_q2_dev
  type(c_ptr), save :: visc_grad_d2_q3_dev
contains

  !> `MFC_DACE_VISC_FAMILY` -- one switch for the six AVG/GRAD libraries, unset = ON and `=0` runs
  !! the stock loops.
  !!
  !! The mask is by STORAGE DIMENSION, not by face direction: the six libraries are grouped
  !! (avg d0 + grad d0) / (grad d1) / (avg d2 + grad d2), which is the only grouping under which
  !! each group is one library family and can be A/B'd on its own.  `nd` is dim + 1.
  function visc_family_enabled(nd) result(c)
    integer, intent(in) :: nd
    logical :: c
    character(len=8) :: env
    integer :: st
    logical, save :: cached = .false., val = .true.
    logical, save :: dirs(3) = [.true., .true., .true.]
    if (.not. cached) then
      call get_environment_variable('MFC_DACE_VISC_FAMILY', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) val = env(1:1) /= '0'
      call get_environment_variable('MFC_DACE_VISC_FAMILY_DIRS', env, status=st)
      if (st == 0 .and. len_trim(env) >= 1) then
        dirs(1) = env(1:1) == '1'
        dirs(2) = len_trim(env) < 2 .or. env(2:2) == '1'
        dirs(3) = len_trim(env) < 3 .or. env(3:3) == '1'
      end if
      cached = .true.
    end if
    c = val .and. dirs(nd)
  end function visc_family_enabled

  !> The bake's contract.  `viscous` is not redundant with the caller's own guard: MFC allocates
  !! these gradient arrays 1x1x1 on the inviscid path, and the shim derives the extents it hands
  !! over from the parent -- so a dispatch that fired there would pass full-size strides for a 1x1x1
  !! array, which is an out-of-bounds read rather than a wrong number.
  function visc_family_contract() result(c)
    logical :: c
    c = (num_dims == 3 .and. num_vels == 3 .and. .not. cyl_coord .and. viscous)
  end function visc_family_contract

  !> Say ONCE per storage dimension that a library engaged.  A stack of bit-identical comparisons
  !! cannot tell two paths apart, and more than one of these six runs for a single direction, so the
  !! tag names the library rather than the direction.
  subroutine visc_family_announce(dim)
    integer, intent(in) :: dim
    logical, save :: said(3) = [.false., .false., .false.]
    if (.not. said(dim + 1)) then
      said(dim + 1) = .true.
      print '(a,i1,a)', 'm_dace_kernels_visc_family: d', dim, ' engaged (MFC_DACE_VISC_FAMILY)'
    end if
  end subroutine visc_family_announce

  !> The face average pair with its difference on storage dimension 0, replacing two stock loops.
  !! The rows are MFC's own -- the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0, the ranges below are raw (negative ones walk into the parent's ghost
  !! ring by pointer arithmetic, as the stock loops do), and the extents are the PARENT's.
  subroutine s_dace_visc_avg_d0(dl1, dl2, dl3, dr1, dr2, dr3, ol1, ol2, ol3, or1, or2, or3, ext_k, ext_j, a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure)
    real(c_double), dimension(:, :, :), intent(in), target :: dl1
    real(c_double), dimension(:, :, :), intent(in), target :: dl2
    real(c_double), dimension(:, :, :), intent(in), target :: dl3
    real(c_double), dimension(:, :, :), intent(in), target :: dr1
    real(c_double), dimension(:, :, :), intent(in), target :: dr2
    real(c_double), dimension(:, :, :), intent(in), target :: dr3
    real(c_double), dimension(:, :, :), intent(inout), target :: ol1
    real(c_double), dimension(:, :, :), intent(inout), target :: ol2
    real(c_double), dimension(:, :, :), intent(inout), target :: ol3
    real(c_double), dimension(:, :, :), intent(inout), target :: or1
    real(c_double), dimension(:, :, :), intent(inout), target :: or2
    real(c_double), dimension(:, :, :), intent(inout), target :: or3
    integer, intent(in) :: ext_k, ext_j
    integer, intent(in) :: a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure
    integer :: ierr

    call visc_family_announce(0)

    visc_avg_d0_dl1_dev = acc_deviceptr_(c_loc(dl1(lbound(dl1, 1), lbound(dl1, 2), lbound(dl1, 3))))
    visc_avg_d0_dl2_dev = acc_deviceptr_(c_loc(dl2(lbound(dl2, 1), lbound(dl2, 2), lbound(dl2, 3))))
    visc_avg_d0_dl3_dev = acc_deviceptr_(c_loc(dl3(lbound(dl3, 1), lbound(dl3, 2), lbound(dl3, 3))))
    visc_avg_d0_dr1_dev = acc_deviceptr_(c_loc(dr1(lbound(dr1, 1), lbound(dr1, 2), lbound(dr1, 3))))
    visc_avg_d0_dr2_dev = acc_deviceptr_(c_loc(dr2(lbound(dr2, 1), lbound(dr2, 2), lbound(dr2, 3))))
    visc_avg_d0_dr3_dev = acc_deviceptr_(c_loc(dr3(lbound(dr3, 1), lbound(dr3, 2), lbound(dr3, 3))))
    visc_avg_d0_ol1_dev = acc_deviceptr_(c_loc(ol1(lbound(ol1, 1), lbound(ol1, 2), lbound(ol1, 3))))
    visc_avg_d0_ol2_dev = acc_deviceptr_(c_loc(ol2(lbound(ol2, 1), lbound(ol2, 2), lbound(ol2, 3))))
    visc_avg_d0_ol3_dev = acc_deviceptr_(c_loc(ol3(lbound(ol3, 1), lbound(ol3, 2), lbound(ol3, 3))))
    visc_avg_d0_or1_dev = acc_deviceptr_(c_loc(or1(lbound(or1, 1), lbound(or1, 2), lbound(or1, 3))))
    visc_avg_d0_or2_dev = acc_deviceptr_(c_loc(or2(lbound(or2, 1), lbound(or2, 2), lbound(or2, 3))))
    visc_avg_d0_or3_dev = acc_deviceptr_(c_loc(or3(lbound(or3, 1), lbound(or3, 2), lbound(or3, 3))))
    if (.not. c_associated(visc_avg_d0_state)) then
      visc_avg_d0_state = visc_avg_d0_init(int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), &
          & int(b_lo, c_int), int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), &
          & int(ure, c_int))
    end if
    call visc_avg_d0_run(visc_avg_d0_state, visc_avg_d0_dl1_dev, visc_avg_d0_dl2_dev, visc_avg_d0_dl3_dev, &
        & visc_avg_d0_dr1_dev, visc_avg_d0_dr2_dev, visc_avg_d0_dr3_dev, visc_avg_d0_ol1_dev, &
        & visc_avg_d0_ol2_dev, visc_avg_d0_ol3_dev, visc_avg_d0_or1_dev, visc_avg_d0_or2_dev, &
        & visc_avg_d0_or3_dev, int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), int(b_lo, c_int), &
        & int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), int(ure, c_int))
    ! Order the kernel against the OpenACC runtime, whose loops use the legacy default stream while
    ! DaCe's own stream is deliberately non-blocking.  Without this the next OpenACC loop over these
    ! arrays races the kernel that just wrote them.
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_family: visc_avg_d0: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_d0

  !> The face average pair with its difference on storage dimension 2, replacing two stock loops.
  !! The rows are MFC's own -- the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0, the ranges below are raw (negative ones walk into the parent's ghost
  !! ring by pointer arithmetic, as the stock loops do), and the extents are the PARENT's.
  subroutine s_dace_visc_avg_d2(dl1, dl2, dl3, dr1, dr2, dr3, ol1, ol2, ol3, or1, or2, or3, ext_k, ext_j, a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure)
    real(c_double), dimension(:, :, :), intent(in), target :: dl1
    real(c_double), dimension(:, :, :), intent(in), target :: dl2
    real(c_double), dimension(:, :, :), intent(in), target :: dl3
    real(c_double), dimension(:, :, :), intent(in), target :: dr1
    real(c_double), dimension(:, :, :), intent(in), target :: dr2
    real(c_double), dimension(:, :, :), intent(in), target :: dr3
    real(c_double), dimension(:, :, :), intent(inout), target :: ol1
    real(c_double), dimension(:, :, :), intent(inout), target :: ol2
    real(c_double), dimension(:, :, :), intent(inout), target :: ol3
    real(c_double), dimension(:, :, :), intent(inout), target :: or1
    real(c_double), dimension(:, :, :), intent(inout), target :: or2
    real(c_double), dimension(:, :, :), intent(inout), target :: or3
    integer, intent(in) :: ext_k, ext_j
    integer, intent(in) :: a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure
    integer :: ierr

    call visc_family_announce(2)

    visc_avg_d2_dl1_dev = acc_deviceptr_(c_loc(dl1(lbound(dl1, 1), lbound(dl1, 2), lbound(dl1, 3))))
    visc_avg_d2_dl2_dev = acc_deviceptr_(c_loc(dl2(lbound(dl2, 1), lbound(dl2, 2), lbound(dl2, 3))))
    visc_avg_d2_dl3_dev = acc_deviceptr_(c_loc(dl3(lbound(dl3, 1), lbound(dl3, 2), lbound(dl3, 3))))
    visc_avg_d2_dr1_dev = acc_deviceptr_(c_loc(dr1(lbound(dr1, 1), lbound(dr1, 2), lbound(dr1, 3))))
    visc_avg_d2_dr2_dev = acc_deviceptr_(c_loc(dr2(lbound(dr2, 1), lbound(dr2, 2), lbound(dr2, 3))))
    visc_avg_d2_dr3_dev = acc_deviceptr_(c_loc(dr3(lbound(dr3, 1), lbound(dr3, 2), lbound(dr3, 3))))
    visc_avg_d2_ol1_dev = acc_deviceptr_(c_loc(ol1(lbound(ol1, 1), lbound(ol1, 2), lbound(ol1, 3))))
    visc_avg_d2_ol2_dev = acc_deviceptr_(c_loc(ol2(lbound(ol2, 1), lbound(ol2, 2), lbound(ol2, 3))))
    visc_avg_d2_ol3_dev = acc_deviceptr_(c_loc(ol3(lbound(ol3, 1), lbound(ol3, 2), lbound(ol3, 3))))
    visc_avg_d2_or1_dev = acc_deviceptr_(c_loc(or1(lbound(or1, 1), lbound(or1, 2), lbound(or1, 3))))
    visc_avg_d2_or2_dev = acc_deviceptr_(c_loc(or2(lbound(or2, 1), lbound(or2, 2), lbound(or2, 3))))
    visc_avg_d2_or3_dev = acc_deviceptr_(c_loc(or3(lbound(or3, 1), lbound(or3, 2), lbound(or3, 3))))
    if (.not. c_associated(visc_avg_d2_state)) then
      visc_avg_d2_state = visc_avg_d2_init(int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), &
          & int(b_lo, c_int), int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), &
          & int(ure, c_int))
    end if
    call visc_avg_d2_run(visc_avg_d2_state, visc_avg_d2_dl1_dev, visc_avg_d2_dl2_dev, visc_avg_d2_dl3_dev, &
        & visc_avg_d2_dr1_dev, visc_avg_d2_dr2_dev, visc_avg_d2_dr3_dev, visc_avg_d2_ol1_dev, &
        & visc_avg_d2_ol2_dev, visc_avg_d2_ol3_dev, visc_avg_d2_or1_dev, visc_avg_d2_or2_dev, &
        & visc_avg_d2_or3_dev, int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), int(b_lo, c_int), &
        & int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), &
        & int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), int(ure, c_int))
    ! Order the kernel against the OpenACC runtime, whose loops use the legacy default stream while
    ! DaCe's own stream is deliberately non-blocking.  Without this the next OpenACC loop over these
    ! arrays races the kernel that just wrote them.
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_family: visc_avg_d2: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_avg_d2

  !> The two-point gradient pair with its difference on storage dimension 0, replacing two stock loops.
  !! The rows are MFC's own -- the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0, the ranges below are raw (negative ones walk into the parent's ghost
  !! ring by pointer arithmetic, as the stock loops do), and the extents are the PARENT's.
  subroutine s_dace_visc_grad_d0(cc, q1, q2, q3, ol1, ol2, ol3, or1, or2, or3, ext_k, ext_j, a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure)
    real(c_double), dimension(:), intent(in), target :: cc
    real(c_double), dimension(:, :, :), intent(in), target :: q1
    real(c_double), dimension(:, :, :), intent(in), target :: q2
    real(c_double), dimension(:, :, :), intent(in), target :: q3
    real(c_double), dimension(:, :, :), intent(inout), target :: ol1
    real(c_double), dimension(:, :, :), intent(inout), target :: ol2
    real(c_double), dimension(:, :, :), intent(inout), target :: ol3
    real(c_double), dimension(:, :, :), intent(inout), target :: or1
    real(c_double), dimension(:, :, :), intent(inout), target :: or2
    real(c_double), dimension(:, :, :), intent(inout), target :: or3
    integer, intent(in) :: ext_k, ext_j
    integer, intent(in) :: a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure
    integer :: ierr

    call visc_family_announce(0)

    visc_grad_d0_cc_dev = acc_deviceptr_(c_loc(cc(lbound(cc, 1))))
    visc_grad_d0_ol1_dev = acc_deviceptr_(c_loc(ol1(lbound(ol1, 1), lbound(ol1, 2), lbound(ol1, 3))))
    visc_grad_d0_ol2_dev = acc_deviceptr_(c_loc(ol2(lbound(ol2, 1), lbound(ol2, 2), lbound(ol2, 3))))
    visc_grad_d0_ol3_dev = acc_deviceptr_(c_loc(ol3(lbound(ol3, 1), lbound(ol3, 2), lbound(ol3, 3))))
    visc_grad_d0_or1_dev = acc_deviceptr_(c_loc(or1(lbound(or1, 1), lbound(or1, 2), lbound(or1, 3))))
    visc_grad_d0_or2_dev = acc_deviceptr_(c_loc(or2(lbound(or2, 1), lbound(or2, 2), lbound(or2, 3))))
    visc_grad_d0_or3_dev = acc_deviceptr_(c_loc(or3(lbound(or3, 1), lbound(or3, 2), lbound(or3, 3))))
    visc_grad_d0_q1_dev = acc_deviceptr_(c_loc(q1(lbound(q1, 1), lbound(q1, 2), lbound(q1, 3))))
    visc_grad_d0_q2_dev = acc_deviceptr_(c_loc(q2(lbound(q2, 1), lbound(q2, 2), lbound(q2, 3))))
    visc_grad_d0_q3_dev = acc_deviceptr_(c_loc(q3(lbound(q3, 1), lbound(q3, 2), lbound(q3, 3))))
    if (.not. c_associated(visc_grad_d0_state)) then
      visc_grad_d0_state = visc_grad_d0_init(int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), &
          & int(b_lo, c_int), int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ulb, c_int), int(ure, c_int))
    end if
    call visc_grad_d0_run(visc_grad_d0_state, visc_grad_d0_cc_dev, visc_grad_d0_ol1_dev, &
        & visc_grad_d0_ol2_dev, visc_grad_d0_ol3_dev, visc_grad_d0_or1_dev, visc_grad_d0_or2_dev, &
        & visc_grad_d0_or3_dev, visc_grad_d0_q1_dev, visc_grad_d0_q2_dev, visc_grad_d0_q3_dev, &
        & int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), int(b_lo, c_int), int(c_hi, c_int), &
        & int(c_lo, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), &
        & int(ure, c_int))
    ! Order the kernel against the OpenACC runtime, whose loops use the legacy default stream while
    ! DaCe's own stream is deliberately non-blocking.  Without this the next OpenACC loop over these
    ! arrays races the kernel that just wrote them.
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_family: visc_grad_d0: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_grad_d0

  !> The two-point gradient pair with its difference on storage dimension 1, replacing two stock loops.
  !! The rows are MFC's own -- the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0, the ranges below are raw (negative ones walk into the parent's ghost
  !! ring by pointer arithmetic, as the stock loops do), and the extents are the PARENT's.
  subroutine s_dace_visc_grad_d1(cc, q1, q2, q3, ol1, ol2, ol3, or1, or2, or3, ext_k, ext_j, a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure)
    real(c_double), dimension(:), intent(in), target :: cc
    real(c_double), dimension(:, :, :), intent(in), target :: q1
    real(c_double), dimension(:, :, :), intent(in), target :: q2
    real(c_double), dimension(:, :, :), intent(in), target :: q3
    real(c_double), dimension(:, :, :), intent(inout), target :: ol1
    real(c_double), dimension(:, :, :), intent(inout), target :: ol2
    real(c_double), dimension(:, :, :), intent(inout), target :: ol3
    real(c_double), dimension(:, :, :), intent(inout), target :: or1
    real(c_double), dimension(:, :, :), intent(inout), target :: or2
    real(c_double), dimension(:, :, :), intent(inout), target :: or3
    integer, intent(in) :: ext_k, ext_j
    integer, intent(in) :: a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure
    integer :: ierr

    call visc_family_announce(1)

    visc_grad_d1_cc_dev = acc_deviceptr_(c_loc(cc(lbound(cc, 1))))
    visc_grad_d1_ol1_dev = acc_deviceptr_(c_loc(ol1(lbound(ol1, 1), lbound(ol1, 2), lbound(ol1, 3))))
    visc_grad_d1_ol2_dev = acc_deviceptr_(c_loc(ol2(lbound(ol2, 1), lbound(ol2, 2), lbound(ol2, 3))))
    visc_grad_d1_ol3_dev = acc_deviceptr_(c_loc(ol3(lbound(ol3, 1), lbound(ol3, 2), lbound(ol3, 3))))
    visc_grad_d1_or1_dev = acc_deviceptr_(c_loc(or1(lbound(or1, 1), lbound(or1, 2), lbound(or1, 3))))
    visc_grad_d1_or2_dev = acc_deviceptr_(c_loc(or2(lbound(or2, 1), lbound(or2, 2), lbound(or2, 3))))
    visc_grad_d1_or3_dev = acc_deviceptr_(c_loc(or3(lbound(or3, 1), lbound(or3, 2), lbound(or3, 3))))
    visc_grad_d1_q1_dev = acc_deviceptr_(c_loc(q1(lbound(q1, 1), lbound(q1, 2), lbound(q1, 3))))
    visc_grad_d1_q2_dev = acc_deviceptr_(c_loc(q2(lbound(q2, 1), lbound(q2, 2), lbound(q2, 3))))
    visc_grad_d1_q3_dev = acc_deviceptr_(c_loc(q3(lbound(q3, 1), lbound(q3, 2), lbound(q3, 3))))
    if (.not. c_associated(visc_grad_d1_state)) then
      visc_grad_d1_state = visc_grad_d1_init(int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), &
          & int(b_lo, c_int), int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ulb, c_int), int(ure, c_int))
    end if
    call visc_grad_d1_run(visc_grad_d1_state, visc_grad_d1_cc_dev, visc_grad_d1_ol1_dev, &
        & visc_grad_d1_ol2_dev, visc_grad_d1_ol3_dev, visc_grad_d1_or1_dev, visc_grad_d1_or2_dev, &
        & visc_grad_d1_or3_dev, visc_grad_d1_q1_dev, visc_grad_d1_q2_dev, visc_grad_d1_q3_dev, &
        & int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), int(b_lo, c_int), int(c_hi, c_int), &
        & int(c_lo, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), &
        & int(ure, c_int))
    ! Order the kernel against the OpenACC runtime, whose loops use the legacy default stream while
    ! DaCe's own stream is deliberately non-blocking.  Without this the next OpenACC loop over these
    ! arrays races the kernel that just wrote them.
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_family: visc_grad_d1: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_grad_d1

  !> The two-point gradient pair with its difference on storage dimension 2, replacing two stock loops.
  !! The rows are MFC's own -- the caller passes `sf(0:, 0:, 0:)` sections, so the dummy's first
  !! element is raw index 0, the ranges below are raw (negative ones walk into the parent's ghost
  !! ring by pointer arithmetic, as the stock loops do), and the extents are the PARENT's.
  subroutine s_dace_visc_grad_d2(cc, q1, q2, q3, ol1, ol2, ol3, or1, or2, or3, ext_k, ext_j, a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure)
    real(c_double), dimension(:), intent(in), target :: cc
    real(c_double), dimension(:, :, :), intent(in), target :: q1
    real(c_double), dimension(:, :, :), intent(in), target :: q2
    real(c_double), dimension(:, :, :), intent(in), target :: q3
    real(c_double), dimension(:, :, :), intent(inout), target :: ol1
    real(c_double), dimension(:, :, :), intent(inout), target :: ol2
    real(c_double), dimension(:, :, :), intent(inout), target :: ol3
    real(c_double), dimension(:, :, :), intent(inout), target :: or1
    real(c_double), dimension(:, :, :), intent(inout), target :: or2
    real(c_double), dimension(:, :, :), intent(inout), target :: or3
    integer, intent(in) :: ext_k, ext_j
    integer, intent(in) :: a_lo, a_hi, b_lo, b_hi, c_lo, c_hi, ulb, ure
    integer :: ierr

    call visc_family_announce(2)

    visc_grad_d2_cc_dev = acc_deviceptr_(c_loc(cc(lbound(cc, 1))))
    visc_grad_d2_ol1_dev = acc_deviceptr_(c_loc(ol1(lbound(ol1, 1), lbound(ol1, 2), lbound(ol1, 3))))
    visc_grad_d2_ol2_dev = acc_deviceptr_(c_loc(ol2(lbound(ol2, 1), lbound(ol2, 2), lbound(ol2, 3))))
    visc_grad_d2_ol3_dev = acc_deviceptr_(c_loc(ol3(lbound(ol3, 1), lbound(ol3, 2), lbound(ol3, 3))))
    visc_grad_d2_or1_dev = acc_deviceptr_(c_loc(or1(lbound(or1, 1), lbound(or1, 2), lbound(or1, 3))))
    visc_grad_d2_or2_dev = acc_deviceptr_(c_loc(or2(lbound(or2, 1), lbound(or2, 2), lbound(or2, 3))))
    visc_grad_d2_or3_dev = acc_deviceptr_(c_loc(or3(lbound(or3, 1), lbound(or3, 2), lbound(or3, 3))))
    visc_grad_d2_q1_dev = acc_deviceptr_(c_loc(q1(lbound(q1, 1), lbound(q1, 2), lbound(q1, 3))))
    visc_grad_d2_q2_dev = acc_deviceptr_(c_loc(q2(lbound(q2, 1), lbound(q2, 2), lbound(q2, 3))))
    visc_grad_d2_q3_dev = acc_deviceptr_(c_loc(q3(lbound(q3, 1), lbound(q3, 2), lbound(q3, 3))))
    if (.not. c_associated(visc_grad_d2_state)) then
      visc_grad_d2_state = visc_grad_d2_init(int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), &
          & int(b_lo, c_int), int(c_hi, c_int), int(c_lo, c_int), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
          & int(ext_j, c_int64_t), int(ulb, c_int), int(ure, c_int))
    end if
    call visc_grad_d2_run(visc_grad_d2_state, visc_grad_d2_cc_dev, visc_grad_d2_ol1_dev, &
        & visc_grad_d2_ol2_dev, visc_grad_d2_ol3_dev, visc_grad_d2_or1_dev, visc_grad_d2_or2_dev, &
        & visc_grad_d2_or3_dev, visc_grad_d2_q1_dev, visc_grad_d2_q2_dev, visc_grad_d2_q3_dev, &
        & int(a_hi, c_int), int(a_lo, c_int), int(b_hi, c_int), int(b_lo, c_int), int(c_hi, c_int), &
        & int(c_lo, c_int), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ext_k, c_int64_t), &
        & int(ext_j, c_int64_t), int(ext_k, c_int64_t), int(ext_j, c_int64_t), int(ulb, c_int), &
        & int(ure, c_int))
    ! Order the kernel against the OpenACC runtime, whose loops use the legacy default stream while
    ! DaCe's own stream is deliberately non-blocking.  Without this the next OpenACC loop over these
    ! arrays races the kernel that just wrote them.
    ierr = cudaDeviceSynchronize_()
    if (ierr /= 0) then
      print *, 'm_dace_kernels_visc_family: visc_grad_d2: a device pointer did not resolve, or the kernel faulted'
      error stop 1
    end if
  end subroutine s_dace_visc_grad_d2

end module m_dace_kernels_visc_family
#endif
