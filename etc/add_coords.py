import typer
import xarray as xr
import pandas as pd
from pathlib import Path

app = typer.Typer()


@app.command()
def main(ifile: str, gfile: str, odir: str, time_string: str = ""):
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
        ds[var].attrs.pop("coordinates", None)

    # delete var XLAT and XLONG if exists
    if "XLAT" in ds:
        ds = ds.drop(["XLAT", "XLONG"])

    if time_string:
        time_str = time_string
    else:
        time_str = ds["Times"].values[0].decode("utf-8")  # '2024-06-01_00:00:00'
    time_dt = pd.to_datetime(time_str, format="%Y-%m-%d_%H:%M:%S")
    ds = ds.assign_coords(Time=("Time", [time_dt]))
    ds = ds.assign_coords(Times=("Times", [time_dt]))
    ofile = Path(odir) / Path(ifile).name
    ds.to_netcdf(ofile)


if __name__ == "__main__":
    app()
