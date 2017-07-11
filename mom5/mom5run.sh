#!/bin/bash
#PBS -P fp0
#PBS -q normal
#PBS -l walltime=1:00:00,mem=1000GB,ncpus=960,jobfs=1GB,wd

module purge
module load openmpi/1.10.2

cd om25
mpirun -np ${PBS_NCPUS} ./fms_MOM_SIS.x
