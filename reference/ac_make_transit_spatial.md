# Turn transit measurements into an sf spatial dataframe

Turns the GPS locations, origin, and destination points into sf
linestrings. Also does some cleaning to remove points at 0, 0 and points
that are more than 100 km from the nearest other points. This function
is pretty slow. I recommend that you use it every time you get transit
measurements, but it can be skipped if you want to save time. The
linestrings are stored in the `geometry` column

## Usage

``` r
ac_make_transit_spatial(x, ...)
```

## Arguments

- x:

  A dataframe from ac_get_co2_transit()

- ...:

  Parameters passed to ac_make_linestring

## Value

sf dataframe

## Examples

``` r
if (FALSE) { # \dontrun{
ac_get_co2_transit() |>
  ac_make_transit_spatial()
} # }
```
