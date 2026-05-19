import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import xarray as xr
import numpy as np

# Load data
ds = xr.open_dataset("/home/athippp/DATA/droughtSystemv2/updates/T2MAX_d02_202501.nc")
pet = ds["T2MAX"].isel(Time=0)

# Plot
fig, ax = plt.subplots(figsize=(10, 8), subplot_kw={"projection": ccrs.PlateCarree()})


# Create meshgrid for nan locations
lon2d, lat2d = np.meshgrid(ds.lon.values, ds.lat.values)
nan_mask = np.isnan(pet.values)


ax.set_extent(
    [
        float(ds.lon.min()),
        float(ds.lon.max()),
        float(ds.lat.min()),
        float(ds.lat.max()),
    ],
    crs=ccrs.PlateCarree(),
)

im = ax.pcolormesh(
    ds.lon, ds.lat, pet, transform=ccrs.PlateCarree(), cmap="YlOrRd", shading="auto"
)

ax.add_feature(cfeature.COASTLINE, linewidth=0.8)
ax.add_feature(cfeature.BORDERS, linewidth=0.5, linestyle="--")
ax.gridlines(draw_labels=True, linewidth=0.4, linestyle=":", color="gray")


ax.scatter(
    lon2d[nan_mask],
    lat2d[nan_mask],
    transform=ccrs.PlateCarree(),
    s=1,
    c="royalblue",
    marker=".",
    alpha=0.6,
    label="NaN",
)


cbar = plt.colorbar(im, ax=ax, orientation="vertical", pad=0.02, shrink=0.85)
cbar.set_label("PET (mm/day)", fontsize=11)

time_val = ds.Time.values[0]
ax.set_title(
    f"Reference Evapotranspiration (Hargreaves)\nTime step 0 — {str(time_val)[:10]}",
    fontsize=12,
)

plt.tight_layout()
plt.savefig("pet_timestep0.png", dpi=150, bbox_inches="tight")
plt.close()
ds.close()
print("Saved: pet_timestep0.png")
