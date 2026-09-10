#if defined(MFC_DACE)
module m_dace_kernels_sweeps
  use, intrinsic :: iso_c_binding, only: c_ptr, c_int, c_int64_t, c_size_t, &
                                         c_double, c_associated, c_loc, &
                                         c_f_pointer, c_null_ptr
  use m_derived_types
  use m_global_parameters
  use m_riemann_state, only: dir_idx, is1, is2, is3, flux_rsx_vf, flux_src_rsx_vf, vel_src_rsx_vf, &
                             res_gs, re_avg_rsx_vf
  use m_global_parameters_common, only: re_idx, re_size
  use openacc, only: acc_wait_all
  implicit none
  private
  public :: s_dace_hllc_x

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
#ifndef MFC_DACE_BAKED_BUFF
#define MFC_DACE_BAKED_BUFF 2
#endif
  integer, parameter :: BAKED_BUFF_SIZE = MFC_DACE_BAKED_BUFF

  interface
    !> NVHPC's OpenACC runtime: map a host address to its device address
    !! (c_null_ptr when the host address has no device copy)
    function acc_deviceptr_(hostptr) bind(C, name='acc_deviceptr')
      import :: c_ptr
      type(c_ptr) :: acc_deviceptr_
      type(c_ptr), value :: hostptr
    end function
    function acc_hostptr_(devptr) bind(C, name='acc_hostptr')
      import :: c_ptr
      type(c_ptr) :: acc_hostptr_
      type(c_ptr), value :: devptr
    end function
  end interface

  interface
    subroutine sweeps_run_x(state, &
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
          & beta_vars, &
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
          & comm_size, &
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
          & flux, &
          & fsrc, &
          & g_x, &
          & g_y, &
          & g_z, &
          & gam, &
          & gam_g, &
          & gam_m, &
          & gam_v, &
          & gamma_sf, &
          & gammas, &
          & grid_geometry, &
          & gs_vc, &
          & halo_size, &
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
          & i_halo_size, &
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
          & is1b, &
          & is1e, &
          & is2b, &
          & is2e, &
          & is3b, &
          & is3e, &
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
          & n_neighbors, &
          & n_start, &
          & nb, &
          & neighbor_list, &
          & neighbor_ranks, &
          & nmomsp, &
          & nmomtot, &
          & null_weights, &
          & num_bc_patches, &
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
          & p_buff_size, &
          & p_glb, &
          & p_recv_counts, &
          & p_send_counts, &
          & p_send_ids, &
          & p_var_size, &
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
          & pi_inf_sf, &
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
          & program_re, &
          & ptgalpha_eps, &
          & ptil, &
          & pv, &
          & qbmm, &
          & ql, &
          & qr, &
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
          & recv_offsets, &
          & recv_requests, &
          & relativity, &
          & relax, &
          & relax_model, &
          & res_gs, &
          & res_vc, &
          & rho0ref, &
          & rho_sf, &
          & riemann_hypo_adc, &
          & riemann_solver, &
          & run_time_info, &
          & send_requests, &
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
          & vsrc, &
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
          & flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & rsz1, &
          & rsz2, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__program_mfc_dace_sweeps_x')
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
      type(c_ptr), value :: beta_vars
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
      type(c_ptr), value :: comm_size
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
      type(c_ptr), value :: flux
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: g_x
      type(c_ptr), value :: g_y
      type(c_ptr), value :: g_z
      type(c_ptr), value :: gam
      type(c_ptr), value :: gam_g
      type(c_ptr), value :: gam_m
      type(c_ptr), value :: gam_v
      type(c_ptr), value :: gamma_sf
      type(c_ptr), value :: gammas
      type(c_ptr), value :: grid_geometry
      type(c_ptr), value :: gs_vc
      type(c_ptr), value :: halo_size
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
      type(c_ptr), value :: i_halo_size
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
      type(c_ptr), value :: is1b
      type(c_ptr), value :: is1e
      type(c_ptr), value :: is2b
      type(c_ptr), value :: is2e
      type(c_ptr), value :: is3b
      type(c_ptr), value :: is3e
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
      type(c_ptr), value :: n_neighbors
      type(c_ptr), value :: n_start
      type(c_ptr), value :: nb
      type(c_ptr), value :: neighbor_list
      type(c_ptr), value :: neighbor_ranks
      type(c_ptr), value :: nmomsp
      type(c_ptr), value :: nmomtot
      type(c_ptr), value :: null_weights
      type(c_ptr), value :: num_bc_patches
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
      type(c_ptr), value :: p_buff_size
      type(c_ptr), value :: p_glb
      type(c_ptr), value :: p_recv_counts
      type(c_ptr), value :: p_send_counts
      type(c_ptr), value :: p_send_ids
      type(c_ptr), value :: p_var_size
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
      type(c_ptr), value :: pi_inf_sf
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
      type(c_ptr), value :: program_re
      type(c_ptr), value :: ptgalpha_eps
      type(c_ptr), value :: ptil
      type(c_ptr), value :: pv
      type(c_ptr), value :: qbmm
      type(c_ptr), value :: ql
      type(c_ptr), value :: qr
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
      type(c_ptr), value :: recv_offsets
      type(c_ptr), value :: recv_requests
      type(c_ptr), value :: relativity
      type(c_ptr), value :: relax
      type(c_ptr), value :: relax_model
      type(c_ptr), value :: res_gs
      type(c_ptr), value :: res_vc
      type(c_ptr), value :: rho0ref
      type(c_ptr), value :: rho_sf
      type(c_ptr), value :: riemann_hypo_adc
      type(c_ptr), value :: riemann_solver
      type(c_ptr), value :: run_time_info
      type(c_ptr), value :: send_requests
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
      type(c_ptr), value :: vsrc
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
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end subroutine

    function sweeps_init_x(flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__dace_init_mfc_dace_sweeps_x')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: sweeps_init_x
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end function

    function sweeps_exit_x(state) bind(C, name='__dace_exit_mfc_dace_sweeps_x')
      import :: c_ptr, c_int
      integer(c_int) :: sweeps_exit_x
      type(c_ptr), value :: state
    end function
  end interface
  interface
    subroutine sweeps_run_y(state, &
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
          & beta_vars, &
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
          & comm_size, &
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
          & flux, &
          & fsrc, &
          & g_x, &
          & g_y, &
          & g_z, &
          & gam, &
          & gam_g, &
          & gam_m, &
          & gam_v, &
          & gamma_sf, &
          & gammas, &
          & grid_geometry, &
          & gs_vc, &
          & halo_size, &
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
          & i_halo_size, &
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
          & is1b, &
          & is1e, &
          & is2b, &
          & is2e, &
          & is3b, &
          & is3e, &
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
          & n_neighbors, &
          & n_start, &
          & nb, &
          & neighbor_list, &
          & neighbor_ranks, &
          & nmomsp, &
          & nmomtot, &
          & null_weights, &
          & num_bc_patches, &
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
          & p_buff_size, &
          & p_glb, &
          & p_recv_counts, &
          & p_send_counts, &
          & p_send_ids, &
          & p_var_size, &
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
          & pi_inf_sf, &
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
          & program_re, &
          & ptgalpha_eps, &
          & ptil, &
          & pv, &
          & qbmm, &
          & ql, &
          & qr, &
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
          & recv_offsets, &
          & recv_requests, &
          & relativity, &
          & relax, &
          & relax_model, &
          & res_gs, &
          & res_vc, &
          & rho0ref, &
          & rho_sf, &
          & riemann_hypo_adc, &
          & riemann_solver, &
          & run_time_info, &
          & send_requests, &
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
          & vsrc, &
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
          & flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & rsz1, &
          & rsz2, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__program_mfc_dace_sweeps_y')
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
      type(c_ptr), value :: beta_vars
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
      type(c_ptr), value :: comm_size
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
      type(c_ptr), value :: flux
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: g_x
      type(c_ptr), value :: g_y
      type(c_ptr), value :: g_z
      type(c_ptr), value :: gam
      type(c_ptr), value :: gam_g
      type(c_ptr), value :: gam_m
      type(c_ptr), value :: gam_v
      type(c_ptr), value :: gamma_sf
      type(c_ptr), value :: gammas
      type(c_ptr), value :: grid_geometry
      type(c_ptr), value :: gs_vc
      type(c_ptr), value :: halo_size
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
      type(c_ptr), value :: i_halo_size
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
      type(c_ptr), value :: is1b
      type(c_ptr), value :: is1e
      type(c_ptr), value :: is2b
      type(c_ptr), value :: is2e
      type(c_ptr), value :: is3b
      type(c_ptr), value :: is3e
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
      type(c_ptr), value :: n_neighbors
      type(c_ptr), value :: n_start
      type(c_ptr), value :: nb
      type(c_ptr), value :: neighbor_list
      type(c_ptr), value :: neighbor_ranks
      type(c_ptr), value :: nmomsp
      type(c_ptr), value :: nmomtot
      type(c_ptr), value :: null_weights
      type(c_ptr), value :: num_bc_patches
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
      type(c_ptr), value :: p_buff_size
      type(c_ptr), value :: p_glb
      type(c_ptr), value :: p_recv_counts
      type(c_ptr), value :: p_send_counts
      type(c_ptr), value :: p_send_ids
      type(c_ptr), value :: p_var_size
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
      type(c_ptr), value :: pi_inf_sf
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
      type(c_ptr), value :: program_re
      type(c_ptr), value :: ptgalpha_eps
      type(c_ptr), value :: ptil
      type(c_ptr), value :: pv
      type(c_ptr), value :: qbmm
      type(c_ptr), value :: ql
      type(c_ptr), value :: qr
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
      type(c_ptr), value :: recv_offsets
      type(c_ptr), value :: recv_requests
      type(c_ptr), value :: relativity
      type(c_ptr), value :: relax
      type(c_ptr), value :: relax_model
      type(c_ptr), value :: res_gs
      type(c_ptr), value :: res_vc
      type(c_ptr), value :: rho0ref
      type(c_ptr), value :: rho_sf
      type(c_ptr), value :: riemann_hypo_adc
      type(c_ptr), value :: riemann_solver
      type(c_ptr), value :: run_time_info
      type(c_ptr), value :: send_requests
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
      type(c_ptr), value :: vsrc
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
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end subroutine

    function sweeps_init_y(flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__dace_init_mfc_dace_sweeps_y')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: sweeps_init_y
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end function

    function sweeps_exit_y(state) bind(C, name='__dace_exit_mfc_dace_sweeps_y')
      import :: c_ptr, c_int
      integer(c_int) :: sweeps_exit_y
      type(c_ptr), value :: state
    end function
  end interface
  interface
    subroutine sweeps_run_z(state, &
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
          & beta_vars, &
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
          & comm_size, &
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
          & flux, &
          & fsrc, &
          & g_x, &
          & g_y, &
          & g_z, &
          & gam, &
          & gam_g, &
          & gam_m, &
          & gam_v, &
          & gamma_sf, &
          & gammas, &
          & grid_geometry, &
          & gs_vc, &
          & halo_size, &
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
          & i_halo_size, &
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
          & is1b, &
          & is1e, &
          & is2b, &
          & is2e, &
          & is3b, &
          & is3e, &
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
          & n_neighbors, &
          & n_start, &
          & nb, &
          & neighbor_list, &
          & neighbor_ranks, &
          & nmomsp, &
          & nmomtot, &
          & null_weights, &
          & num_bc_patches, &
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
          & p_buff_size, &
          & p_glb, &
          & p_recv_counts, &
          & p_send_counts, &
          & p_send_ids, &
          & p_var_size, &
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
          & pi_inf_sf, &
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
          & program_re, &
          & ptgalpha_eps, &
          & ptil, &
          & pv, &
          & qbmm, &
          & ql, &
          & qr, &
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
          & recv_offsets, &
          & recv_requests, &
          & relativity, &
          & relax, &
          & relax_model, &
          & res_gs, &
          & res_vc, &
          & rho0ref, &
          & rho_sf, &
          & riemann_hypo_adc, &
          & riemann_solver, &
          & run_time_info, &
          & send_requests, &
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
          & vsrc, &
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
          & flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & rsz1, &
          & rsz2, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__program_mfc_dace_sweeps_z')
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
      type(c_ptr), value :: beta_vars
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
      type(c_ptr), value :: comm_size
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
      type(c_ptr), value :: flux
      type(c_ptr), value :: fsrc
      type(c_ptr), value :: g_x
      type(c_ptr), value :: g_y
      type(c_ptr), value :: g_z
      type(c_ptr), value :: gam
      type(c_ptr), value :: gam_g
      type(c_ptr), value :: gam_m
      type(c_ptr), value :: gam_v
      type(c_ptr), value :: gamma_sf
      type(c_ptr), value :: gammas
      type(c_ptr), value :: grid_geometry
      type(c_ptr), value :: gs_vc
      type(c_ptr), value :: halo_size
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
      type(c_ptr), value :: i_halo_size
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
      type(c_ptr), value :: is1b
      type(c_ptr), value :: is1e
      type(c_ptr), value :: is2b
      type(c_ptr), value :: is2e
      type(c_ptr), value :: is3b
      type(c_ptr), value :: is3e
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
      type(c_ptr), value :: n_neighbors
      type(c_ptr), value :: n_start
      type(c_ptr), value :: nb
      type(c_ptr), value :: neighbor_list
      type(c_ptr), value :: neighbor_ranks
      type(c_ptr), value :: nmomsp
      type(c_ptr), value :: nmomtot
      type(c_ptr), value :: null_weights
      type(c_ptr), value :: num_bc_patches
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
      type(c_ptr), value :: p_buff_size
      type(c_ptr), value :: p_glb
      type(c_ptr), value :: p_recv_counts
      type(c_ptr), value :: p_send_counts
      type(c_ptr), value :: p_send_ids
      type(c_ptr), value :: p_var_size
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
      type(c_ptr), value :: pi_inf_sf
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
      type(c_ptr), value :: program_re
      type(c_ptr), value :: ptgalpha_eps
      type(c_ptr), value :: ptil
      type(c_ptr), value :: pv
      type(c_ptr), value :: qbmm
      type(c_ptr), value :: ql
      type(c_ptr), value :: qr
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
      type(c_ptr), value :: recv_offsets
      type(c_ptr), value :: recv_requests
      type(c_ptr), value :: relativity
      type(c_ptr), value :: relax
      type(c_ptr), value :: relax_model
      type(c_ptr), value :: res_gs
      type(c_ptr), value :: res_vc
      type(c_ptr), value :: rho0ref
      type(c_ptr), value :: rho_sf
      type(c_ptr), value :: riemann_hypo_adc
      type(c_ptr), value :: riemann_solver
      type(c_ptr), value :: run_time_info
      type(c_ptr), value :: send_requests
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
      type(c_ptr), value :: vsrc
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
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end subroutine

    function sweeps_init_z(flux_d0, &
          & flux_d1, &
          & flux_d2, &
          & fsrc_d0, &
          & fsrc_d1, &
          & fsrc_d2, &
          & jb, &
          & je, &
          & kb, &
          & ke, &
          & lb, &
          & le, &
          & offset_gammas_d0, &
          & offset_pi_infs_d0, &
          & offset_qvs_d0, &
          & offset_re_idx_d0, &
          & offset_re_idx_d1, &
          & ql_d0, &
          & ql_d1, &
          & ql_d2, &
          & qr_d0, &
          & qr_d1, &
          & qr_d2, &
          & re_d0, &
          & re_d1, &
          & re_d2, &
          & re_idx_d0, &
          & res_gs_d0, &
          & vsrc_d0, &
          & vsrc_d1, &
          & vsrc_d2) &
        bind(C, name='__dace_init_mfc_dace_sweeps_z')
      import :: c_ptr, c_int, c_int64_t, c_double
      type(c_ptr) :: sweeps_init_z
      integer(c_int64_t), value :: flux_d0
      integer(c_int64_t), value :: flux_d1
      integer(c_int64_t), value :: flux_d2
      integer(c_int64_t), value :: fsrc_d0
      integer(c_int64_t), value :: fsrc_d1
      integer(c_int64_t), value :: fsrc_d2
      integer(c_int), value :: jb
      integer(c_int), value :: je
      integer(c_int), value :: kb
      integer(c_int), value :: ke
      integer(c_int), value :: lb
      integer(c_int), value :: le
      integer(c_int64_t), value :: offset_gammas_d0
      integer(c_int64_t), value :: offset_pi_infs_d0
      integer(c_int64_t), value :: offset_qvs_d0
      integer(c_int64_t), value :: offset_re_idx_d0
      integer(c_int64_t), value :: offset_re_idx_d1
      integer(c_int64_t), value :: ql_d0
      integer(c_int64_t), value :: ql_d1
      integer(c_int64_t), value :: ql_d2
      integer(c_int64_t), value :: qr_d0
      integer(c_int64_t), value :: qr_d1
      integer(c_int64_t), value :: qr_d2
      integer(c_int64_t), value :: re_d0
      integer(c_int64_t), value :: re_d1
      integer(c_int64_t), value :: re_d2
      integer(c_int64_t), value :: re_idx_d0
      integer(c_int64_t), value :: res_gs_d0
      integer(c_int), value :: rsz1
      integer(c_int), value :: rsz2
      integer(c_int64_t), value :: vsrc_d0
      integer(c_int64_t), value :: vsrc_d1
      integer(c_int64_t), value :: vsrc_d2
    end function

    function sweeps_exit_z(state) bind(C, name='__dace_exit_mfc_dace_sweeps_z')
      import :: c_ptr, c_int
      integer(c_int) :: sweeps_exit_z
      type(c_ptr), value :: state
    end function
  end interface

  interface
    function cu_ctx_get_current() bind(C, name='cuCtxGetCurrent')
      use, intrinsic :: iso_c_binding, only: c_ptr
      type(c_ptr) :: cu_ctx_get_current
    end function
    function cu_ctx_set_current(ctx) bind(C, name='cuCtxSetCurrent')
      use, intrinsic :: iso_c_binding, only: c_ptr, c_int
      integer(c_int) :: cu_ctx_set_current
      type(c_ptr), value :: ctx
    end function
  end interface

  !> Unpack geometry shared between the shim routine and the on-device
  !! unpack kernels. Stored in a HEAP allocation (not module statics, not stack locals, not
  !! call arguments): the dace init/run calls and the shim's own large print
  !! statements have each been observed corrupting one or more of those
  !! (is3b/is3e dummies, svs* locals, 8th/9th argument slots), while the
  !! heap has survived every corruption event.  The stash is written once,
  !! immediately after the kernel loop bounds jd are computed, before any
  !! init call, print, or the dace run itself.
  !! Layout: 1-6 = jd (kernel/packed axis bounds, sweep-local);
  !! 7 = rsx lbound; 8-10 = rsx extents; 11 = rsx eqn stride;
  !! 12 = packed extent; 13 = buff_size; 14 = fsrc eqn offset;
  !! 15-17 = nvars_l, nadv_l, nvels_l; 18 = dir.
  integer, parameter :: uperm_gn = 18
  integer, allocatable, target :: uperm_geom(:)

contains

  subroutine chk(ierr, what)
    integer(c_int), intent(in) :: ierr
    character(*), intent(in) :: what
    if (ierr /= 0_c_int) then
      print *, 'm_dace_kernels_sweeps: CUDA error in ', what, ': code=', ierr
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

  !> P2/T2.3 generated: HLLC x-sweep kernel dispatch (libmfc_dace_sweeps.so).
  !! Signature manifest: pipeline/mfc_dace/mfc_dace_sweeps.args.  308 dead
  !! module-config arrays (validated zero-filled on the live 5-eq path) share
  !! one HOST zeros buffer; gammas/pi_infs/qvs carry real values; the fields
  !! pack/unpack with the (j,k,l,eqn) -> (eqn,j,k,l) transpose.  Generated by
  !! scripts/mfc_dace_sweeps_shim_gen.py — regenerate on a kernel rebake.
  !> The rsx arrays cross as RAW DEVICE POINTERS (the caller wraps the call
  !! in !$acc host_data use_device + c_loc): nvfortran's assumed-shape
  !! descriptor handling for plain 4-D dummies inside acc regions misresolved
  !! addresses at >=96³ (compute-sanitizer: reads ~150 KB before the staging
  !! buffer), so the shim does pure flat-pointer arithmetic — no descriptor
  !! semantics at all.  All five arrays are (j, k, l, eqn) column-major with
  !! per-dim extent ext1/ext2/ext3 (eqn extents: nvars_l for qL/qR/flux,
  !! nadv_l for fsrc rows adv%beg.., nvels_l for vsrc).
  subroutine s_dace_hllc_x(qL_rsx, qR_rsx, flux_rsx, fsrc_rsx, vsrc_rsx, &
                           is1b, is1e, is2b, is2e, is3b, is3e, &
                           ext1, ext2, ext3, nvars_l, nadv_l, nvels_l, rsz1, rsz2, &
                           dir_in)
    ! Assumed-shape dummies over the live declare-create'd rsx arrays: the
    ! pack/unpack acc kernels read/write them through the present table
    ! (the fdiff/conv mechanism, rounding-clean in the capture comparison).
    ! The x loops run over a NON-NEGATIVE reindexed range (raw = u + is1b):
    ! a collapse whose x bound starts at the raw -1 trips nvfortran's
    ! low-corner fault at >=64³.
    real(wp), dimension(idwbuff(1)%beg:, idwbuff(2)%beg:, idwbuff(3)%beg:, 1:), &
        & intent(in), target :: qL_rsx, qR_rsx
    real(wp), dimension(-1:, -1:, -1:, 1:), intent(out), target :: flux_rsx
    real(wp), dimension(-1:, -1:, -1:, eqn_idx%adv%beg:), intent(out), target :: fsrc_rsx
    real(wp), dimension(-1:, -1:, -1:, 1:), intent(out), target :: vsrc_rsx
    integer, intent(in) :: is1b, is1e, is2b, is2e, is3b, is3e
    integer, intent(in) :: ext1, ext2, ext3
    integer, intent(in) :: nvars_l, nadv_l, nvels_l
    ! per-row Re_size rows (0 = the inviscid case: no table reads, the RE
    ! writes land in the shim's dummy device buffer)
    integer, intent(in) :: rsz1, rsz2
    ! sweep direction (1/2/3 = x/y/z): only the kernel's loop bounds (jd)
    ! permute — the pack/unpack address the same MFC (dim1,dim2,dim3)
    ! positions numerically on a cubic grid.
    integer, intent(in) :: dir_in

    real(c_double), pointer :: d_ql_f(:), d_qr_f(:)
    character(len=32) :: dbg_env
    integer :: dbg_st
    integer :: j1b, j1e, j2b, j2e, j3b, j3e
    integer :: lbv, n1v, n2v, estv, extv, bufv, eoffv, nrowsv
    real(c_double), pointer :: pk_f(:), rs_f(:)
    type(c_ptr) :: flux_dev, fsrc_dev, vsrc_dev
    integer :: src_base, dst_base, exto1, exto2, exto3
    integer :: s_raw, k_raw, l_raw, u, v, w
    real(c_double), allocatable, target :: gbuf(:), pbuf(:), vbuf(:)
    real(c_double), allocatable, target, save :: zbuf(:)
    integer :: ext, s, e, k, l
    integer(c_size_t) :: bytes_f, bytes_a, bytes_v
    integer(c_int) :: ierr
    integer(c_int64_t) :: e64, nv64, re_e64, jd(6)
    real(c_double), allocatable, target, save :: z0(:)
    integer, save :: zbuf_rank = 0
    type(c_ptr), save :: d_zeros = c_null_ptr
    type(c_ptr) :: re_dev, rgs_dev, ridx_dev
    real(wp), pointer :: fp2(:)
    ! the (2,2) tables cross as cudaMalloc'd DEVICE buffers with explicit
    ! H2D copies: acc_deviceptr_ on stack-local staging returns a non-NULL
    ! HOST address (the T2.4 mechanism), which the kernel dereferenced as
    ! device memory.  The re_idx table crosses as INT32: the bridge
    ! retyped the TU's real table from the flat helper's int() cast, so a
    ! real(wp) staging fed the kernel 1.0's bit pattern as a fluid index.
    type(c_ptr), save :: d_res_tab = c_null_ptr, d_ridx_tab = c_null_ptr
    real(c_double), target :: h_res_tab(4)
    integer(c_int), target :: h_ridx_tab(4)
    type(c_ptr), save :: d_re_stage = c_null_ptr
    integer(c_size_t), save :: cap_re_stage = 0_c_size_t
    real(c_double), allocatable, target :: re_back(:)
    type(c_ptr), save :: d_re_dummy = c_null_ptr, d_tab_dummy = c_null_ptr
    integer(c_size_t), save :: cap_red = 0_c_size_t, cap_tab = 0_c_size_t
    type(c_ptr), save :: d_ql = c_null_ptr, d_qr = c_null_ptr
    type(c_ptr), save :: d_flux = c_null_ptr, d_fsrc = c_null_ptr
    type(c_ptr), save :: d_vsrc = c_null_ptr
    type(c_ptr), save :: d_gammas = c_null_ptr, d_pi_infs = c_null_ptr
    type(c_ptr), save :: d_qvs = c_null_ptr
    integer(c_size_t), save :: cap_f = 0_c_size_t, cap_a = 0_c_size_t
    integer(c_size_t), save :: cap_v = 0_c_size_t, cap_s = 0_c_size_t
    type(c_ptr), save :: state_sweeps(3) = [c_null_ptr, c_null_ptr, c_null_ptr]
    integer, save :: state_ext(3) = [-1, -1, -1]

    ext = ext1
    if (ext2 /= ext .or. ext3 /= ext) then
      print *, 'm_dace_kernels_sweeps: non-cubic rsx extents', ext1, ext2, ext3
      error stop 1
    end if
    if (buff_size /= BAKED_BUFF_SIZE) then
      print *, 'm_dace_kernels_sweeps: kernel baked with buff_size=', &
               BAKED_BUFF_SIZE, ' but case uses', buff_size
      error stop 1
    end if

    ! DACE->ACC BOUNDARY SYNC: the upstream dace dispatches (pack_weno,
    ! fdiff, conv) write the rsx/state on the dace stream; the pack below
    ! reads on the acc stream.  Without this the pack raced them (stage 1
    ! won by timing, stage 2 read stale/zero inputs).
    ierr = cudaDeviceSynchronize_()
    call chk(ierr, 'entry sync')


    ! P2/T2.3 DEVICE-RESIDENT STAGING: the Riemann rsx arrays are
    ! declare-create'd (device-resident in the OpenACC build), so the
    ! (j,k,l,eqn)->(eqn,j,k,l) transposes run ON DEVICE via acc kernels —
    ! no host staging of the field data.  FSRC rows span the full eqn
    ! range (the kernel addresses row adv%beg against d0 = sys_size
    ! strides), so the buffer needs sys_size rows.

    ! live physics arrays (the validated live path reads only these)
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

    bytes_f = int(nvars_l*ext**3*8, c_size_t)
    bytes_a = int(nvars_l*ext**3*8, c_size_t)
    bytes_v = int(nvels_l*ext**3*8, c_size_t)
    call ensure_buf(d_ql, cap_f, bytes_f, 'ql')
    call ensure_buf(d_qr, cap_f, bytes_f, 'qr')
    call ensure_buf(d_flux, cap_f, bytes_f, 'flux')
    call ensure_buf(d_fsrc, cap_a, bytes_a, 'fsrc')
    call ensure_buf(d_vsrc, cap_v, bytes_v, 'vsrc')
    if (zbuf_rank == 0) then
      ! The kernel's host preamble DEREFERENCES the config arrays on the CPU
      ! before the launch — the dead config arrays must be HOST memory.
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

    ! pack the Riemann states ON DEVICE.  The captured kernel addresses its
    ! arrays with 1-based bridge subscripts QL(eqn, j+buff, k+buff, l+buff)
    ! for raw face j, i.e. 0-based position = raw + buff_size - 1 per axis,
    ! eqn-fastest rank-4 of the (eqn, i, j, k) dummy.  The MFC rsx arrays
    ! hold raw r at 0-based r + buff_size, so the pack copies raw r ->
    ! position r + buff_size - 1 for the states the kernel reads: raws
    ! [isXb .. isXe+1] per axis.  The x loop is reindexed to u = raw - is1b
    ! (non-negative) for nvfortran's collapse low-corner fault.
    call c_f_pointer(d_ql, d_ql_f, [nvars_l*ext**3])
    call c_f_pointer(d_qr, d_qr_f, [nvars_l*ext**3])

    ! P2/T2.4 VISCOUS: the interface-Reynolds output (RE, the MFC
    ! (j,k,l,2) i-last layout = the dace ABI directly) and the per-fluid
    ! tables.  The inviscid case: rsz = 0 (the helper skips the table
    ! reads) and the RE writes land in a dummy device buffer.
    call ensure_buf(d_re_dummy, cap_red, int(ext**3*2*8, c_size_t), 're_dummy')
    call ensure_buf(d_tab_dummy, cap_tab, int(4*8, c_size_t), 'tab_dummy')
    ! The kernel writes RE(j0+1, k0+1, l0+1, i): position = raw - jb + 1 =
    ! (raw+1) + 1 for jb=-1, i.e. ONE past the rsx position (raw+1).  The
    ! staging strides must therefore be rsx_ext + 1 and the staging
    ! (rsx_ext+1)^3*2 so the kernel's writes stay in bounds and unbiased;
    ! the copy-back shifts by -1 per axis (the fix for the e2e viscous
    ! NaN: the old truncated linear copy delivered raw-5..27 values,
    ! leaving the corner cells stale-zero -> the vsrc divided by zero).
    re_e64 = merge(int(size(re_avg_rsx_vf, 1) + 1, c_int64_t), e64, &
                   allocated(re_avg_rsx_vf))
    ! re_avg is ALWAYS delivered when allocated: the Cartesian viscous
    ! source reads Re_shear = Re_avg_rsx_vf(...) whenever viscous, even
    ! when Re_size=(0,0) — gating on rsz left it stale for the dace
    ! directions while the OpenACC path wrote it (the e2e catastrophe).
    ! rsz only gates the (2,2) table reads inside the kernel helper.
    if (allocated(re_avg_rsx_vf)) then
      call ensure_buf(d_re_stage, cap_re_stage, &
                      int((size(re_avg_rsx_vf, 1) + 1)**3*2*8, c_size_t), &
                      're_stage')
      re_dev = d_re_stage
      if (.not. c_associated(d_res_tab)) then
        ierr = cudaMalloc_(d_res_tab, 32_c_size_t)
        call chk(ierr, 'malloc res_gs table')
        ierr = cudaMalloc_(d_ridx_tab, 32_c_size_t)
        call chk(ierr, 'malloc re_idx table')
      end if
      h_res_tab = reshape(real(res_gs(1:2, 1:2), c_double), [4])
      ierr = cudaMemcpy_(d_res_tab, c_loc(h_res_tab), 32_c_size_t, cpH2D)
      call chk(ierr, 'H2D res_gs table')
      h_ridx_tab = reshape(int(re_idx(1:2, 1:2), c_int), [4])
      ierr = cudaMemcpy_(d_ridx_tab, c_loc(h_ridx_tab), 32_c_size_t, cpH2D)
      call chk(ierr, 'H2D re_idx table')
      rgs_dev = d_res_tab
      ridx_dev = d_ridx_tab
      if (re_dev == c_null_ptr .or. rgs_dev == c_null_ptr .or. ridx_dev == c_null_ptr) then
        print *, 'm_dace_kernels_sweeps: viscous arrays not device-present'
        error stop 1
      end if
    else
      re_dev = d_re_dummy
      rgs_dev = d_tab_dummy
      ridx_dev = d_tab_dummy
    end if
    ! Pack the FACE RANGE on ALL THREE axes: for y/z sweeps the face
    ! axis lands on a different is-slot, and the x-slot pack left the low
    ! ghost face (raw -1) of that axis unpacked — the kernel then read
    ! uninitialized staging.  is1b-1..is1e+1 covers every direction's
    ! cell+face+qR range on a cubic grid.
    !$acc parallel loop collapse(3) deviceptr(d_ql_f, d_qr_f)
    do l_raw = is1b, is1e + 1
      do k_raw = is1b, is1e + 1
        do u = 0, is1e + 1 - is1b
          s_raw = u + is1b
          dst_base = (s_raw + buff_size - 1) + &
                     & ext*((k_raw + buff_size - 1) + &
                            ext*(l_raw + buff_size - 1))
          src_base = (s_raw + buff_size) + &
                     & ext*((k_raw + buff_size) + ext*(l_raw + buff_size))
          do e = 1, nvars_l
            d_ql_f((e - 1) + nvars_l*dst_base + 1) = &
                qL_rsx(s_raw, k_raw, l_raw, e)
            d_qr_f((e - 1) + nvars_l*dst_base + 1) = &
                qR_rsx(s_raw, k_raw, l_raw, e)
          end do
        end do
      end do
    end do
    !$acc end parallel loop
    call acc_wait_all()

    ! loop bounds: the kernel's (j,k,l) = the MFC dims 1/2/3 by
    ! construction; per sweep the raw face range lands on a different
    ! is-slot: x -> (is1,is2,is3), y -> (is2,is1,is3), z -> (is3,is2,is1)
    select case (dir_in)
    case (2)
      jd(1) = is2b; jd(2) = is2e; jd(3) = is1b
      jd(4) = is1e; jd(5) = is3b; jd(6) = is3e
    case (3)
      jd(1) = is3b; jd(2) = is3e; jd(3) = is2b
      jd(4) = is2e; jd(5) = is1b; jd(6) = is1e
    case default
      jd(1) = is1b; jd(2) = is1e; jd(3) = is2b
      jd(4) = is2e; jd(5) = is3b; jd(6) = is3e
    end select
    ! HEAP GEOMETRY STASH: captured HERE — immediately after jd, before the
    ! init call, the debug prints, and the dace run, each of which has been
    ! observed corrupting the dummies (is3b/is3e), stack locals, and module
    ! statics.  The unpack (device permute kernels, dump headers) reads
    ! ONLY this stash; the heap has survived every corruption event.
    if (allocated(uperm_geom)) deallocate (uperm_geom)
    allocate (uperm_geom(uperm_gn))
    uperm_geom(1:6) = jd
    uperm_geom(7) = lbound(flux_rsx, 1)
    uperm_geom(8) = size(flux_rsx, 1)
    uperm_geom(9) = size(flux_rsx, 2)
    uperm_geom(10) = size(flux_rsx, 3)
    uperm_geom(11) = size(flux_rsx, 1)*size(flux_rsx, 2)*size(flux_rsx, 3)
    uperm_geom(12) = ext
    uperm_geom(13) = buff_size
    uperm_geom(14) = eqn_idx%adv%beg - 1
    uperm_geom(15) = nvars_l
    uperm_geom(16) = nadv_l
    uperm_geom(17) = nvels_l
    uperm_geom(18) = dir_in
    e64 = int(ext, c_int64_t)
    nv64 = int(nvars_l, c_int64_t)

    if (state_ext(dir_in) /= ext) then
      if (c_associated(state_sweeps(dir_in))) then
        select case (dir_in)
        case (2)
          ierr = sweeps_exit_y(state_sweeps(2))
        case (3)
          ierr = sweeps_exit_z(state_sweeps(3))
        case default
          ierr = sweeps_exit_x(state_sweeps(1))
        end select
      end if
      select case (dir_in)
      case (2)
        state_sweeps(2) = sweeps_init_y(nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
      case (3)
        state_sweeps(3) = sweeps_init_z(nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
      case default
        state_sweeps(1) = sweeps_init_x(nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
      end select
      state_ext(dir_in) = ext
    end if

    select case (dir_in)
    case (2)
      call sweeps_run_y(state_sweeps(2), &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_flux, &
          & d_fsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_gammas, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_pi_infs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & re_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_ql, &
          & d_qr, &
          & d_zeros, &
          & d_qvs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & ridx_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & rgs_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_vsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(rsz1, c_int), &
          & int(rsz2, c_int), &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
    case (3)
      call sweeps_run_z(state_sweeps(3), &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_flux, &
          & d_fsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_gammas, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_pi_infs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & re_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_ql, &
          & d_qr, &
          & d_zeros, &
          & d_qvs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & ridx_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & rgs_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_vsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(rsz1, c_int), &
          & int(rsz2, c_int), &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
    case default
      call sweeps_run_x(state_sweeps(1), &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_flux, &
          & d_fsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_gammas, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_pi_infs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & re_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_ql, &
          & d_qr, &
          & d_zeros, &
          & d_qvs, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & ridx_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & rgs_dev, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_vsrc, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & d_zeros, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & int(jd(1), c_int), &
          & int(jd(2), c_int), &
          & int(jd(3), c_int), &
          & int(jd(4), c_int), &
          & int(jd(5), c_int), &
          & int(jd(6), c_int), &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & 1_c_int64_t, &
          & nv64, &
          & e64, &
          & e64, &
          & nv64, &
          & e64, &
          & e64, &
          & re_e64, &
          & re_e64, &
          & re_e64, &
          & 2_c_int64_t, &
          & 2_c_int64_t, &
          & int(rsz1, c_int), &
          & int(rsz2, c_int), &
          & int(nvels_l, c_int64_t), &
          & e64, &
          & e64)
    end select
    ierr = cudaDeviceSynchronize_(); call chk(ierr, 'sync')



    ! unpack the fluxes ON DEVICE via RAW DEVICE POINTERS: the kernel output
    ! for raw face s lives at 0-based s + buff_size - 1 (the pack's
    ! convention).  The assumed-shape write path (flux_rsx(...) through the
    ! present table) silently lands in an acc temporary whenever the caller's
    ! data region does not map the rsx array, which zeroed every production
    ! rsx output (the D2D diagnostic: known-good bytes in d_flux, zeros in
    ! flux_rsx_vf).  acc_deviceptr_ + explicit flat indexing (e outermost,
    ! the Fortran (s,k,l,e) layout) is layout-exact and mapping-independent;
    ! MFC's own s_finalize_riemann_solver then reshapes into flux_vf /
    ! flux_src_vf exactly as in the OpenACC path.
    flux_dev = acc_deviceptr_(c_loc(flux_rsx(lbound(flux_rsx, 1), &
                                             lbound(flux_rsx, 2), &
                                             lbound(flux_rsx, 3), 1)))
    fsrc_dev = acc_deviceptr_(c_loc(fsrc_rsx(lbound(fsrc_rsx, 1), &
                                             lbound(fsrc_rsx, 2), &
                                             lbound(fsrc_rsx, 3), &
                                             lbound(fsrc_rsx, 4))))
    vsrc_dev = acc_deviceptr_(c_loc(vsrc_rsx(lbound(vsrc_rsx, 1), &
                                             lbound(vsrc_rsx, 2), &
                                             lbound(vsrc_rsx, 3), 1)))
    if (flux_dev == c_null_ptr .or. fsrc_dev == c_null_ptr .or. &
        & vsrc_dev == c_null_ptr) then
      print *, 'm_dace_kernels_sweeps: rsx arrays not device-present for unpack'
      error stop 1
    end if
    ! HOST-SIDE UNPACK: the acc-region variant silently no-ops in this
    ! context regardless of directive form (collapse, deviceptr set, hoisted
    ! bounds — a tagged write inside the region never lands while an
    ! identical standalone probe right after it does), so the permutation
    ! runs on the host: D2H the kernel's packed output, permute, H2D into
    ! the device-resident rsx arrays.  O(nvars*ext^3) work over ~5 MB
    ! buffers — negligible next to the HLLC kernel; MFC's own
    ! s_finalize_riemann_solver then reshapes flux_vf/flux_src_vf exactly
    ! as in the OpenACC path.
    ! All geometry below reads the HEAP stash (uperm_geom): the dace run
    ! smashes stack locals and module statics; the heap survives.
    ! ON-DEVICE UNPACK: the kernel's packed output (eqn-fastest per position,
    ! the window at +buff_size-1 offsets) permutes straight into the
    ! device-resident rsx arrays (eqn-outermost, lbound -1) with acc kernels
    ! through RAW DEVICE POINTERS — the same deviceptr mechanism as the pack.
    ! No host round trip: the D2H + host permute + H2D triple cost ~5 ms/step
    ! at 32^3 (134 MB/step of D2H) and dominated the dispatch-bound premium.
    ! The unpack writes ONLY the kernel's jd window (like the OpenACC kernel,
    ! whose out-of-window slots keep the previous direction's residue — read
    ! by nothing downstream).
    ! All geometry is hoisted from the HEAP stash (uperm_geom) into locals
    ! immediately before each region: the dace run smashes stack locals and
    ! module statics; the heap survives, and the corruption burst is over by
    ! unpack time.
    j1b = uperm_geom(1); j1e = uperm_geom(2)
    j2b = uperm_geom(3); j2e = uperm_geom(4)
    j3b = uperm_geom(5); j3e = uperm_geom(6)
    lbv = uperm_geom(7); n1v = uperm_geom(8); n2v = uperm_geom(9)
    estv = uperm_geom(11); extv = uperm_geom(12); bufv = uperm_geom(13)
    eoffv = uperm_geom(14); nrowsv = uperm_geom(15)
    call c_f_pointer(d_flux, pk_f, [int(nrowsv*extv**3, c_size_t)])
    call c_f_pointer(flux_dev, rs_f, [int(n1v*n2v*uperm_geom(10)*nrowsv, c_size_t)])
    !$acc parallel loop collapse(3) deviceptr(pk_f, rs_f)
    do l_raw = 0, j3e - j3b
      do k_raw = 0, j2e - j2b
        do u = 0, j1e - j1b
          s_raw = u + j1b
          k = k_raw + j2b
          l = l_raw + j3b
          dst_base = (s_raw - lbv) + n1v*((k - lbv) + n2v*(l - lbv))
          src_base = (s_raw + bufv - 1) + &
                     extv*((k + bufv - 1) + extv*(l + bufv - 1))
          do e = 1, nrowsv
            rs_f(dst_base + estv*(e - 1) + 1) = pk_f((e - 1) + nrowsv*src_base + 1)
          end do
        end do
      end do
    end do
    !$acc end parallel loop

    call c_f_pointer(d_vsrc, pk_f, [int(uperm_geom(17)*extv**3, c_size_t)])
    call c_f_pointer(vsrc_dev, rs_f, [int(n1v*n2v*uperm_geom(10)*uperm_geom(17), c_size_t)])
    !$acc parallel loop collapse(3) deviceptr(pk_f, rs_f)
    do l_raw = 0, j3e - j3b
      do k_raw = 0, j2e - j2b
        do u = 0, j1e - j1b
          s_raw = u + j1b
          k = k_raw + j2b
          l = l_raw + j3b
          dst_base = (s_raw - lbv) + n1v*((k - lbv) + n2v*(l - lbv))
          src_base = (s_raw + bufv - 1) + &
                     extv*((k + bufv - 1) + extv*(l + bufv - 1))
          do e = 1, uperm_geom(17)
            rs_f(dst_base + estv*(e - 1) + 1) = pk_f((e - 1) + uperm_geom(17)*src_base + 1)
          end do
        end do
      end do
    end do
    !$acc end parallel loop

    ! the kernel addresses the fsrc rows by ABSOLUTE eqn index against
    ! the sys_size-strided buffer; the caller's fsrc rows run
    ! adv%beg..sys_size
    call c_f_pointer(d_fsrc, pk_f, [int(nrowsv*extv**3, c_size_t)])
    call c_f_pointer(fsrc_dev, rs_f, [int(n1v*n2v*uperm_geom(10)*uperm_geom(16), c_size_t)])
    !$acc parallel loop collapse(3) deviceptr(pk_f, rs_f)
    do l_raw = 0, j3e - j3b
      do k_raw = 0, j2e - j2b
        do u = 0, j1e - j1b
          s_raw = u + j1b
          k = k_raw + j2b
          l = l_raw + j3b
          dst_base = (s_raw - lbv) + n1v*((k - lbv) + n2v*(l - lbv))
          src_base = (s_raw + bufv - 1) + &
                     extv*((k + bufv - 1) + extv*(l + bufv - 1))
          do e = 1, uperm_geom(16)
            rs_f(dst_base + estv*(e - 1) + 1) = &
                pk_f((eoffv + e - 1) + nrowsv*src_base + 1)
          end do
        end do
      end do
    end do
    !$acc end parallel loop

    ! Copy the kernel's interface-Reynolds staging back to the host and
    ! push it to the device copy the acc declare-create registered (the
    ! acc viscous source consumes it on the acc stream).
    if (allocated(re_avg_rsx_vf) .and. c_associated(d_re_stage)) then
      if (.not. allocated(re_back) .or. size(re_back) /= &
          & (size(re_avg_rsx_vf, 1) + 1)**3*2) then
        if (allocated(re_back)) deallocate (re_back)
        allocate (re_back((size(re_avg_rsx_vf, 1) + 1)**3*2))
      end if
      ierr = cudaMemcpy_(c_loc(re_back(1)), d_re_stage, &
                         & int(size(re_back)*8, c_size_t), cpD2H)
      call chk(ierr, 'D2H re_stage')
      ! The staging = the kernel's RE(j0+1, k0+1, l0+1, i) window with the
      ! TU's (j,k,l) = (sweep-face, dim2, dim3) and j0 = raw - face_beg:
      !   dir 1: stag dims = (x_face+2, y+1, z+1) -> rsx(x,y,z) = stag(x+1, y, z)
      !   dir 2: stag dims = (y_face+2, x+1, z+1) -> rsx(x,y,z) = stag(y+1, x, z)
      !   dir 3: stag dims = (z_face+2, y+1, x+1) -> rsx(x,y,z) = stag(z+1, y, x)
      block
        integer :: rr, qq, pp, ii, sf_
        integer :: e1, e2
        e1 = size(re_avg_rsx_vf, 1)
        e2 = e1 + 1
        do ii = 1, 2
          do rr = 0, e1 - 1
            do qq = 0, e1 - 1
              do pp = 0, e1 - 1
                ! The TU loops run on the RAW bounds (jd) and write
                ! RE(j+1,k+1,l+1): the staging position = raw+1 per axis =
                ! the rsx position exactly.  Staging = C-order with the TU's
                ! (j,k,l) = (sweep-face, dim2, dim3): dim1 outermost, dim3
                ! fastest; the rsx = F-order.
                select case (dir_in)
                case (2)
                  sf_ = qq*e2*e2 + pp*e2 + rr + e2*e2*e2*(ii - 1)
                case (3)
                  sf_ = rr*e2*e2 + qq*e2 + pp + e2*e2*e2*(ii - 1)
                case default
                  sf_ = pp*e2*e2 + qq*e2 + rr + e2*e2*e2*(ii - 1)
                end select
                re_avg_rsx_vf(pp - 1, qq - 1, rr - 1, ii) = re_back(sf_ + 1)
              end do
            end do
          end do
        end do
      end block
      !$acc update device(re_avg_rsx_vf)
    end if

    block
      logical :: dmp = .false.
      call s_dace_hllc_dump('dace', dmp)
    end block
  end subroutine s_dace_hllc_x

  !> Dump the MFC-layout rsx outputs (flux/fsrc/vsrc) to <tag>.bin — used by
  !! the capture flow: the main call dumps the DaCe results, and
  !! s_dace_hllc_capture dumps the OpenACC reference that the dispatch
  !! guard runs right after in capture mode (MFC_DACE_HLLC_RT_OFF=2).
  subroutine s_dace_hllc_dump(tag, dumped)
    character(len=*), intent(in) :: tag
    logical, intent(inout) :: dumped
    character(len=32) :: dbg_env
    character(len=1) :: dtag
    integer :: dbg_st
    integer(c_int64_t) :: n
    real(c_double), allocatable, target :: buf(:)
    integer, save :: gdump = 0
    character(len=8) :: dbg_stage
    character(len=6) :: cnum
    integer :: dbg_max, dbg_st2

    call get_environment_variable('MFC_SWEEPS_DUMP_MAX', dbg_stage, &
                                  status=dbg_st2)
    if (dbg_st2 == 0) then
      read (dbg_stage, *) dbg_max
    else
      dbg_max = 3
    end if
    ! dump the first dbg_max CALLS with a global counter in the filename
    ! (the call order is x,y,z per RK stage, so N mod 3 gives the dir;
    ! dir_idx proved unreliable in the capture context)
    gdump = gdump + 1
    if (gdump > dbg_max) return
    write (cnum, '(I6.6)') gdump

    n = int(size(flux_rsx_vf, 1), c_int64_t)*int(size(flux_rsx_vf, 2), c_int64_t)* &
        & int(size(flux_rsx_vf, 3), c_int64_t)*int(size(flux_rsx_vf, 4), c_int64_t)
    allocate (buf(n))
    !$acc update host(flux_rsx_vf)
    buf(1:n) = reshape(flux_rsx_vf, [int(n)])
    open (10, file='/tmp/sweepdump_'//cnum//'_'//trim(tag)//'_flux.bin', form='unformatted', access='stream')
    write (10) size(flux_rsx_vf, 1), size(flux_rsx_vf, 4), is1%beg, is1%end, is2%beg, is2%end, is3%beg, is3%end
    write (10) buf
    close (10)

    n = int(size(flux_src_rsx_vf, 1), c_int64_t)*int(size(flux_src_rsx_vf, 2), c_int64_t)* &
        & int(size(flux_src_rsx_vf, 3), c_int64_t)*int(size(flux_src_rsx_vf, 4), c_int64_t)
    deallocate (buf)
    allocate (buf(n))
    !$acc update host(flux_src_rsx_vf)
    buf(1:n) = reshape(flux_src_rsx_vf, [int(n)])
    open (10, file='/tmp/sweepdump_'//cnum//'_'//trim(tag)//'_fsrc.bin', form='unformatted', access='stream')
    write (10) size(flux_src_rsx_vf, 1), size(flux_src_rsx_vf, 4), is1%beg, is1%end, is2%beg, is2%end, is3%beg, is3%end
    write (10) buf
    close (10)

    n = int(size(vel_src_rsx_vf, 1), c_int64_t)*int(size(vel_src_rsx_vf, 2), c_int64_t)* &
        & int(size(vel_src_rsx_vf, 3), c_int64_t)*int(size(vel_src_rsx_vf, 4), c_int64_t)
    deallocate (buf)
    allocate (buf(n))
    !$acc update host(vel_src_rsx_vf)
    buf(1:n) = reshape(vel_src_rsx_vf, [int(n)])
    open (10, file='/tmp/sweepdump_'//cnum//'_'//trim(tag)//'_vsrc.bin', form='unformatted', access='stream')
    write (10) size(vel_src_rsx_vf, 1), size(vel_src_rsx_vf, 4), is1%beg, is1%end, is2%beg, is2%end, is3%beg, is3%end
    write (10) buf
    close (10)
    deallocate (buf)

    ! the interface-Reynolds output: NEVER covered by the flux/fsrc/vsrc
    ! dumps, yet read by every downstream viscous stress — the prime
    ! suspect for kernel-exact-but-e2e-catastrophic runs
    print *, 'SWRE: allocated=', allocated(re_avg_rsx_vf), ' rsz_tag=', trim(tag)
    if (allocated(re_avg_rsx_vf)) then
      n = int(size(re_avg_rsx_vf, 1), c_int64_t)*int(size(re_avg_rsx_vf, 2), c_int64_t)* &
          & int(size(re_avg_rsx_vf, 3), c_int64_t)*int(size(re_avg_rsx_vf, 4), c_int64_t)
      allocate (buf(n))
      !$acc update host(re_avg_rsx_vf)
      buf(1:n) = reshape(re_avg_rsx_vf, [int(n)])
      open (10, file='/tmp/sweepdump_'//cnum//'_'//trim(tag)//'_re.bin', form='unformatted', access='stream')
      write (10) size(re_avg_rsx_vf, 1), size(re_avg_rsx_vf, 4), is1%beg, is1%end, is2%beg, is2%end, is3%beg, is3%end
      write (10) buf
      close (10)
      deallocate (buf)
    end if

    print *, 'SWDUMP call', gdump, 'tag=', trim(tag)
  end subroutine s_dace_hllc_dump

  !> Capture-mode entry: dump the OpenACC reference rsx outputs that the
  !! guard computed immediately before this call.
  subroutine s_dace_hllc_capture()
    logical, save :: dumped = .false.
    call s_dace_hllc_dump('acc', dumped)
  end subroutine s_dace_hllc_capture

end module m_dace_kernels_sweeps
#endif
