#/bin/bash

set -ex

mkdir -p ~/DATA/droughtSystemv2/masks/AP

#cdo --reduce_dim -setvar,mask -addc,100 -setctomiss,1 ~/DATA/droughtSystemv2/updates/SMOIS1_d02_202605.nc _out1.nc 
#cdo -div _out1.nc  _out1.nc _out2.nc
#cdo -remapbil,~/DATA/droughtSystemv2/hist/AP/SOILW_layer1_1980-2024_mon.nc _out2.nc ~/DATA/droughtSystemv2/masks/AP/land_mask.nc

#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/AP/ERA5_historical_RAINNC_monthly_1980-2024.nc ~/DATA/droughtSystemv2/masks/AP/rain_climatology.nc
cdo -mul ~/DATA/droughtSystemv2/masks/AP/land_mask.nc -setvar,mask -ltc,0.12 ~/DATA/droughtSystemv2/masks/AP/rain_climatology.nc ~/DATA/droughtSystemv2/masks/AP/rain_desert_mask.nc



#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/AP/SOILW_layer1_1980-2024_mon.nc ~/DATA/droughtSystemv2/masks/AP/sm_climatology.nc
#cdo -setvar,mask -ltc,0.065 ~/DATA/droughtSystemv2/masks/AP/sm_climatology.nc ~/DATA/droughtSystemv2/masks/AP/sm_desert_mask.nc


# NDVI
#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/AP/viirs_ndvi_1982-2025_AP_mon.nc ~/DATA/droughtSystemv2/masks/AP/ndvi_climatology.nc
#cdo --reduce_dim  -addc,1000 -seltimestep,-1 ~/DATA/droughtSystemv2/hist/AP/viirs_ndvi_1982-2025_AP_mon.nc _out.nc 
#cdo -div _out.nc _out.nc _out1.nc 
#cdo -setvar,mask -ltc,0.13 -mul _out1.nc ~/DATA/droughtSystemv2/masks/AP/ndvi_climatology.nc ~/DATA/droughtSystemv2/masks/AP/ndvi_desert_mask.nc



# MENA

#mkdir -p ~/DATA/droughtSystemv2/masks/MENA

#cdo --reduce_dim -setvar,mask -addc,100 -setctomiss,1 ~/DATA/droughtSystemv2/updates/SMOIS1_d01_202605.nc _out1.nc 
#cdo -div _out1.nc  _out1.nc _out2.nc
#cdo -remapbil,~/DATA/droughtSystemv2/hist/MENA/SOILL_1980-2024_mon.nc _out2.nc ~/DATA/droughtSystemv2/masks/MENA/land_mask.nc

#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/MENA/ERA5_historical_RAIN_mon_1980-2024.nc ~/DATA/droughtSystemv2/masks/MENA/rain_climatology.nc
cdo -mul ~/DATA/droughtSystemv2/masks/MENA/land_mask.nc -setvar,mask -ltc,0.12 ~/DATA/droughtSystemv2/masks/MENA/rain_climatology.nc ~/DATA/droughtSystemv2/masks/MENA/rain_desert_mask.nc



#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/MENA/SOILL_1980-2024_mon.nc ~/DATA/droughtSystemv2/masks/MENA/sm_climatology.nc
#cdo -setvar,mask -ltc,0.065 ~/DATA/droughtSystemv2/masks/MENA/sm_climatology.nc ~/DATA/droughtSystemv2/masks/MENA/sm_desert_mask.nc

#cdo --reduce_dim -seltimestep,1 -timmean ~/DATA/droughtSystemv2/hist/MENA/viirs_ndvi_1982-2025_MENA_mon.nc ~/DATA/droughtSystemv2/masks/MENA/ndvi_climatology.nc
#cdo --reduce_dim  -addc,1000 -seltimestep,-1 ~/DATA/droughtSystemv2/hist/MENA/viirs_ndvi_1982-2025_MENA_mon.nc _out.nc 
#cdo -div _out.nc _out.nc _out1.nc 
#cdo -setvar,mask -ltc,0.13 -mul _out1.nc ~/DATA/droughtSystemv2/masks/MENA/ndvi_climatology.nc ~/DATA/droughtSystemv2/masks/MENA/ndvi_desert_mask.nc

