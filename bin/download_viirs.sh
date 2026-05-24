#!/bin/bash
set -ex
set -o pipefail

wget -r -np -nH --cut-dirs=6 \
    -A "VIIRS-Land_*_${syyyy}${smm}*.nc" \
    https://www.ncei.noaa.gov/data/land-normalized-difference-vegetation-index/access/${syyyy}/


