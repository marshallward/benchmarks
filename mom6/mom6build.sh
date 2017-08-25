#!/bin/bash
set -x

# 0. Set up environment
CODEBASE=$(pwd)/codebase
TARGET=nci-intel
REPO_URL=https://github.com/NOAA-GFDL/MOM6-examples.git

# NOTE: MOM 6 needs a newer gcc (such as 6.2.0), but NCI's netcdf.mod is built
# for the older GNU compilers and appears to be incompatible.  Ask help?

module purge
#module load gcc/6.2.0
module load intel-cc/17.0.1.132
module load intel-fc/17.0.1.132
module load openmpi/1.10.2
module load netcdf/4.3.3.1


# 1. Get the source
# NOTE: This downloads several submodules, including the MOM 6 source
if [ ! -d ${CODEBASE} ]; then
    git clone --recursive ${REPO_URL} ${CODEBASE}
fi
# Add mkmf and list_paths to path
PATH=${CODEBASE}/src/mkmf/bin:${PATH}

# TODO: Loop 2 and 3

# 2. Build FMS
FMS_PATH=${CODEBASE}/build/${TARGET}/shared/repro
mkdir -p ${FMS_PATH}
cd ${FMS_PATH}
rm -f path_names
list_paths ${CODEBASE}/src/FMS
mkmf \
    -t ${CODEBASE}/src/mkmf/templates/${TARGET}.mk \
    -p libfms.a \
    -c "-Duse_libMPI -Duse_netCDF -DSPMD" \
    path_names
#make clean
make NETCDF=4 libfms.a -j


# 3a. Build the ocean-only executable
OCN_PATH=${CODEBASE}/build/${TARGET}/ocean_only/repro
mkdir -p ${OCN_PATH}
cd ${OCN_PATH}
rm -f path_names
list_paths \
    ${OCN_PATH} \
    ${CODEBASE}/src/MOM6/{config_src/dynamic,config_src/solo_driver,src/{*,*/*}}/
mkmf \
    -t ${CODEBASE}/src/mkmf/templates/${TARGET}.mk \
    -o '-I../../shared/repro' \
    -p MOM6 \
    -l '-L../../shared/repro -lfms' \
    -c '-Duse_libMPI -Duse_netCDF -DSPMD' \
    path_names

make clean
make NETCDF=4 MOM6 -j


# 3b. Build the coupled executable (with SIS2)
ICE_OCN_PATH=${CODEBASE}/build/${TARGET}/ice_ocean_SIS2/repro
mkdir -p ${ICE_OCN_PATH}
cd ${ICE_OCN_PATH}
rm -f path_names

list_paths \
    ${ICE_OCN_PATH} \
    ${CODEBASE}/src/MOM6/config_src/{dynamic,coupled_driver} \
    ${CODEBASE}/src/MOM6/src/{*,*/*}/ \
    ${CODEBASE}/src/{atmos_null,coupler,land_null,ice_ocean_extras,icebergs,SIS2,FMS/coupler,FMS/include}/

mkmf \
    -t ${CODEBASE}/src/mkmf/templates/${TARGET}.mk \
    -o '-I ../../shared/repro' \
    -p MOM6 \
    -l '-L../../shared/repro -lfms' \
    -c '-Duse_libMPI -Duse_netCDF -DSPMD -DUSE_LOG_DIAG_FIELD_INFO -Duse_AM3_physics -D_USE_LEGACY_LAND_' \
    path_names

make clean
make NETCDF=4 MOM6 -j
