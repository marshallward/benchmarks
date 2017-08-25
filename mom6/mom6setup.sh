#!/bin/bash
set -x

# 0. Set up environment
ROOT=$(pwd)
CODEBASE=${ROOT}/codebase
BENCH_WORK=${ROOT}/benchmark
OM4_WORK=${ROOT}/om4


#----
# Fetch the input data
#cd ${CODEBASE}/om4
#
#INPUT_FILE=OM4_025.tgz
#if [ ! -f ${INPUT_FILE} ]; then
#    wget ftp://ftp.gfdl.noaa.gov/pub/aja/datasets/${INPUT_FILE}
#fi


#---
# Set up the directory
mkdir -p ${BENCH_WORK}/{INPUT,RESTART}

for fname in MOM_input MOM_override diag_table input.nml; do 
    cp ${CODEBASE}/ocean_only/benchmark/${fname} ${BENCH_WORK}
done

# Configure the experiment for high resolution
BENCH_INPUT=${BENCH_WORK}/MOM_input
cp ${BENCH_INPUT} ${BENCH_INPUT}.orig
sed -i -e 's/NIGLOBAL = 360/NIGLOBAL = 1440/g' ${BENCH_INPUT}
sed -i -e 's/NJGLOBAL = 180/NJGLOBAL = 1080/g' ${BENCH_INPUT}
sed -i -e 's/NK = 22/NK = 75/g' ${BENCH_INPUT}


#--
# Link executable
TARGET=nci-intel
ln -s ${CODEBASE}/build/${TARGET}/ocean_only/repro/MOM6 ${BENCH_WORK}
