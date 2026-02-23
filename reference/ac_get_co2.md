# Get data from indoorco2map.org

Get data from indoorco2map.org

## Usage

``` r
ac_get_co2(x = "web")
```

## Arguments

- x:

  Character specifying which dataset to download one of c("web",
  "download", "transit")

## Value

A dataframe with up to date co2 measurements

## Examples

``` r
if (FALSE) { # \dontrun{
# Get building data with one of three options
ac_df <- ac_get_co2()
ac_df <- ac_get_co2("web")
ac_df <- ac_get_co2("download")

# Get transit data
ac_df <- ac_get_co2("transit")
} # }
```
