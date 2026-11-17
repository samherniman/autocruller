# Get transit data from indoorco2map.org

Get transit data from indoorco2map.org

## Usage

``` r
ac_get_co2_transit(
  transit_url = "https://indoorco2map.com/chartdata/IndoorCO2MapTransitData.json"
)
```

## Arguments

- transit_url:

  URL to request transit data from the default should work for now

## Value

A dataframe with up to date co2 transit measurements

## Examples

``` r
if (FALSE) { # \dontrun{
ac_df <- ac_get_co2_transit()
} # }
```
