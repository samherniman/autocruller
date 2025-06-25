
<!-- README.md is generated from README.Rmd. Please edit that file -->

# autocruller

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/autocruller)](https://CRAN.R-project.org/package=autocruller)
[![R-CMD-check](https://github.com/samherniman/autocruller/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/samherniman/autocruller/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Auto **ˈɔːtəʊ** - [short for automobile, a
car](https://en.wiktionary.org/wiki/auto) Cruller **ˈkrʌl ər** [a pastry
roll or bun](https://en.wiktionary.org/wiki/cruller)

autocruller - car bun

{autocruller} allows one to download, manipulate and visualize
CO<sup>2</sup> readings from the
[indoorco2map.com](https://indoorco2map.com/?lat=51.16570&lng=10.45150&zoom=6.00)
dataset.

Please support that project by contributing CO<sup>2</sup> readings,
reporting bugs, telling your friends and financially supporting it (if
you feel inclined).

## Carbon Dioxide is important, Y’all

## Never used R before?

Read
[this](https://rstudio-education.github.io/hopr/starting.html#starting)

## Installation

You can install the development version of autocruller from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("samherniman/autocruller")
```

## Get started

Download the latest data with `ac_get_co2()`

``` r
library(autocruller)

ac_df <- ac_get_co2()
```

That will give you a dataframe with all the current CO<sup>2</sup>
measurements.

``` r
dplyr::glimpse(ac_df)
#> Rows: 10,623
#> Columns: 19
#> $ .id            <int> 1, 2, 3, 4, 4, 4, 4, 5, 6, 7, 8, 9, 10, 11, 12, 12, 12,…
#> $ combined_id    <chr> "n_10000066104", "n_10000660271", "n_10013427033", "n_1…
#> $ osmtag         <chr> "supermarket", "fast_food", "supermarket", "greengrocer…
#> $ osmkey         <chr> "shop", "amenity", "shop", "shop", "shop", "shop", "sho…
#> $ countryid      <chr> "DEU", "USA", "DEU", "DEU", "DEU", "DEU", "DEU", "AUT",…
#> $ countryname    <chr> "Germany", "United States of America", "Germany", "Germ…
#> $ nuts3id        <chr> "DEA1B", "", "DE712", "DEA2C", "DEA2C", "DEA2C", "DEA2C…
#> $ nwrname        <chr> "ALDI Süd", "Naya", "EDEKA Langanki", "Hofladen Schmitz…
#> $ lat            <dbl> 51.57180, 40.75168, 50.14087, 50.77669, 50.77669, 50.77…
#> $ lon            <dbl> 6.241554, -73.995968, 8.753173, 6.930577, 6.930577, 6.9…
#> $ startTime      <dbl> 1.728744e+12, 1.746378e+12, 1.730192e+12, 1.732121e+12,…
#> $ ppmavg         <dbl> 1795.4000, 613.8235, 579.3333, 814.4000, 608.6000, 832.…
#> $ co2array       <list> <1623, 1699, 1745, 1805, 1836, 1831, 1854, 1860, 1842,…
#> $ ventilation    <chr> "False", "False", "False", "False", "False", "False", "…
#> $ openwindows    <chr> "False", "False", "False", "False", "False", "False", "…
#> $ occupancylevel <chr> "undefined", "undefined", "undefined", "undefined", "un…
#> $ customnotes    <chr> "", "", "", "", "", "", "", "", "", "", "", "", "", "Ha…
#> $ co2atlaskey    <chr> "shop", "dining_drinking", "shop", "other", "other", "o…
#> $ date           <dttm> 2024-10-12 15:32:07, 2025-05-04 17:55:28, 2024-10-29 0…
```

If you want the co2arrays to be in long format, you can do this:

``` r
ac_df_long <- tidyr::unnest_longer(ac_df, co2array) 
```

## Make a graph

``` r
pak::pak("tidyplots")
```

You can compare averages with the wide format data

``` r
library(tidyplots)

types_c <- c(
  "arts_centre","events_centre", "cinema",
  "social_facility", "theatre", "music_venue",
  "music","nightclub" , "social_centre", "concert_hall"
)
ac_df |> 
  dplyr::filter(osmtag %in% types_c) |> 
tidyplot(
         x = ventilation, 
         y = ppmavg,
         color = ppmavg) |> 
  add_data_points_beeswarm(size = 3) |> 
  adjust_y_axis(transform = "log2") |> 
  adjust_size(width = NA, height = NA, unit = "cm") |> 
  adjust_font(fontsize = 16) |> 
  adjust_x_axis_title("Ventilation system on?") |> 
  adjust_y_axis_title("CO2 ppm average") |> 
  remove_legend() |> 
  adjust_title("CO2 Averages at music venues") |> 
  adjust_caption("Data from indoorCO2map.com")
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

And track things over time with the long format data

``` r
ac_df_long |> 
  dplyr::filter(.id == 127) |>
  dplyr::mutate(
    measurement_sequence = dplyr::row_number()
  ) |> 
tidyplot(
         x = measurement_sequence, 
         y = co2array,
         color = co2array) |> 
  add_data_points() |> 
  adjust_size(width = NA, height = NA, unit = "cm") |>
  adjust_font(fontsize = 16) |>
  adjust_x_axis_title("Time") |> 
  adjust_y_axis_title("CO2 ppm") |> 
  remove_legend() |> 
  adjust_title("CO2 measurements at recording 127") |> 
  adjust_caption("Data from indoorCO2map.com")
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />
