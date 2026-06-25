import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import xarray as xr

idir = "drought2"

for var in ["spi", "smi", "spei", "ndvi"]:
    for region in ["MENA", "AP"]:
        scls = ["1", "3", "6", "12"] if var != "ndvi" else [""]
        for scl in scls:
            if scl:
                dset_name = f"{region}/{var}/{scl}/{var}_{scl}.nc"
                figname = f"{region}_{var}_{scl}"
            else:
                dset_name = f"{region}/{var}/{var}.nc"
                figname = f"{region}_{var}"
            print(dset_name)
            ds = xr.open_dataset(f"{idir}/{dset_name}", decode_times=False)

            # Plot
            fig, ax = plt.subplots(figsize=(10, 8))

            ds[var][-1, :, :].plot(
                ax=ax,
                cmap="RdYlGn",
                vmin=-3,
                vmax=3,
            )

            ax.set_title(dset_name)

            plt.tight_layout()
            plt.savefig(f"{figname}.png", dpi=150, bbox_inches="tight")
            plt.close()
            print(f"Saved: {figname}.png")
