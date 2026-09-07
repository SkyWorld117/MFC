#if defined(MFC_DACE)
module m_dace_kernels_conv
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, &
                                         c_double, c_associated, c_loc, &
                                         c_f_pointer, c_null_ptr
  use m_derived_types
  use m_global_parameters
  implicit none
  private
  public :: s_dace_convert

  ! CUDA runtime + module helpers (duplicated from m_dace_kernels to keep
  ! this generated module self-contained)
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
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function
    function cudaDeviceSynchronize_() bind(C, name='cudaDeviceSynchronize')
      import :: c_int
      integer(c_int) :: cudaDeviceSynchronize_
    end function
  end interface

  integer(c_int), parameter :: cpH2D = 1_c_int
  integer(c_int), parameter :: cpD2H = 2_c_int
#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 2
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF

  interface
    subroutine conv_run(state, &
          & accel_bf, &
          & acoustic_source, &
          & adap_dt, &
          & adap_dt_max_iters, &
          & adap_dt_tol, &
          & adc_kappa, &
          & adv_n, &
          & adv_src_mode, &
          & alf_factor, &
          & alpha_bar, &
          & alt_soundspeed, &
          & any_non_newtonian, &
          & avg_state, &
          & bc_io, &
          & bf_spatial_support, &
          & bf_x, &
          & bf_y, &
          & bf_z, &
          & bodyforces, &
          & bubble_model, &
          & bubbles_euler, &
          & bubbles_lagrange, &
          & bubrs_vc, &
          & buff_size, &
          & bulk_stress, &
          & bx0, &
          & ca, &
          & cfl_adap_dt, &
          & cfl_const_dt, &
          & cfl_dt, &
          & cfl_target, &
          & coefficient_of_restitution, &
          & collision_model, &
          & collision_time, &
          & cont_damage, &
          & cont_damage_s, &
          & cp_g, &
          & cp_v, &
          & cpu_end, &
          & cpu_rate, &
          & cpu_start, &
          & cvs, &
          & cyl_coord, &
          & dir_flg, &
          & dir_idx, &
          & dir_idx_tau, &
          & down_sample, &
          & dt, &
          & dx, &
          & dx_min, &
          & dy, &
          & dy_min, &
          & dz, &
          & dz_min, &
          & enforce_density_floor_vc, &
          & eu, &
          & fd_coeff_x, &
          & fd_coeff_y, &
          & fd_coeff_z, &
          & fd_number, &
          & fd_order, &
          & fft_wrt, &
          & file_per_process, &
          & finaltime, &
          & fluid_inv_re, &
          & g_x, &
          & g_y, &
          & g_z, &
          & gam, &
          & gam_g, &
          & gam_m, &
          & gam_v, &
          & gammas, &
          & grid_geometry, &
          & gs_vc, &
          & hb_k, &
          & hb_m_arr, &
          & hb_mu_max, &
          & hb_mu_min, &
          & hb_nn, &
          & hb_tau0, &
          & hll_u_interface, &
          & hyper_cleaning, &
          & hyper_cleaning_speed, &
          & hyper_cleaning_tau, &
          & hypo_hll_interface_rhs, &
          & hypo_nc_mode, &
          & hypoelasticity, &
          & ib, &
          & ib_coefficient_of_friction, &
          & ib_neighbor_ranks, &
          & ib_neighborhood_radius, &
          & ib_state_wrt, &
          & ic_beta, &
          & ic_eps, &
          & igr, &
          & igr_iter_solver, &
          & igr_order, &
          & igr_pres_lim, &
          & im_trans_c, &
          & im_trans_t, &
          & int_comp, &
          & is_non_newtonian, &
          & isentrope_b, &
          & isentrope_n, &
          & k_g, &
          & k_gl, &
          & k_v, &
          & k_vl, &
          & k_x, &
          & k_y, &
          & k_z, &
          & lag_drag_model, &
          & lag_gravity_force, &
          & lag_pressure_force, &
          & lag_vel_model, &
          & lagrange_beta_index_vc, &
          & local_ib_patch_ids, &
          & low_mach, &
          & m, &
          & m_g, &
          & m_glb, &
          & m_v, &
          & many_ib_patch_parallelism, &
          & mapped_weno, &
          & mass_g0, &
          & mass_v0, &
          & mhd, &
          & mixture_err, &
          & model_eqns, &
          & moving_lag_bubbles, &
          & mp_weno, &
          & mpi_info_int, &
          & mpi_io_data_lag_bubbles, &
          & mpp_lim, &
          & mu_g, &
          & mu_l, &
          & mu_v, &
          & muscl_eps, &
          & muscl_lim, &
          & muscl_order, &
          & muscl_polyn, &
          & mytime, &
          & n, &
          & n_el_bubs_glb, &
          & n_el_bubs_loc, &
          & n_glb, &
          & n_start, &
          & nb, &
          & neighbor_ranks, &
          & nmomsp, &
          & nmomtot, &
          & null_weights, &
          & num_bc_patches, &
          & num_dims, &
          & num_gbl_ibs, &
          & num_ibs, &
          & num_igr_iters, &
          & num_igr_warm_start_iters, &
          & num_local_ibs, &
          & num_particle_clouds, &
          & num_probes, &
          & num_procs, &
          & num_procs_x, &
          & num_procs_y, &
          & num_procs_z, &
          & num_source, &
          & num_stl_models, &
          & num_turbulent_sources, &
          & num_vels, &
          & nv_uvm_igr_temps_on_gpu, &
          & nv_uvm_out_of_core, &
          & nv_uvm_pref_gpu, &
          & omegan, &
          & p, &
          & p0ref, &
          & p_glb, &
          & p_x, &
          & p_y, &
          & p_z, &
          & palpha_eps, &
          & parallel_io, &
          & pb0, &
          & pe_c, &
          & pe_t, &
          & periodic_bc, &
          & phi_gv, &
          & phi_vg, &
          & pi_fac, &
          & pi_infs, &
          & poly_sigma, &
          & polydisperse, &
          & polytropic, &
          & precision, &
          & preserve_qbmm_number_vc, &
          & prim_vars_wrt, &
          & probe_wrt, &
          & proc_coords, &
          & proc_rank, &
          & ptgalpha_eps, &
          & ptil, &
          & pv, &
          & qbmm, &
          & qc1, &
          & qc2, &
          & qc3, &
          & qc4, &
          & qc5, &
          & qc6, &
          & qc7, &
          & qc8, &
          & qp1, &
          & qp2, &
          & qp3, &
          & qp4, &
          & qp5, &
          & qp6, &
          & qp7, &
          & qp8, &
          & qt, &
          & qvps, &
          & qvs, &
          & r0, &
          & r0ref, &
          & r_g, &
          & r_v, &
          & rdma_mpi, &
          & re_idx, &
          & re_inv, &
          & re_size, &
          & re_size_max, &
          & re_trans_c, &
          & re_trans_t, &
          & reactive_burn, &
          & recon_type, &
          & relativity, &
          & relax, &
          & relax_model, &
          & res_vc, &
          & rho0ref, &
          & riemann_hypo_adc, &
          & riemann_solver, &
          & run_time_info, &
          & shear_bc_flip_indices, &
          & shear_bc_flip_num, &
          & shear_indices, &
          & shear_num, &
          & shear_stress, &
          & sigma, &
          & sigr, &
          & spbf_source_x, &
          & spbf_source_y, &
          & ss, &
          & start_idx, &
          & stress_perm, &
          & surface_tension, &
          & synth_amp_shell, &
          & synth_k_shell, &
          & synth_l, &
          & synth_n_shells, &
          & synth_n_waves_per_shell, &
          & synth_seed, &
          & synth_u_inf, &
          & synthetic_turbulence, &
          & sys_size, &
          & t0ref, &
          & t_save, &
          & t_step_old, &
          & t_step_print, &
          & t_step_save, &
          & t_step_start, &
          & t_step_stop, &
          & t_stop, &
          & tau_star, &
          & teno, &
          & teno_ct, &
          & thermal, &
          & time_stepper, &
          & turb_pos, &
          & tw, &
          & use_nc_iface_vel, &
          & vd, &
          & viscous, &
          & w_x, &
          & w_y, &
          & w_z, &
          & wa_flg, &
          & wall_time, &
          & wall_time_avg, &
          & wave_speeds, &
          & web, &
          & weight, &
          & weno_avg, &
          & weno_eps, &
          & weno_num_stencils, &
          & weno_order, &
          & weno_polyn, &
          & weno_re_flux, &
          & wenojs, &
          & wenoz, &
          & wenoz_q, &
          & x_cb, &
          & x_cc, &
          & y_cb, &
          & y_cc, &
          & z_cb, &
          & z_cc, &
          & e_e_in, &
          & fd_coeff_x_d0, &
          & fd_coeff_y_d0, &
          & fd_coeff_z_d0, &
          & ib_neighbor_ranks_d0, &
          & ib_neighbor_ranks_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & mpi_io_data_lag_bubbles_d0, &
          & neighbor_ranks_d0, &
          & neighbor_ranks_d1, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & pres_mag, &
          & ptil_d0, &
          & ptil_d1, &
          & qc1_d0, &
          & qc1_d1, &
          & qc2_d0, &
          & qc2_d1, &
          & qc3_d0, &
          & qc3_d1, &
          & qc4_d0, &
          & qc4_d1, &
          & qc5_d0, &
          & qc5_d1, &
          & qc6_d0, &
          & qc6_d1, &
          & qc7_d0, &
          & qc7_d1, &
          & qc8_d0, &
          & qc8_d1, &
          & qp1_d0, &
          & qp1_d1, &
          & qp2_d0, &
          & qp2_d1, &
          & qp3_d0, &
          & qp3_d1, &
          & qp4_d0, &
          & qp4_d1, &
          & qp5_d0, &
          & qp5_d1, &
          & qp6_d0, &
          & qp6_d1, &
          & qp7_d0, &
          & qp7_d1, &
          & qp8_d0, &
          & qp8_d1, &
          & qt_d0, &
          & qt_d1, &
          & re_idx_d0, &
          & res_vc_d0, &
          & spbf_source_x_d0, &
          & spbf_source_x_d1, &
          & spbf_source_y_d0, &
          & spbf_source_y_d1) &
        bind(C, name='__program_mfc_dace_conv')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr), value :: state
      type(c_ptr), value :: accel_bf
      type(c_ptr), value :: acoustic_source
      type(c_ptr), value :: adap_dt
      type(c_ptr), value :: adap_dt_max_iters
      type(c_ptr), value :: adap_dt_tol
      type(c_ptr), value :: adc_kappa
      type(c_ptr), value :: adv_n
      type(c_ptr), value :: adv_src_mode
      type(c_ptr), value :: alf_factor
      type(c_ptr), value :: alpha_bar
      type(c_ptr), value :: alt_soundspeed
      type(c_ptr), value :: any_non_newtonian
      type(c_ptr), value :: avg_state
      type(c_ptr), value :: bc_io
      type(c_ptr), value :: bf_spatial_support
      type(c_ptr), value :: bf_x
      type(c_ptr), value :: bf_y
      type(c_ptr), value :: bf_z
      type(c_ptr), value :: bodyforces
      type(c_ptr), value :: bubble_model
      type(c_ptr), value :: bubbles_euler
      type(c_ptr), value :: bubbles_lagrange
      type(c_ptr), value :: bubrs_vc
      type(c_ptr), value :: buff_size
      type(c_ptr), value :: bulk_stress
      type(c_ptr), value :: bx0
      type(c_ptr), value :: ca
      type(c_ptr), value :: cfl_adap_dt
      type(c_ptr), value :: cfl_const_dt
      type(c_ptr), value :: cfl_dt
      type(c_ptr), value :: cfl_target
      type(c_ptr), value :: coefficient_of_restitution
      type(c_ptr), value :: collision_model
      type(c_ptr), value :: collision_time
      type(c_ptr), value :: cont_damage
      type(c_ptr), value :: cont_damage_s
      type(c_ptr), value :: cp_g
      type(c_ptr), value :: cp_v
      type(c_ptr), value :: cpu_end
      type(c_ptr), value :: cpu_rate
      type(c_ptr), value :: cpu_start
      type(c_ptr), value :: cvs
      type(c_ptr), value :: cyl_coord
      type(c_ptr), value :: dir_flg
      type(c_ptr), value :: dir_idx
      type(c_ptr), value :: dir_idx_tau
      type(c_ptr), value :: down_sample
      type(c_ptr), value :: dt
      type(c_ptr), value :: dx
      type(c_ptr), value :: dx_min
      type(c_ptr), value :: dy
      type(c_ptr), value :: dy_min
      type(c_ptr), value :: dz
      type(c_ptr), value :: dz_min
      type(c_ptr), value :: enforce_density_floor_vc
      type(c_ptr), value :: eu
      type(c_ptr), value :: fd_coeff_x
      type(c_ptr), value :: fd_coeff_y
      type(c_ptr), value :: fd_coeff_z
      type(c_ptr), value :: fd_number
      type(c_ptr), value :: fd_order
      type(c_ptr), value :: fft_wrt
      type(c_ptr), value :: file_per_process
      type(c_ptr), value :: finaltime
      type(c_ptr), value :: fluid_inv_re
      type(c_ptr), value :: g_x
      type(c_ptr), value :: g_y
      type(c_ptr), value :: g_z
      type(c_ptr), value :: gam
      type(c_ptr), value :: gam_g
      type(c_ptr), value :: gam_m
      type(c_ptr), value :: gam_v
      type(c_ptr), value :: gammas
      type(c_ptr), value :: grid_geometry
      type(c_ptr), value :: gs_vc
      type(c_ptr), value :: hb_k
      type(c_ptr), value :: hb_m_arr
      type(c_ptr), value :: hb_mu_max
      type(c_ptr), value :: hb_mu_min
      type(c_ptr), value :: hb_nn
      type(c_ptr), value :: hb_tau0
      type(c_ptr), value :: hll_u_interface
      type(c_ptr), value :: hyper_cleaning
      type(c_ptr), value :: hyper_cleaning_speed
      type(c_ptr), value :: hyper_cleaning_tau
      type(c_ptr), value :: hypo_hll_interface_rhs
      type(c_ptr), value :: hypo_nc_mode
      type(c_ptr), value :: hypoelasticity
      type(c_ptr), value :: ib
      type(c_ptr), value :: ib_coefficient_of_friction
      type(c_ptr), value :: ib_neighbor_ranks
      type(c_ptr), value :: ib_neighborhood_radius
      type(c_ptr), value :: ib_state_wrt
      type(c_ptr), value :: ic_beta
      type(c_ptr), value :: ic_eps
      type(c_ptr), value :: igr
      type(c_ptr), value :: igr_iter_solver
      type(c_ptr), value :: igr_order
      type(c_ptr), value :: igr_pres_lim
      type(c_ptr), value :: im_trans_c
      type(c_ptr), value :: im_trans_t
      type(c_ptr), value :: int_comp
      type(c_ptr), value :: is_non_newtonian
      type(c_ptr), value :: isentrope_b
      type(c_ptr), value :: isentrope_n
      type(c_ptr), value :: k_g
      type(c_ptr), value :: k_gl
      type(c_ptr), value :: k_v
      type(c_ptr), value :: k_vl
      type(c_ptr), value :: k_x
      type(c_ptr), value :: k_y
      type(c_ptr), value :: k_z
      type(c_ptr), value :: lag_drag_model
      type(c_ptr), value :: lag_gravity_force
      type(c_ptr), value :: lag_pressure_force
      type(c_ptr), value :: lag_vel_model
      type(c_ptr), value :: lagrange_beta_index_vc
      type(c_ptr), value :: local_ib_patch_ids
      type(c_ptr), value :: low_mach
      type(c_ptr), value :: m
      type(c_ptr), value :: m_g
      type(c_ptr), value :: m_glb
      type(c_ptr), value :: m_v
      type(c_ptr), value :: many_ib_patch_parallelism
      type(c_ptr), value :: mapped_weno
      type(c_ptr), value :: mass_g0
      type(c_ptr), value :: mass_v0
      type(c_ptr), value :: mhd
      type(c_ptr), value :: mixture_err
      type(c_ptr), value :: model_eqns
      type(c_ptr), value :: moving_lag_bubbles
      type(c_ptr), value :: mp_weno
      type(c_ptr), value :: mpi_info_int
      type(c_ptr), value :: mpi_io_data_lag_bubbles
      type(c_ptr), value :: mpp_lim
      type(c_ptr), value :: mu_g
      type(c_ptr), value :: mu_l
      type(c_ptr), value :: mu_v
      type(c_ptr), value :: muscl_eps
      type(c_ptr), value :: muscl_lim
      type(c_ptr), value :: muscl_order
      type(c_ptr), value :: muscl_polyn
      type(c_ptr), value :: mytime
      type(c_ptr), value :: n
      type(c_ptr), value :: n_el_bubs_glb
      type(c_ptr), value :: n_el_bubs_loc
      type(c_ptr), value :: n_glb
      type(c_ptr), value :: n_start
      type(c_ptr), value :: nb
      type(c_ptr), value :: neighbor_ranks
      type(c_ptr), value :: nmomsp
      type(c_ptr), value :: nmomtot
      type(c_ptr), value :: null_weights
      type(c_ptr), value :: num_bc_patches
      type(c_ptr), value :: num_dims
      type(c_ptr), value :: num_gbl_ibs
      type(c_ptr), value :: num_ibs
      type(c_ptr), value :: num_igr_iters
      type(c_ptr), value :: num_igr_warm_start_iters
      type(c_ptr), value :: num_local_ibs
      type(c_ptr), value :: num_particle_clouds
      type(c_ptr), value :: num_probes
      type(c_ptr), value :: num_procs
      type(c_ptr), value :: num_procs_x
      type(c_ptr), value :: num_procs_y
      type(c_ptr), value :: num_procs_z
      type(c_ptr), value :: num_source
      type(c_ptr), value :: num_stl_models
      type(c_ptr), value :: num_turbulent_sources
      type(c_ptr), value :: num_vels
      type(c_ptr), value :: nv_uvm_igr_temps_on_gpu
      type(c_ptr), value :: nv_uvm_out_of_core
      type(c_ptr), value :: nv_uvm_pref_gpu
      type(c_ptr), value :: omegan
      type(c_ptr), value :: p
      type(c_ptr), value :: p0ref
      type(c_ptr), value :: p_glb
      type(c_ptr), value :: p_x
      type(c_ptr), value :: p_y
      type(c_ptr), value :: p_z
      type(c_ptr), value :: palpha_eps
      type(c_ptr), value :: parallel_io
      type(c_ptr), value :: pb0
      type(c_ptr), value :: pe_c
      type(c_ptr), value :: pe_t
      type(c_ptr), value :: periodic_bc
      type(c_ptr), value :: phi_gv
      type(c_ptr), value :: phi_vg
      type(c_ptr), value :: pi_fac
      type(c_ptr), value :: pi_infs
      type(c_ptr), value :: poly_sigma
      type(c_ptr), value :: polydisperse
      type(c_ptr), value :: polytropic
      type(c_ptr), value :: precision
      type(c_ptr), value :: preserve_qbmm_number_vc
      type(c_ptr), value :: prim_vars_wrt
      type(c_ptr), value :: probe_wrt
      type(c_ptr), value :: proc_coords
      type(c_ptr), value :: proc_rank
      type(c_ptr), value :: ptgalpha_eps
      type(c_ptr), value :: ptil
      type(c_ptr), value :: pv
      type(c_ptr), value :: qbmm
      type(c_ptr), value :: qc1
      type(c_ptr), value :: qc2
      type(c_ptr), value :: qc3
      type(c_ptr), value :: qc4
      type(c_ptr), value :: qc5
      type(c_ptr), value :: qc6
      type(c_ptr), value :: qc7
      type(c_ptr), value :: qc8
      type(c_ptr), value :: qp1
      type(c_ptr), value :: qp2
      type(c_ptr), value :: qp3
      type(c_ptr), value :: qp4
      type(c_ptr), value :: qp5
      type(c_ptr), value :: qp6
      type(c_ptr), value :: qp7
      type(c_ptr), value :: qp8
      type(c_ptr), value :: qt
      type(c_ptr), value :: qvps
      type(c_ptr), value :: qvs
      type(c_ptr), value :: r0
      type(c_ptr), value :: r0ref
      type(c_ptr), value :: r_g
      type(c_ptr), value :: r_v
      type(c_ptr), value :: rdma_mpi
      type(c_ptr), value :: re_idx
      type(c_ptr), value :: re_inv
      type(c_ptr), value :: re_size
      type(c_ptr), value :: re_size_max
      type(c_ptr), value :: re_trans_c
      type(c_ptr), value :: re_trans_t
      type(c_ptr), value :: reactive_burn
      type(c_ptr), value :: recon_type
      type(c_ptr), value :: relativity
      type(c_ptr), value :: relax
      type(c_ptr), value :: relax_model
      type(c_ptr), value :: res_vc
      type(c_ptr), value :: rho0ref
      type(c_ptr), value :: riemann_hypo_adc
      type(c_ptr), value :: riemann_solver
      type(c_ptr), value :: run_time_info
      type(c_ptr), value :: shear_bc_flip_indices
      type(c_ptr), value :: shear_bc_flip_num
      type(c_ptr), value :: shear_indices
      type(c_ptr), value :: shear_num
      type(c_ptr), value :: shear_stress
      type(c_ptr), value :: sigma
      type(c_ptr), value :: sigr
      type(c_ptr), value :: spbf_source_x
      type(c_ptr), value :: spbf_source_y
      type(c_ptr), value :: ss
      type(c_ptr), value :: start_idx
      type(c_ptr), value :: stress_perm
      type(c_ptr), value :: surface_tension
      type(c_ptr), value :: synth_amp_shell
      type(c_ptr), value :: synth_k_shell
      type(c_ptr), value :: synth_l
      type(c_ptr), value :: synth_n_shells
      type(c_ptr), value :: synth_n_waves_per_shell
      type(c_ptr), value :: synth_seed
      type(c_ptr), value :: synth_u_inf
      type(c_ptr), value :: synthetic_turbulence
      type(c_ptr), value :: sys_size
      type(c_ptr), value :: t0ref
      type(c_ptr), value :: t_save
      type(c_ptr), value :: t_step_old
      type(c_ptr), value :: t_step_print
      type(c_ptr), value :: t_step_save
      type(c_ptr), value :: t_step_start
      type(c_ptr), value :: t_step_stop
      type(c_ptr), value :: t_stop
      type(c_ptr), value :: tau_star
      type(c_ptr), value :: teno
      type(c_ptr), value :: teno_ct
      type(c_ptr), value :: thermal
      type(c_ptr), value :: time_stepper
      type(c_ptr), value :: turb_pos
      type(c_ptr), value :: tw
      type(c_ptr), value :: use_nc_iface_vel
      type(c_ptr), value :: vd
      type(c_ptr), value :: viscous
      type(c_ptr), value :: w_x
      type(c_ptr), value :: w_y
      type(c_ptr), value :: w_z
      type(c_ptr), value :: wa_flg
      type(c_ptr), value :: wall_time
      type(c_ptr), value :: wall_time_avg
      type(c_ptr), value :: wave_speeds
      type(c_ptr), value :: web
      type(c_ptr), value :: weight
      type(c_ptr), value :: weno_avg
      type(c_ptr), value :: weno_eps
      type(c_ptr), value :: weno_num_stencils
      type(c_ptr), value :: weno_order
      type(c_ptr), value :: weno_polyn
      type(c_ptr), value :: weno_re_flux
      type(c_ptr), value :: wenojs
      type(c_ptr), value :: wenoz
      type(c_ptr), value :: wenoz_q
      type(c_ptr), value :: x_cb
      type(c_ptr), value :: x_cc
      type(c_ptr), value :: y_cb
      type(c_ptr), value :: y_cc
      type(c_ptr), value :: z_cb
      type(c_ptr), value :: z_cc
      real(c_double), value :: e_e_in
      integer(c_int64_t), value :: fd_coeff_x_d0
      integer(c_int64_t), value :: fd_coeff_y_d0
      integer(c_int64_t), value :: fd_coeff_z_d0
      integer(c_int64_t), value :: ib_neighbor_ranks_d0
      integer(c_int64_t), value :: ib_neighbor_ranks_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: mpi_io_data_lag_bubbles_d0
      integer(c_int64_t), value :: neighbor_ranks_d0
      integer(c_int64_t), value :: neighbor_ranks_d1
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      real(c_double), value :: pres_mag
      integer(c_int64_t), value :: ptil_d0
      integer(c_int64_t), value :: ptil_d1
      integer(c_int64_t), value :: qc1_d0
      integer(c_int64_t), value :: qc1_d1
      integer(c_int64_t), value :: qc2_d0
      integer(c_int64_t), value :: qc2_d1
      integer(c_int64_t), value :: qc3_d0
      integer(c_int64_t), value :: qc3_d1
      integer(c_int64_t), value :: qc4_d0
      integer(c_int64_t), value :: qc4_d1
      integer(c_int64_t), value :: qc5_d0
      integer(c_int64_t), value :: qc5_d1
      integer(c_int64_t), value :: qc6_d0
      integer(c_int64_t), value :: qc6_d1
      integer(c_int64_t), value :: qc7_d0
      integer(c_int64_t), value :: qc7_d1
      integer(c_int64_t), value :: qc8_d0
      integer(c_int64_t), value :: qc8_d1
      integer(c_int64_t), value :: qp1_d0
      integer(c_int64_t), value :: qp1_d1
      integer(c_int64_t), value :: qp2_d0
      integer(c_int64_t), value :: qp2_d1
      integer(c_int64_t), value :: qp3_d0
      integer(c_int64_t), value :: qp3_d1
      integer(c_int64_t), value :: qp4_d0
      integer(c_int64_t), value :: qp4_d1
      integer(c_int64_t), value :: qp5_d0
      integer(c_int64_t), value :: qp5_d1
      integer(c_int64_t), value :: qp6_d0
      integer(c_int64_t), value :: qp6_d1
      integer(c_int64_t), value :: qp7_d0
      integer(c_int64_t), value :: qp7_d1
      integer(c_int64_t), value :: qp8_d0
      integer(c_int64_t), value :: qp8_d1
      integer(c_int64_t), value :: qt_d0
      integer(c_int64_t), value :: qt_d1
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_vc_d0
      integer(c_int64_t), value :: spbf_source_x_d0
      integer(c_int64_t), value :: spbf_source_x_d1
      integer(c_int64_t), value :: spbf_source_y_d0
      integer(c_int64_t), value :: spbf_source_y_d1
    end subroutine

    function conv_init(&
          & e_e_in, &
          & fd_coeff_x_d0, &
          & fd_coeff_y_d0, &
          & fd_coeff_z_d0, &
          & ib_neighbor_ranks_d0, &
          & ib_neighbor_ranks_d1, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & mpi_io_data_lag_bubbles_d0, &
          & neighbor_ranks_d0, &
          & neighbor_ranks_d1, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & pres_mag, &
          & ptil_d0, &
          & ptil_d1, &
          & qc1_d0, &
          & qc1_d1, &
          & qc2_d0, &
          & qc2_d1, &
          & qc3_d0, &
          & qc3_d1, &
          & qc4_d0, &
          & qc4_d1, &
          & qc5_d0, &
          & qc5_d1, &
          & qc6_d0, &
          & qc6_d1, &
          & qc7_d0, &
          & qc7_d1, &
          & qc8_d0, &
          & qc8_d1, &
          & qp1_d0, &
          & qp1_d1, &
          & qp2_d0, &
          & qp2_d1, &
          & qp3_d0, &
          & qp3_d1, &
          & qp4_d0, &
          & qp4_d1, &
          & qp5_d0, &
          & qp5_d1, &
          & qp6_d0, &
          & qp6_d1, &
          & qp7_d0, &
          & qp7_d1, &
          & qp8_d0, &
          & qp8_d1, &
          & qt_d0, &
          & qt_d1, &
          & re_idx_d0, &
          & res_vc_d0, &
          & spbf_source_x_d0, &
          & spbf_source_x_d1, &
          & spbf_source_y_d0, &
          & spbf_source_y_d1) &
        bind(C, name='__dace_init_mfc_dace_conv')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: conv_init
      real(c_double), value :: e_e_in
      integer(c_int64_t), value :: fd_coeff_x_d0
      integer(c_int64_t), value :: fd_coeff_y_d0
      integer(c_int64_t), value :: fd_coeff_z_d0
      integer(c_int64_t), value :: ib_neighbor_ranks_d0
      integer(c_int64_t), value :: ib_neighbor_ranks_d1
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: mpi_io_data_lag_bubbles_d0
      integer(c_int64_t), value :: neighbor_ranks_d0
      integer(c_int64_t), value :: neighbor_ranks_d1
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      real(c_double), value :: pres_mag
      integer(c_int64_t), value :: ptil_d0
      integer(c_int64_t), value :: ptil_d1
      integer(c_int64_t), value :: qc1_d0
      integer(c_int64_t), value :: qc1_d1
      integer(c_int64_t), value :: qc2_d0
      integer(c_int64_t), value :: qc2_d1
      integer(c_int64_t), value :: qc3_d0
      integer(c_int64_t), value :: qc3_d1
      integer(c_int64_t), value :: qc4_d0
      integer(c_int64_t), value :: qc4_d1
      integer(c_int64_t), value :: qc5_d0
      integer(c_int64_t), value :: qc5_d1
      integer(c_int64_t), value :: qc6_d0
      integer(c_int64_t), value :: qc6_d1
      integer(c_int64_t), value :: qc7_d0
      integer(c_int64_t), value :: qc7_d1
      integer(c_int64_t), value :: qc8_d0
      integer(c_int64_t), value :: qc8_d1
      integer(c_int64_t), value :: qp1_d0
      integer(c_int64_t), value :: qp1_d1
      integer(c_int64_t), value :: qp2_d0
      integer(c_int64_t), value :: qp2_d1
      integer(c_int64_t), value :: qp3_d0
      integer(c_int64_t), value :: qp3_d1
      integer(c_int64_t), value :: qp4_d0
      integer(c_int64_t), value :: qp4_d1
      integer(c_int64_t), value :: qp5_d0
      integer(c_int64_t), value :: qp5_d1
      integer(c_int64_t), value :: qp6_d0
      integer(c_int64_t), value :: qp6_d1
      integer(c_int64_t), value :: qp7_d0
      integer(c_int64_t), value :: qp7_d1
      integer(c_int64_t), value :: qp8_d0
      integer(c_int64_t), value :: qp8_d1
      integer(c_int64_t), value :: qt_d0
      integer(c_int64_t), value :: qt_d1
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_vc_d0
      integer(c_int64_t), value :: spbf_source_x_d0
      integer(c_int64_t), value :: spbf_source_x_d1
      integer(c_int64_t), value :: spbf_source_y_d0
      integer(c_int64_t), value :: spbf_source_y_d1
    end function

    function conv_exit(state) bind(C, name='__dace_exit_mfc_dace_conv')
      import :: c_ptr, c_int
      integer(c_int) :: conv_exit
      type(c_ptr), value :: state
    end function
  end interface

