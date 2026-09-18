# patches/mfc_dace.patch

The **dispatch call sites** for the DaCe backend — the only part of the port that has to live in
MFC's own source.

## Why a patch at all

The DaCe kernels are compiled into separate shared libraries. A library cannot get *called* by
itself: the call has to sit inside the routine whose loops the kernel replaces, with the stock loops
preserved as the `else` so the fallback is the code MFC already had. That is what this patch
carries, and it is the whole of the source-side change.

Everything else is outside MFC's source tree:

| piece | where it lives |
|---|---|
| the kernels | `pipeline/mfc_dace/libmfc_dace_*.so`, linked by CMake |
| the shims that call them | `src/{common,simulation}/m_dace_kernels_*.fpp` — **added files**, not patched |
| this patch | applied by `cmake/DacePatch.cmake` to a build-dir mirror |

## How it is applied

`cmake/DacePatch.cmake` (included just before `HANDLE_SOURCES`) runs
`cmake/dace_apply_patch.cmake`, which copies every file the patch names into
`<build>/dace_mirror/`, applies the patch there, and `cmake/Fypp.cmake` feeds fypp the **mirror**
copy for those files and the pristine source for every other file.

Two properties are deliberate and load-bearing:

- **Never in place.** An in-place patch would dirty the working tree (so `MFC_DACE=OFF` would no
  longer be a pristine upstream checkout), would not be idempotent under a reconfigure, and would
  feed patched text to every generator — they all read the source tree directly.
- **A failure is a build error.** Every other gate in this project is bit-identity, and bit-identity
  is *satisfied by the stock loops*. A patch that quietly failed to apply would turn every dispatch
  off and every gate would still pass. `--fuzz=0` plus a hard error is what prevents that; see
  `cmake/dace_apply_patch.cmake`.

## Regenerating it

The patch is generated from the porting fork's source diff, against the upstream commit the fork is
based on:

```bash
BASE=<upstream commit the fork is based on>
git diff $BASE..HEAD -- \
    src/simulation/m_viscous.fpp src/simulation/m_rhs.fpp src/simulation/m_weno.fpp \
    src/simulation/m_riemann_solver_hllc.fpp src/simulation/m_riemann_state.fpp \
    src/simulation/m_time_steppers.fpp src/simulation/m_riemann_solvers.fpp \
    src/simulation/m_data_output.fpp src/simulation/m_start_up.fpp \
    src/common/m_variables_conversion.fpp src/common/m_boundary_common.fpp \
    src/common/m_mpi_common.fpp \
    > patches/mfc_dace.patch
```

Then check it still applies to the tree being built:

```bash
patch -p1 --dry-run --forward < patches/mfc_dace.patch
```

A rebase that moves the surrounding code will make that fail — which is the intended signal. Fix it
by regenerating against the new base, **not** by loosening the check.

## What the patch must not do

**Create files.** `HANDLE_SOURCES` globs the *source* tree, so a file that exists only in the mirror
is never added to the target: the patch would appear to apply and the build would fail much later
with an undefined symbol. New files — the shims, `m_dev_mem.fpp` — are added to the repository
instead. `dace_apply_patch.cmake` enforces this.
