# Unnest a co2 df list-column into rows

Unnest a co2 df list-column into rows

## Usage

``` r
ac_unnest_longer(x)
```

## Arguments

- x:

  a dataframe from ac_get_co2()

## Value

a dataframe in long format

## Examples

``` r
if (FALSE) { # \dontrun{
ac_df <- ac_get_co2("download") |>
ac_unnest_longer()
} # }
```
