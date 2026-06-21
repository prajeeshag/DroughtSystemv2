#!/bin/bash
set -eux

# ==========================================================
# Step 9. SPI Calculation
# ==========================================================
start_year=1983
INPUT_FILE=$1
OUTPUT_FILE=$2
scale=$3

spi=spi

lon_name="lon"
lat_name="lat"

spi_name="sni"

long_name="Standardized NDVI Index (${scale})"

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
Start_date <- c(2015, 1)
max_cores <- min(12, parallel::detectCores() - 2)
cat("Using", max_cores, "cores\n")

fpath="${INPUT_FILE}"
fname <- basename(fpath)
out_file="${OUTPUT_FILE}"

cat("\nProcessing:", fname, "\n")

nc <- nc_open(fpath)
pre.lon <- ncvar_get(nc, "$lon_name")
pre.lat <- ncvar_get(nc, "$lat_name")
pre.raw <- ncvar_get(nc, "ndvi")
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
SPI_def <- ncvar_def("$spi_name", "$long_name",
                     list(londim, latdim, timedim),
                     missval = NA, prec = "single")

ncout <- nc_create(out_file, SPI_def, force_v4 = TRUE)
ncvar_put(ncout, SPI_def, SPI_array)
nc_close(ncout)

cat("Finished:", out_file, "\n")
EOF

Rscript $rscript
