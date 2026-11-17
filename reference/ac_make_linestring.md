# Make spatial transit data into an sf linestring

Turns the GPS locations and origin and destination points into sf
linestrings. This function is mainly used internally. Try using
ac_make_transit_spatial() instead. Also does some cleaning to remove
points at 0, 0 and points that are more than 100 km from the nearest
other points. This function is pretty slow. I recommend that you use it
every time you get transit measurements, but it can be skipped if you
want to save time

## Usage

``` r
ac_make_linestring(lon, lat, noise_distance = 100)
```

## Arguments

- lon:

  vector of numeric longitude values

- lat:

  vector of numeric latitude values

- noise_distance:

  Distance in km to specify how far apart GPS points can be to remain in
  the sf linestring. See details

## Value

sf object of linestring or point

## Details

Points that are greater than `noise_distance` from the points before and
after themselves will be removed from the linestring. This tends to
remove erroneous points although it may remove some correct points. The
default is set to 100 km. If you do not want points removed for their
distance set the `noise_distance` to something really high.
