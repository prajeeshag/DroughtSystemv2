set -xe

for region in AP MENA; do
    iregion=$(echo $region | tr '[:upper:]' '[:lower:]')
    land_mask=~/DATA/droughtSystemv2/masks/${region}/land_mask.nc
    if [[ "$region" == "AP" ]]; then
        sellonlatbox="-sellonlatbox,28.1,60.8,8.2,33.5"
    else
        sellonlatbox="-sellonlatbox,-26.5,75.5,-6.5,45"
    fi

    for scl in 1 3 6 12; do
        scl2=$(printf "%02d" $scl)
        desert_mask=~/DATA/droughtSystemv2/masks/${region}/rain_desert_mask.nc
        for i in spi spei; do 
            icaps=$(echo $i | tr '[:lower:]' '[:upper:]')

            odir=drought2/${region}/${i}/${scl}/
            mkdir -p $odir
            cdo -setreftime,1900-01-01,00:00:00,days -mul \
                ~/cylc-run/DroughtSystemv2/run1/work/20260501T0000Z/${i}_${iregion}_scl${scl2}/${icaps}${scl}.nc \
                $land_mask _out.nc
            cdo $sellonlatbox -ifthenelse $desert_mask -addc,-9999 -mulc,0 _out.nc _out.nc $odir/${i}_${scl}.nc
        done

        i=smi
        icaps=$(echo $i | tr '[:lower:]' '[:upper:]')
        odir=drought2/${region}/${i}/${scl}/
        desert_mask=~/DATA/droughtSystemv2/masks/${region}/sm_desert_mask.nc
        mkdir -p $odir

        cdo -setreftime,1900-01-01,00:00:00,days -mul \
            ~/cylc-run/DroughtSystemv2/run1/work/20260501T0000Z/smi_${iregion}_scl${scl2}/SMI${scl}.nc \
            $land_mask _out.nc

        cdo $sellonlatbox -ifthenelse $desert_mask -addc,-9999 -mulc,0 _out.nc _out.nc $odir/smi_${scl}.nc
    done
done


# cdo -setmisstoc,0 -setctomiss,1 -setmisstoc,2 ~/DATA/droughtSystemv2/ndvi_valid_mask.nc _mask.nc
# cdo -ifthenelse _mask.nc ndvi_unmasked.nc -addc,-9999 -mulc,0 ndvi_unmasked.nc drought2/ndvi/ndvi.nc

# mv ~/cylc-run/viirs/run1/work/20260501T0000Z/ndvi_AP/ndvi.nc drought2/AP/ndvi/ndvi.nc
# mv ~/cylc-run/viirs/run1/work/20260501T0000Z/ndvi_MENA/ndvi.nc drought2/MENA/ndvi/ndvi.nc