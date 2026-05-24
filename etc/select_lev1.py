import typer
import xarray as xr
import pandas as pd
from pathlib import Path

app = typer.Typer()


@app.command()
def main(ifile: str, ofile: str):
    ds = xr.open_dataset(ifile)
    ds = ds["SMOIS"][:, 0, :, :]
    ds.to_netcdf(ofile)


if __name__ == "__main__":
    app()
