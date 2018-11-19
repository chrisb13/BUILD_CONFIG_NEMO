#!/bin/bash

CONFIG="WED025"
BDY_DIR="$SHAREDELMER/input/nemo_WED12/BDY"
BDY_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED12/BDY"
BDY_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED025/BDY_CP"
BDY_DIR="/fs2/n02/n02/chbull/nemo/bld_configs/input_WED025_2/BDY_CAT"
YEARi=1976
YEARf=2005

#for BDY in bdyT_tra bdyU_u3d bdyU_u2d bdyV_u3d bdyV_u2d bdyT_ice bdyT_ssh
for BDY in bdyT_tra bdyU_u3d bdyU_u2d bdyV_u3d bdyV_u2d bdyT_ssh
do

for YEAR in $(seq $YEARi $YEARf)
do

  ncrcat ${BDY_DIR}/${BDY}_${YEAR}_??_??_${CONFIG}.nc ${BDY_DIR}/${BDY}_y${YEAR}_${CONFIG}.nc
  if [ -f ${BDY_DIR}/${BDY}_y${YEAR}_${CONFIG}.nc ]; then
    rm -f ${BDY_DIR}/${BDY}_${YEAR}_??_??_${CONFIG}.nc
    echo "${BDY_DIR}/${BDY}_y${YEAR}_${CONFIG}.nc  [oK]"
  else
    echo "~!@#%^&* ERROR: ${BDY_DIR}/${BDY}_y${YEAR}_${CONFIG}.nc HAS NOT BEEN CREATED   >>>>> STOP !!"
    exit
  fi

done

done
