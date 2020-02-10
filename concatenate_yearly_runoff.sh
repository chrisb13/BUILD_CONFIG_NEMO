#!/bin/bash

CONFIG="WED12"
RNF_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED025/RNF_CAT"
RNF_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED025_JRA/RNF"
RNF_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED025_JRA_2/RNF"
RNF_DIR="/nerc/n02/n02/chbull/nemo/bld_configs/input_WED025_3/RNF"
RNF_DIR="/nerc/n02/n02/chbull/nemo/bld_configs/input_WED12_CORE/RNF_CAT"


YEARi=1976
YEARf=2005

#----------------------------------------------------------------------------

for YEAR in $(seq $YEARi $YEARf)
do

  ncrcat ${RNF_DIR}/runoff_${YEAR}_*_${CONFIG}.nc ${RNF_DIR}/runoff_y${YEAR}_${CONFIG}.nc
  if [ -f ${RNF_DIR}/runoff_y${YEAR}_${CONFIG}.nc ]; then
    rm -f ${RNF_DIR}/runoff_${YEAR}_*_${CONFIG}.nc
    echo "${RNF_DIR}/runoff_y${YEAR}_${CONFIG}.nc  [oK]"
  else
    echo "~!@#%^&* ERROR: ${RNF_DIR}/runoff_y${YEAR}_${CONFIG}.nc HAS NOT BEEN CREATED   >>>>> STOP !!"
    exit
  fi

done
