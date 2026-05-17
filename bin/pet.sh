#!/bin/bash
set -eux

fmin=$1
fmax=$2
petfile=$3

ofile=$petfile

ncl_file=pet_$(basename $petfile .nc).ncl
cat > $ncl_file << EOF
;========================
; Hargreaves PET calculation for $fmin and $fmax
;========================

fmin = addfile("$fmin","r")
fmax = addfile("$fmax","r")

;---Time variables
time = fmin->Time
print(time@units)     ; should print "days since 2026-01-01 00:00:00"
print(time@calendar)  ; should print "proleptic_gregorian"
ntim = dimsizes(time)
TIME = cd_calendar(time, 0)
yyyy = toint(TIME(:,0))
mm   = toint(TIME(:,1))
dd   = toint(TIME(:,2))
jday = day_of_year(yyyy, mm, dd)

;---Latitude array
lat = tofloat(fmin->lat)
lon = tofloat(fmin->lon)
nlat = dimsizes(lat)
mlon = dimsizes(lon)
lat2d = conform_dims( (/nlat,mlon/), lat, 0)

;---Radext
radunit = 0
radext = radext_fao56(jday, lat2d, radunit)
radext = where(radext.lt.0.001, 0.0, radext)

;---Daily min & max
tmin = fmin->T2MIN
tmax = fmax->T2MAX

;---Hargreaves PET
refevt = refevt_hargreaves_fao56(tmin, tmax, radext, (/1,0,0/))

;---Write NetCDF
foutnc = "$ofile"
system("rm -f " + foutnc)
out = addfile(foutnc, "c")
out->pet = refevt
EOF
$NCL $ncl_file
rm $ncl_file
echo "✅ Finished $petfile"

