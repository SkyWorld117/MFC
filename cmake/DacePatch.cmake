# SPDX-License-Identifier: MIT
#
# MFC_DACE: the dispatch patch, and the mirror of the source tree it is applied to.
#
# This file is the ONLY place the build learns that the dispatch call sites exist, and it is
# included immediately before HANDLE_SOURCES so the variables it sets are in scope when Fypp.cmake
# decides, per file, whether to preprocess the pristine source or the patched copy.
#
# It is deliberately a separate file rather than a block in CMakeLists.txt: the MFC-side footprint
# of the DaCe port is meant to be small and reviewable, and this -- plus cmake/Fypp.cmake's
# `_fpp_in` selection, plus the MFC_DACE_LIBS block -- is the whole of it.
#
# WHAT THE PATCH IS, AND WHY IT IS NOT JUST A PATCH TO CMake:
#   The kernels are compiled into separate shared libraries; what a library cannot do by itself is
#   get *called*.  The call site has to sit in MFC's own source, inside the routine whose loops the
#   kernel replaces, with the stock loops preserved as the `else`.  That is what the patch carries.
#   It is generated, not hand-written -- see patches/README.md.

if(NOT MFC_DACE)
    return()
endif()

set(MFC_DACE_PATCH  "${CMAKE_SOURCE_DIR}/patches/mfc_dace.patch")
set(MFC_DACE_MIRROR "${CMAKE_BINARY_DIR}/dace_mirror")
set(MFC_DACE_STAMP  "${MFC_DACE_MIRROR}/.patched")

if(NOT EXISTS "${MFC_DACE_PATCH}")
    message(FATAL_ERROR
        "MFC_DACE=ON but the dispatch patch is missing:\n  ${MFC_DACE_PATCH}\n"
        "Regenerate it (patches/README.md) or configure with -DMFC_DACE=OFF.")
endif()

# The list of files the patch touches, read from the patch itself so the two cannot drift.
# Consumed by cmake/Fypp.cmake to choose the fypp input per file, and by the mirror step below.
file(STRINGS "${MFC_DACE_PATCH}" _dace_patch_headers REGEX "^\\+\\+\\+ b/")
set(MFC_DACE_PATCHED_FILES "")
foreach(_h ${_dace_patch_headers})
    string(REGEX REPLACE "^\\+\\+\\+ b/" "" _rel "${_h}")
    string(REGEX REPLACE "\t.*$" "" _rel "${_rel}")
    list(APPEND MFC_DACE_PATCHED_FILES "${_rel}")
endforeach()
if(MFC_DACE_PATCHED_FILES STREQUAL "")
    message(FATAL_ERROR "MFC_DACE: ${MFC_DACE_PATCH} has no '+++ b/' headers")
endif()
list(REMOVE_DUPLICATES MFC_DACE_PATCHED_FILES)

# ONE custom command for the whole patch -- see dace_apply_patch.cmake for why it cannot be
# per-file.  It DEPENDS on the source files it copies, so editing one re-applies the patch.
set(_dace_patch_inputs "${MFC_DACE_PATCH}" "${CMAKE_SOURCE_DIR}/cmake/dace_apply_patch.cmake")
foreach(_rel ${MFC_DACE_PATCHED_FILES})
    if(EXISTS "${CMAKE_SOURCE_DIR}/${_rel}")
        list(APPEND _dace_patch_inputs "${CMAKE_SOURCE_DIR}/${_rel}")
    endif()
endforeach()

add_custom_command(
    OUTPUT  "${MFC_DACE_STAMP}"
    COMMAND "${CMAKE_COMMAND}"
            "-DSRC=${CMAKE_SOURCE_DIR}"
            "-DMIRROR=${MFC_DACE_MIRROR}"
            "-DPATCH=${MFC_DACE_PATCH}"
            -P "${CMAKE_SOURCE_DIR}/cmake/dace_apply_patch.cmake"
    DEPENDS ${_dace_patch_inputs}
    COMMENT "MFC_DACE: applying the dispatch patch to a build-dir mirror of the sources"
    VERBATIM)

# A target so the stamp is always produced before anything that depends on it, and so a developer
# can run `cmake --build . --target mfc_dace_patch` to see the patch fail on its own.
add_custom_target(mfc_dace_patch DEPENDS "${MFC_DACE_STAMP}")

# fypp needs the patched copy to exist before it runs; Fypp.cmake adds this to each file's DEPENDS.
set(MFC_DACE_PATCH_STAMP "${MFC_DACE_STAMP}")
