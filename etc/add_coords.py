import typer
import xarray as xr
import numpy as np
import pandas as pd
from pathlib import Path
from glob import glob

app = typer.Typer()


@app.command()
def main(ifile: str, gfile: str, odir: str):
    ds = xr.open_dataset(ifile)
    ds_grid = xr.open_dataset(gfile)
    xlat = ds_grid["XLAT_M"].squeeze()[:, 0]
    xlon = ds_grid["XLONG_M"].squeeze()[0, :]
    ds = ds.assign_coords(
        south_north=xlat.values,
        west_east=xlon.values,
    )
    ds.coords["south_north"].attrs["units"] = "degrees_north"
    ds.coords["west_east"].attrs["units"] = "degrees_east"
    for var in ds.data_vars:
        ds[var].encoding.pop("coordinates", None)

    time_str = ds["Times"].values[0].decode("utf-8")  # '2024-06-01_00:00:00'
    time_dt = pd.to_datetime(time_str, format="%Y-%m-%d_%H:%M:%S")
    ds = ds.assign_coords(Time=("Time", [time_dt]))
    ofile = Path(odir) / Path(ifile).name
    ds.to_netcdf(ofile)


if __name__ == "__main__":
    app()
