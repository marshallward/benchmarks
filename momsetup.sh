#!/bin/bash
# MOM 5 Build script
# ==================

# Script configuration

MOM_ROOT=$(pwd)/mom5    # Replace with target directory
TARGET=vendor           # Assign a unique name for this build (e.g. company)


#------------------------------------------------------------------------------
# 1. Download the latest MOM 5 codebase.

SOURCE_URL=https://github.com/mom-ocean/MOM5.git
if [ ! -d ${MOM_ROOT} ]; then
    git clone ${SOURCE_URL} ${MOM_ROOT}
fi

# Directory overview:
#   bin  : Target platform configuration and support programs
#   src  : Model source code
#   exp  : Build and run scripts
#   exec : Target executables (created after compilation)
#   doc  : Documentation
#   data : Model configuration data fetch scripts
#   test : CI testing framework


#------------------------------------------------------------------------------
# 2. Environment module setup
#
# The `environs.${TARGET)` file lists the environment modules used for any
# supporting software and libraries, such as compilers or MPI library.
#
# Systems without environment module support will need to explicitly set the 
# environment variables associated with the libraries, such as PATH or CPATH.
# Explicit environment variables such as CC are set in the next section.
#
# The following modules are required:
#   1. C compiler
#   2. Fortran compiler
#   3. MPI library
#   4. netCDF library (+ HDF5 if not statically linked)
#
# The `mpirunCommand` variable is not needed if using the NCI-provided
# runscript.  It is only used by the GFDL runscripts.

cd ${MOM_ROOT}/bin
cp environs.nci environs.${TARGET}
# Now edit `environs.${TARGET}` for your environment.  Ensuire that the file is
# saved in the `${ROOT}/bin` directory.


#------------------------------------------------------------------------------
# 3. MKMF template setup
#
# MOM uses the `mkmf` tool to generate its Makefiles, and relies on templates
# to set the compilers and associated flags.
#
# Many different approaches taken by different communities can be see in the
# `bin` directory, but the following variables are required by `mkmf`:
#
#   CPPDEFS:    Preprocessor (cpp) definitions
#   CC:         C compiler
#   CFLAGS:     C compiler flags
#   FC:         Fortran compiler
#   FFLAGS:     Fortran compiler flags
#   MAKEFLAGS:  Makefile flags
#   LDFLAGS:    Linker (ld) flags
#
# Certain flags are expected for most runs, so more information may be needed
# here.  Minimal instructions are shown below.

cd ${MOM_ROOT}/bin
cp mkmf.template.nci mkmf.template.${TARGET}
# Edit `mkmf.template.${TARGET} to match the target environment compilers.


#------------------------------------------------------------------------------
# 4. Build the MOM executable
#
# Building MOM relies on the `MOM_compile.csh` script, which uses several tools
# in the `bin` directory (`mkmf`, `list_paths`) to generate Makefiles for each
# library and submodel, and then runs these Makefiles to produce the
# executable.
#
# Multiple executables are supported.  Only two are required for the benchmark:
#   MOM_solo:   Ocean-only (uncoupled) simulations.
#   MOM_SIS:    Ocean-Ice simuluations.  This includes the SIS sea ice model
#               relies on the GFDL ("FMS") coupler.
#
# The build scripts are in the `exp` directory.

cd ${MOM_ROOT}/exp
./MOM_compile.csh --platform ${TARGET} --type MOM_solo
./MOM_compile.csh --platform ${TARGET} --type MOM_SIS

# Executables are created in the `exec` directory:
#
#   ${MOM_ROOT}/exec/${TARGET}/MOM_solo/fms_MOM_solo.x
#   ${MOM_ROOT}/exec/${TARGET}/MOM_SIS/fms_MOM_SIS.x
#
# Supporting local libraries are statically linked and do not need to be
# managed by the user.
