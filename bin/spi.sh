#!/bin/bash
set -eux

# ==========================================================
# Step 9. SPI Calculation
# ==========================================================

INPUT_FILE=$1
OUTPUT_FILE=$2
spi=$3
scale=$4

start_year=1980

lon_name="lon"
lat_name="lat"
if [ "$spi" = "smi" ]; then
  lon_name="longitude"
  lat_name="latitude"
fi

long_name="Standardized Precipitation Index (${scale})"
if [ "$spi" = "spei" ]; then
  long_name="Standardized Precipitation Evapotranspiration Index (${scale})"
elif [ "$spi" = "smi" ]; then
  long_name="Standardized Soil Moisture Index (${scale})"
  spi=spi
fi

rscript=${INPUT_FILE}.R

cat > $rscript <<EOF

# ==========================================================
# $long_name Calculation
# ==========================================================

# ---- Load libraries ----
library(ncdf4)
library(SPEI)
library(doParallel)
library(foreach)

# ---- SPI Parameters ----
SPI_scale <- $scale
REF_START <- c($start_year, 1)
REF_END   <- c(2015, 12)
Start_date <- c($start_year, 1)
max_cores <- min(12, parallel::detectCores() - 2)
cat("Using", max_cores, "cores\n")

fpath="${INPUT_FILE}"
fname <- basename(fpath)
out_file="${OUTPUT_FILE}"

cat("\nProcessing:", fname, "\n")

nc <- nc_open(fpath)
pre.lon <- ncvar_get(nc, "$lon_name")
pre.lat <- ncvar_get(nc, "$lat_name")
pre.raw <- ncvar_get(nc, "RAINNC")
nc_close(nc)

pre.lon[pre.lon > 180] <- pre.lon[pre.lon > 180] - 360

nt <- dim(pre.raw)[3]
nlon <- length(pre.lon)
nlat <- length(pre.lat)
pre <- matrix(pre.raw, nrow = nt, ncol = nlon * nlat, byrow = TRUE)
rm(pre.raw); gc()

cl <- makeCluster(max_cores)
registerDoParallel(cl)

SPI_list <- foreach(i = 1:ncol(pre), .packages = "SPEI") %dopar% {
  ts_data <- pre[, i]
  fit <- $spi(ts(ts_data, start = Start_date, frequency = 12), scale = SPI_scale)
  as.numeric(fit\$fitted)
}

stopCluster(cl)

SPI_matrix <- do.call(cbind, SPI_list)
rm(SPI_list); gc()

SPI_array <- array(NA, dim = c(nlon, nlat, nt))
for (t in 1:nt) {
  SPI_array[,,t] <- matrix(SPI_matrix[t,], nrow = nlon, ncol = nlat)
}
rm(SPI_matrix); gc()

SPI_array[is.infinite(SPI_array)] <- -4

londim <- ncdim_def("lon", "degrees_east", pre.lon)
latdim <- ncdim_def("lat", "degrees_north", pre.lat)
timedim <- ncdim_def("time", "months since ${start_year}-01-01 00:00:00", 0:(nt - 1))
SPI_def <- ncvar_def("$spi", "$long_name",
                     list(londim, latdim, timedim),
                     missval = NA, prec = "single")

ncout <- nc_create(out_file, SPI_def, force_v4 = TRUE)
ncvar_put(ncout, SPI_def, SPI_array)
nc_close(ncout)

cat("Finished:", out_file, "\n")
EOF

Rscript $rscript
