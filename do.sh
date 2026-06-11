set -xe

#cdo -setmisstoc,0 -setctomiss,1 -setmisstoc,2 ~/DATA/droughtSystemv2/rain_desert_mask.nc _mask.nc 
#for i in spi spei; do 
#for scl in 1 3 6 12; do
#    scl2=$(printf "%02d" $scl)
#    icaps=$(echo $i | tr '[:lower:]' '[:upper:]')
#    mkdir -p drought2/${i}/${scl}/
#    cdo -setreftime,1900-01-01,00:00:00,days -mul \
#        ~/cylc-run/DroughtSystemv2/run1/work/20251201T0000Z/${i}_scl${scl2}/${icaps}${scl}.nc \
#        ~/DATA/droughtSystemv2/rain_valid_mask.nc _out.nc
#
#   cdo -ifthenelse _mask.nc _out.nc -addc,-9999 -mulc,0 _out.nc drought2/${i}/${scl}/${i}_${scl}.nc
#
#    cp  ~/DATA/droughtSystemv2/rain_desert_mask.nc \
#        drought2/${i}/${scl}/${i}_mask.nc
#done
#done


#cdo -setmisstoc,0 -setctomiss,1 -setmisstoc,2 ~/DATA/droughtSystemv2/sm_desert_mask.nc _mask.nc 
#
#for scl in 1 3 6 12; do
#    scl2=$(printf "%02d" $scl)
#    icaps=$(echo $i | tr '[:lower:]' '[:upper:]')
#    mkdir -p drought2/smi/${scl}/
#    cdo -setreftime,1900-01-01,00:00:00,days -mul \
#        ~/cylc-run/DroughtSystemv2/run1/work/20251201T0000Z/smi_scl${scl2}/SMI${scl}.nc \
#        ~/DATA/droughtSystemv2/sm_valid_mask.nc _out.nc
#
#    cdo -ifthenelse _mask.nc _out.nc -addc,-9999 -mulc,0 _out.nc drought2/smi/${scl}/smi_${scl}.nc
#
#    cp ~/DATA/droughtSystemv2/sm_desert_mask.nc \
#        drought2/smi/${scl}/smi_mask.nc
#done


cdo -setmisstoc,0 -setctomiss,1 -setmisstoc,2 ~/DATA/droughtSystemv2/ndvi_valid_mask.nc _mask.nc
cdo -ifthenelse _mask.nc ndvi_unmasked.nc -addc,-9999 -mulc,0 ndvi_unmasked.nc drought2/ndvi/ndvi.nc