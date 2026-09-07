#!/usr/bin/env python3
"""
P2/T2.3 G2 smoke case: 3-D 5-eq 2-fluid viscous shock-free pressure wave on
a tiny grid.  viscous=T routes the fd-gradient computation through the
MFC_DACE dispatch (the DaCe-compiled fused fdiff kernel); the HLLC sweep /
conversion / RK stages stay on the OpenACC path at this stage of the
integration.  Small (24^3 interior, 10 steps) so it runs in seconds.
"""

import argparse
import json
import math

parser = argparse.ArgumentParser(description="3D 5eq 2-fluid viscous MFC_DACE smoke case")
parser.add_argument("--mfc", type=json.loads, default="{}", metavar="DICT")
parser.add_argument("-N", type=int, default=24, help="Grid points per dim")
parser.add_argument("--cfl", type=float, default=0.2)
parser.add_argument("--t-end", type=float, default=1.0e-4)
args = parser.parse_args()

gamma_l = 1.4
gamma_r = 1.3
N = args.N
m = N - 1
L = 1.0
dx = L / N

c_max = 700.0
dt = args.cfl * dx / c_max
Nt = max(1, math.ceil(args.t_end / dt))

print(
    json.dumps(
        {
            "run_time_info": "F",
            "x_domain%beg": 0.0,
            "x_domain%end": L,
            "y_domain%beg": 0.0,
            "y_domain%end": L,
            "z_domain%beg": 0.0,
            "z_domain%end": L,
            "m": m,
            "n": m,
            "p": m,
            "dt": dt,
            "t_step_start": 0,
            "t_step_stop": Nt,
            "t_step_save": Nt,
            "num_patches": 1,
            "model_eqns": "5eq",
            "alt_soundspeed": "F",
            "num_fluids": 2,
            "mpp_lim": "F",
            "mixture_err": "F",
            "bubbles": "F",
            "viscous": "T",
            "weno_Re_flux": "F",
            "time_stepper": 3,
            "riemann_solver": "hllc",
            "wave_speeds": "direct",
            "avg_state": "arithmetic",
            "bc_x%beg": -1,
            "bc_x%end": -1,
            "bc_y%beg": -1,
            "bc_y%end": -1,
            "bc_z%beg": -1,
            "bc_z%end": -1,
            "format": "silo",
            "precision": "double",
            "prim_vars_wrt": "T",
            "parallel_io": "F",
            "patch_icpp(1)%geometry": 9,
            "patch_icpp(1)%x_centroid": 0.5,
            "patch_icpp(1)%y_centroid": 0.5,
            "patch_icpp(1)%z_centroid": 0.5,
            "patch_icpp(1)%length_x": L,
            "patch_icpp(1)%length_y": L,
            "patch_icpp(1)%length_z": L,
            "patch_icpp(1)%vel(1)": 0.0,
            "patch_icpp(1)%vel(2)": 0.0,
            "patch_icpp(1)%vel(3)": 0.0,
            "patch_icpp(1)%pres": 1.1e5,
            "patch_icpp(1)%alpha_rho(1)": 0.6,
            "patch_icpp(1)%alpha_rho(2)": 0.45,
            "patch_icpp(1)%alpha(1)": 0.5,
            "patch_icpp(1)%alpha(2)": 0.5,
            "fluid_pp(1)%gamma": 1.0 / (gamma_l - 1.0),
            "fluid_pp(1)%eos": "stiffened_gas",
            "fluid_pp(1)%pi_inf": 0.0,
            "fluid_pp(2)%gamma": 1.0 / (gamma_r - 1.0),
            "fluid_pp(2)%eos": "stiffened_gas",
            "fluid_pp(2)%pi_inf": 200.0,
            "recon_type": "weno",
            "weno_order": 5,
            "weno_eps": 1.0e-40,
            "weno_Re_flux": "F",
            "weno_avg": "F",
            "mapped_weno": "F",
            "null_weights": "F",
            "mp_weno": "F",
            "teno": "F",
        }
    )
)
