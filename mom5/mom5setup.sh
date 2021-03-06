#!/bin/bash

ROOT=$(pwd)
CODEBASE=${ROOT}/codebase
OM25_WORK=${ROOT}/om25
OM25_EXPT=global_0.25_degree_NYF
CM2_EXPT=CM2.1p1

DATASETS="${OM25_EXPT} ${CM2_EXPT}"

#------------------------------------------------------------------------------
# 1. Fetch the experiment datasets

cd ${CODEBASE}/data

for dataset in ${DATASETS}; do
    DATAFILE=${dataset}.input.tar.gz
    DATAPATH=${CODEBASE}/data/archives/${DATAFILE}

    if [ ! -f ${DATAPATH} ]; then
        ./get_exp_data.py ${DATAFILE}
        tar -xzvf ${DATAPATH}
    fi
done

#------------------------------------------------------------------------------
# 2. Set up directory

mkdir -p ${OM25_WORK}
mkdir -p ${OM25_WORK}/RESTART

if [ ! -d ${CODEBASE}/data/${OM25_EXPT}/INPUT ]; then
    mv ${CODEBASE}/data/${OM25_EXPT}/INPUT ${OM25_WORK}

    cd ${OM25_WORK}
    mv INPUT/*_table .
    mv INPUT/*.nml .
fi

if [ ! -f ${CODEBASE}/exec/vendor/MOM_SIS/fms_MOM_SIS.x ]; then
    ln -s ${CODEBASE}/exec/vendor/MOM_SIS/fms_MOM_SIS.x .
fi
