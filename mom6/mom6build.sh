#!/bin/bash

# 1. Get the source
# NOTE: This downloads several submodules, including the MOM 6 source

git clone --recursive https://github.com/NOAA-GFDL/MOM6-examples.git MOM6-examples


# 2. Set up the build directory
mkdir MOM6-examples/build


# 3. Fetch the input data
# (Is this possible here?)
wget ftp://ftp.gfdl.noaa.gov/pub/aja/datasets/OM4_025.tgz


# 4.
