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

# Fetch the input data
cd ${CODEBASE}

INPUT_FILE=OM4_025.tgz
if [ ! -f ${INPUT_FILE} ]; then
    wget ftp://ftp.gfdl.noaa.gov/pub/aja/datasets/${INPUT_FILE}
fi
