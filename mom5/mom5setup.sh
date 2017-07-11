#!/bin/bash

MOM_ROOT=$(pwd)/codebase
OM25_WORK=$(pwd)/om25
OM25_EXPT=global_0.25_degree_NYF

#----
# Rely on MOM_run.sh ?

#cd ${MOM_ROOT}/exp
#./MOM_run.csh \
#    --platform nci \
#    --type MOM_SIS \
#    --experiment ${OM25_EXPT} \
#    --download_input_data \
#    --npes 960
#
#ln -s mom5/work/${OM25_EXPT} ${OM25_WORK}

#----

# Fetch data
cd ${MOM_ROOT}/data
./get_exp_data.py ${OM25_EXPT}.input.tar.gz
tar -xzvf ${MOM_ROOT}/data/archives/${OM25_EXPT}.input.tar.gz

# Set up directory
mkdir -p ${OM25_WORK}
mkdir -p ${OM25_WORK}/RESTART
mv ${MOM_ROOT}/data/${OM25_EXPT}/INPUT ${OM25_WORK}

cd ${OM25_WORK}
mv INPUT/*_table .
mv INPUT/*.nml .

ln -s ${MOM_ROOT}/exec/vendor/MOM_SIS/fms_MOM_SIS.x .
