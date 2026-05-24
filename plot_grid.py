import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import xarray as xr
import numpy as np

# Load data
varname = "SMOIS"
dset = "~/DATA/droughtSystemv2/SOILW_layer1_1980-2024_mon.nc"
dset = "~/DATA/droughtSystemv2/updates/SMOIS1_d02_202501.nc"
dset = "smois_mask1.nc"
ds = xr.open_dataset(dset)
# lon_name="longitude"
# lat_name="latitude"
lon_name = "lon"
lat_name = "lat"
pet = ds[varname][0, :, :]

# Plot
fig, ax = plt.subplots(figsize=(10, 8), subplot_kw={"projection": ccrs.PlateCarree()})


# Create meshgrid for nan locations
lon, lat = ds[lon_name], ds[lat_name]
lon2d, lat2d = np.meshgrid(lon.values, lat.values)
nan_mask = np.isnan(pet.values)


ax.set_extent(
    [
        float(lon.min()),
        float(lon.max()),
        float(lat.min()),
        float(lat.max()),
    ],
    crs=ccrs.PlateCarree(),
)

im = ax.pcolormesh(
    lon, lat, pet, transform=ccrs.PlateCarree(), cmap="YlOrRd", shading="auto"
)

ax.add_feature(cfeature.COASTLINE, linewidth=0.8)
ax.add_feature(cfeature.BORDERS, linewidth=0.5, linestyle="--")
ax.gridlines(draw_labels=True, linewidth=0.4, linestyle=":", color="gray")


# ax.scatter(
#     lon2d[nan_mask],
#     lat2d[nan_mask],
#     transform=ccrs.PlateCarree(),
#     s=1,
#     c="royalblue",
#     marker=".",
#     alpha=0.6,
#     label="NaN",
# )


cbar = plt.colorbar(im, ax=ax, orientation="vertical", pad=0.02, shrink=0.85)
cbar.set_label(varname, fontsize=11)

ax.set_title(
    f"SMOIS",
    fontsize=12,
)

plt.tight_layout()
plt.savefig("pet_timestep0.png", dpi=150, bbox_inches="tight")
plt.close()
ds.close()
print("Saved: pet_timestep0.png")
