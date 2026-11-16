#' Get transit data from indoorco2map.org
#'
#' @param transit_url URL to request transit data from the default should work for now
#'
#' @returns A dataframe with up to date co2 transit measurements
#'
#' @export
#' @examples
#' \dontrun{
#' ac_df <- ac_get_co2_transit()
#' }
ac_get_co2_transit <- function(transit_url = "https://indoorco2map.com/chartdata/IndoorCO2MapTransitData.json") {
  originLongitude <-
    gpsLongitudes <-
    destinationLongitude <-
    originLatitude <-
    gpsLatitudes <-
    destinationLatitude <-
    startOfMeasurement <-
    sensorType <-
    NULL
  j_df <-
      transit_url |>
      jsonlite::fromJSON() |>
      dplyr::rowwise() |>
      dplyr::mutate(
        gpsLongitudes = list(c(originLongitude, unlist(gpsLongitudes), destinationLongitude)),
        gpsLatitudes = list(c(originLatitude, unlist(gpsLatitudes), destinationLatitude)),
        date = lubridate::ymd_hms(startOfMeasurement),
        sensorType = as.factor(sensorType)
      )

  return(j_df)
}

#' Turn transit measurements into an sf spatial dataframe
#'
#' @param x A dataframe from ac_get_co2_transit()
#' @param ... Parameters passed to ac_make_linestring
#'
#' @returns sf dataframe
#' @export
#'
#' @description
#' Turns the GPS locations, origin, and destination points into sf linestrings.
#' Also does some cleaning to remove points at 0, 0 and points that are more than
#' 100 km from the nearest other points. This function is pretty slow. I recommend
#' that you use it every time you get transit measurements, but it can be skipped
#' if you want to save time. The linestrings are stored in the `geometry` column
#'
#' @examples
#' \dontrun{
#' ac_get_co2_transit() |>
#'   ac_make_transit_spatial()
#' }
ac_make_transit_spatial <- function(x, ...) {
  gpsLongitudes <- gpsLatitudes <-  NULL
  x |>
  dplyr::rowwise() |>
  dplyr::mutate(
  geometry = sf::st_sfc(
    ac_make_linestring(gpsLongitudes, gpsLatitudes, ...), crs = "4326"
  )
  ) |>
  sf::st_as_sf(crs = 4326)
}

#' Turn a CO2 json into a dataframe
#'
#' @param x A json
#'
#' @returns a dataframe
json_to_df <- function(x) {
  timestampArray <-
    co2Array <-
    longitudeArray <-
    latitudeArray <-
    startTime <-
    uid <-
    ppmAvg <-
    NULL
  x |>
    dplyr::mutate(
      timestampArray = split_to_numeric(timestampArray) |> range01() |> paste(collapse = ";"),
      # mod_loess = list(train_loess(co2_vec = co2Array, time_vec = timestampArray)),
      # co2Array = list(split_to_numeric(co2Array)),
      co2Array = stringr::str_replace_all(co2Array, ";", ","),
      longitudeArray = stringr::str_remove_all(longitudeArray, "(0;|0$)") |>
        stringr::str_replace_all(",", "\\.") |>
        stringr::str_replace_all(";", ",") ,
      latitudeArray = stringr::str_remove_all(latitudeArray, "(0;|0$)") |>
        stringr::str_replace_all(",", "\\.") |>
        stringr::str_replace_all(";", ","),
      date = stringr::str_sub(startTime, end = -4) |>
        as.numeric() |>
        as.POSIXct()
    ) |>
    tidyr::separate_longer_delim(cols = c(co2Array), delim = ",") |>
    dplyr::distinct() |>
    dplyr::mutate(
      long_first = stringr::str_split_i(longitudeArray, ",", 1) |> as.numeric(),
      lat_first = stringr::str_split_i(latitudeArray, ",", 1) |> as.numeric()
    ) |>
    # sf::st_as_sf(coords = c("long_first", "lat_first"), crs = sf::st_crs(4326)) |>
    dplyr::group_by(uid) |>
    tibble::rowid_to_column("tsa") |>
    dplyr::select(-ppmAvg) |>
    tidyr::drop_na()
}

#' Create a vector of values evenly spaced between 0 and 1
#'
#' @param x vector of values
#' @param ... other parameters passed to min() or max()
#'
#' @returns vector of values evenly spaced between 0 and 1 the same length as x
range01 <- function(x, ...){(x - min(x, ...)) / (max(x, ...) - min(x, ...))}

#' Split a string seperated by ";" into numbers
#'
#' @param x a string of numbers seperated by ";"
#'
#' @returns a numeric vector
split_to_numeric <- function(x) {
  x |>
    strsplit(split = ";") |>
    unlist() |>
    as.numeric()
}