contains

  subroutine chk(ierr, what)
    integer(c_int), intent(in) :: ierr
    character(*), intent(in) :: what
    if (ierr /= 0_c_int) then
      print *, 'm_dace_kernels_conv: CUDA error in ', what, ': code=', ierr
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

  !> P2/T2.3 generated: conversion-kernel dispatch (libmfc_dace_conv.so).
  !! Signature manifest: pipeline/mfc_dace/mfc_dace_conv.args.  283 dead
  !! module-config arrays (validated zero-filled on the live 5-eq path) share
  !! one device zeros buffer; gammas/pi_infs/qvs carry real values; the
  !! fields pack/unpack like the fdiff shim.  Generated by
  !! scripts/mfc_dace_conv_shim_gen.py — regenerate on a kernel rebake.
  subroutine s_dace_convert(qK_cons_vf, q_T_sf, qK_prim_vf, ibounds)
    type(scalar_field), dimension(:), intent(in) :: qK_cons_vf
    type(scalar_field), intent(inout) :: q_T_sf
    type(scalar_field), dimension(:), intent(inout) :: qK_prim_vf
    type(int_bounds_info), dimension(1:3), intent(in) :: ibounds

    real(c_double), allocatable, target :: gbuf(:), pbuf(:), vbuf(:)
    type(c_ptr) :: qptr(8), pptr(8)
    real(wp), pointer :: fp(:,:,:)
    integer :: ext, i
    integer(c_int64_t) :: e64
    integer(c_size_t) :: bytes_f, bytes_t
    integer(c_int) :: ierr
    integer(c_int64_t) :: jd(6)
    real(c_double), allocatable, target, save :: zbuf(:)
    integer, save :: zbuf_rank = 0
    type(c_ptr), save :: d_zeros = c_null_ptr
    type(c_ptr), save :: d_gammas = c_null_ptr, d_pi_infs = c_null_ptr
    type(c_ptr), save :: d_qvs = c_null_ptr
    type(c_ptr), save :: state_conv = c_null_ptr
    integer, save :: state_ext = -1, state_nvars = -1

    ! P2/T2.4 DIRECT MFC-LAYOUT DISPATCH: the eqn dim is unrolled in the
    ! kernel (17 plain (0:,0:,0:) args), so the shim passes raw device
    ! pointers to the field bases — no staging buffers, no transposes.
    ext = size(qK_cons_vf(1)%sf, 1)
    if (buff_size /= BAKED_BUFF_SIZE) then
      print *, 'm_dace_kernels: conv kernel baked with buff_size=', &
               BAKED_BUFF_SIZE, ' but case uses', buff_size
      error stop 1
    end if

    ! live physics arrays
    if (.not. allocated(gbuf) .or. size(gbuf) < num_fluids) then
      if (allocated(gbuf)) deallocate (gbuf, pbuf, vbuf)
      allocate(gbuf(num_fluids), pbuf(num_fluids), vbuf(max(num_fluids, 2)))
      gbuf = real(gammas(1:num_fluids), c_double)
      pbuf = real(pi_infs(1:num_fluids), c_double)
      vbuf = 0.0_c_double
      if (allocated(qvs)) then
        vbuf(1:min(num_fluids, size(qvs))) = &
            real(qvs(1:min(num_fluids, size(qvs))), c_double)
      end if
      if (c_associated(d_gammas)) then
        ierr = cudaFree_(d_gammas); ierr = cudaFree_(d_pi_infs)
        ierr = cudaFree_(d_qvs)
        d_gammas = c_null_ptr
      end if
    end if

    if (zbuf_rank == 0) then
      ! The kernel's host preamble DEREFERENCES the config arrays on the
      ! CPU before the launch — the dead config arrays must be HOST memory.
      allocate(zbuf(8192)); zbuf = 0.0_c_double
      d_zeros = c_loc(zbuf)
      zbuf_rank = 1
    end if
    if (.not. c_associated(d_gammas)) then
      ierr = cudaMalloc_(d_gammas, int(num_fluids*8, c_size_t))
      call chk(ierr, 'malloc gammas')
      ierr = cudaMemcpy_(d_gammas, c_loc(gbuf), int(num_fluids*8, c_size_t), cpH2D)
      call chk(ierr, 'H2D gammas')
      ierr = cudaMalloc_(d_pi_infs, int(num_fluids*8, c_size_t))
      call chk(ierr, 'malloc pi_infs')
      ierr = cudaMemcpy_(d_pi_infs, c_loc(pbuf), int(num_fluids*8, c_size_t), cpH2D)
      call chk(ierr, 'H2D pi_infs')
      ierr = cudaMalloc_(d_qvs, int(max(num_fluids, 2)*8, c_size_t))
      call chk(ierr, 'malloc qvs')
      ierr = cudaMemcpy_(d_qvs, c_loc(vbuf), int(max(num_fluids, 2)*8, c_size_t), cpH2D)
      call chk(ierr, 'H2D qvs')
    end if

    ! DACE->DACE CROSS-LIB SYNC: the rk lib writes q_cons on its own
    ! stream; this lib's kernel reads on another.  Race guard (also
    ! protects against an upstream acc producer).
    ierr = cudaDeviceSynchronize_()

    ! the field bases' device addresses (the FULL padded fields; the
    ! kernel loops the raw 0..ext-1 range over them)
    do i = 1, 8
      fp => qK_cons_vf(i)%sf
      qptr(i) = acc_deviceptr_(c_loc(fp(lbound(fp, 1), lbound(fp, 2), lbound(fp, 3))))
      fp => qK_prim_vf(i)%sf
      pptr(i) = acc_deviceptr_(c_loc(fp(lbound(fp, 1), lbound(fp, 2), lbound(fp, 3))))
    end do
    do i = 1, 8
      if (qptr(i) == c_null_ptr .or. pptr(i) == c_null_ptr) then
        print *, 'm_dace_kernels: conv field not device-present'
        error stop 1
      end if
    end do

    ! loop bounds: raw [ibounds(d)%beg, %end] -> 0-based [.. + buff_size]
    jd(1) = int(ibounds(1)%beg + buff_size, c_int64_t)
    jd(2) = int(ibounds(1)%end + buff_size, c_int64_t)
    jd(3) = int(ibounds(2)%beg + buff_size, c_int64_t)
    jd(4) = int(ibounds(2)%end + buff_size, c_int64_t)
    jd(5) = int(ibounds(3)%beg + buff_size, c_int64_t)
    jd(6) = int(ibounds(3)%end + buff_size, c_int64_t)
    e64 = int(ext, c_int64_t)

    if (state_ext /= ext) then
      if (c_associated(state_conv)) then
        ierr = conv_exit(state_conv)
      end if
      state_conv = conv_init( &
      & 0.0_c_double, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & int(jd(1), c_int), int(jd(2), c_int), int(jd(3), c_int), &
      & int(jd(4), c_int), int(jd(5), c_int), int(jd(6), c_int), &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 0.0_c_double, 1_c_int64_t, 1_c_int64_t, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t &
      )
      state_ext = ext
    end if

    call conv_run(state_conv, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_gammas, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_pi_infs, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, qptr(1), &
      & qptr(2), qptr(3), qptr(4), &
      & qptr(5), qptr(6), qptr(7), &
      & qptr(8), pptr(1), pptr(2), &
      & pptr(3), pptr(4), pptr(5), &
      & pptr(6), pptr(7), pptr(8), &
      & d_zeros, d_zeros, d_qvs, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, d_zeros, d_zeros, &
      & d_zeros, 0.0_c_double, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, int(jd(1), c_int), int(jd(2), c_int), &
      & int(jd(3), c_int), int(jd(4), c_int), int(jd(5), c_int), &
      & int(jd(6), c_int), 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 0.0_c_double, 1_c_int64_t, &
      & 1_c_int64_t, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, e64, &
      & e64, e64, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t, 1_c_int64_t, &
      & 1_c_int64_t, 1_c_int64_t &
      )
    ! (lib stream-syncs internally; no unpack — the kernel wrote the
    ! device prim fields directly)
  end subroutine s_dace_convert

end module m_dace_kernels_conv
#endif
