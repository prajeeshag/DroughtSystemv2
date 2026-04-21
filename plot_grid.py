import cartopy.crs as ccrs
import matplotlib


matplotlib.use("Agg")
import matplotlib.pyplot as plt
import xarray as xr

# Load dataset
ds: xr.Dataset = xr.open_dataset(
    "/project/k10036/hari/Climate_AP/WRF/ERA5/historical/T2_MEAN_ERA5_historical_daily.nc"
)

# Extract coordinates
lats = ds["lat"].values
lons = ds["lon"].values

# Define your box (change these)
lat_min: float = 10.0
lat_max: float = 20.0
lon_min: float = 50.0
lon_max: float = 60.0

# Create figure
fig = plt.figure(figsize=(8, 6))
ax = plt.axes(projection=ccrs.PlateCarree())

# Plot domain extent
ax.set_extent([lons.min(), lons.max(), lats.min(), lats.max()])

# Optional: draw grid boundary (just corners)
ax.scatter(lons, [lats.min()] * len(lons), s=1)
ax.scatter(lons, [lats.max()] * len(lons), s=1)
ax.scatter([lons.min()] * len(lats), lats, s=1)
ax.scatter([lons.max()] * len(lats), lats, s=1)

# Draw the box
ax.plot(
    [lon_min, lon_max, lon_max, lon_min, lon_min],
    [lat_min, lat_min, lat_max, lat_max, lat_min],
    color="red",
    linewidth=2,
    transform=ccrs.PlateCarree(),
)

# Add coastlines
ax.coastlines()

plt.savefig("grid.png")
