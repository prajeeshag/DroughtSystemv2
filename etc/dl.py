import shutil
from pathlib import Path

import cdsapi
import typer
import calendar

c = cdsapi.Client()

app = typer.Typer()

@app.command()
def prs(year: int, month: int, day: int = 31):
    mon = f"{month:02d}"
    output = f"{year}_{mon}_prs.grib"
    ndays = calendar.monthrange(year, month)[1]
    ndays = min(ndays, day)
    days = [f"{day}" for day in range(1, ndays + 1)]
    if Path(output).exists():
        print(output)
        return
    c.retrieve(
        "reanalysis-era5-pressure-levels",
        {
            "product_type": "reanalysis",
            "format": "grib",
            "variable": [
                "geopotential",
                "temperature",
                "u_component_of_wind",
                "v_component_of_wind",
                "relative_humidity",
                "specific_humidity",
            ],
            "pressure_level": [
                "1",
                "2",
                "3",
                "5",
                "7",
                "10",
                "20",
                "30",
                "50",
                "70",
                "100",
                "125",
                "150",
                "175",
                "200",
                "225",
                "250",
                "300",
                "350",
                "400",
                "450",
                "500",
                "550",
                "600",
                "650",
                "700",
                "750",
                "775",
                "800",
                "825",
                "850",
                "875",
                "900",
                "925",
                "950",
                "975",
                "1000",
            ],
            "year": f"{year}",
            "month": f"{mon}",
            "day": days,
            "time": [
                "00:00",
                "06:00",
                "12:00",
                "18:00",
            ],
        },
        "_prs_tmp.grib",
    )

    shutil.move("_prs_tmp.grib", output)


@app.command()
def sfc(year: int, month: int):
    mon = f"{month:02d}"
    ndays = calendar.monthrange(year, month)[1]
    days = [f"{day}" for day in range(1, ndays + 1)]

    output = f"{year}_{mon}_sfc.grib"

    if Path(output).exists():
        print(output)
        return

    c = cdsapi.Client()

    c.retrieve(
        "reanalysis-era5-single-levels",
        {
            "product_type": "reanalysis",
            "format": "grib",
            "variable": [
                "10m_u_component_of_wind",
                "10m_v_component_of_wind",
                "2m_dewpoint_temperature",
                "2m_temperature",
                "land_sea_mask",
                "mean_sea_level_pressure",
                "sea_ice_cover",
                "sea_surface_temperature",
                "skin_temperature",
                "snow_density",
                "snow_depth",
                "soil_temperature_level_1",
                "soil_temperature_level_2",
                "soil_temperature_level_3",
                "soil_temperature_level_4",
                "surface_pressure",
                "geopotential",
                "volumetric_soil_water_layer_1",
                "volumetric_soil_water_layer_2",
                "volumetric_soil_water_layer_3",
                "volumetric_soil_water_layer_4",
            ],
            "year": str(year),
            "month": mon,
            "day": days,
            "time": [
                "00:00",
                "06:00",
                "12:00",
                "18:00",
            ],
        },
        "_tmp_sfc.grib",
    )

    shutil.move("_tmp_sfc.grib", output)


if __name__ == "__main__":
    app()
