
#' Get data from indoorco2map.org - "download version"
#'
#' @returns A dataframe with co2 building measurements
#'
#' @details
#' This function will download the version of building 
#' data that is available using the "download" button on 
#' the website
#' 
#' 
#' @export
#' @examples
#' 
#' \dontrun{
#' ac_df <- ac_get_co2_download()
#' }
ac_get_co2_download <- function() {
  co2readingsAvg <- startOfMeasurement <- NULL
  icm_response <-
    archive::archive_extract(
      "https://indoorco2map.com/chartdata/IndoorCO2MapData.zip",
      files = 3
    ) |> 
  jsonlite::fromJSON() |> 
  tibble::rowid_to_column("obs_number") |> 
  # dplyr::select(-co2readingsAvg) |> 
  dplyr::mutate(
    date = lubridate::as_datetime(startOfMeasurement),
    day = lubridate::date(date)
  ) |> 
    sf::st_as_sf(
      coords = c("longitude", "latitude"),
      crs = sf::st_crs(4326)
    ) 
}

