#' Get transit data from indoorco2map.org
#'
#' @returns A dataframe with up to date co2 transit measurements
#'
#' @export
#' @examples
#' \dontrun{
#' ac_df <- ac_get_co2_transit()
#' }
ac_get_co2_transit <- function() {
    icm_response <-
      httr2::request("https://rkhby3mvq3.execute-api.eu-central-1.amazonaws.com/GetTransportCO2Data") |>
      httr2::req_perform() |>
      httr2::resp_body_json() |> 
    unlist() |> 
    lapply(jsonlite::fromJSON)

  j_df <- do.call(rbind, icm_response) |> 
    tibble::rowid_to_column("uid") 

  j_df <- lapply(1:nrow(j_df), \(x) json_to_df(j_df[x,]))
  j_df <- 
    do.call(rbind, j_df) |>
    sf::st_as_sf(
      coords = c("long_first", "lat_first"), 
      crs = sf::st_crs(4326)
    ) |>
    sf::st_make_valid() 

  return(j_df)
}

#' Turn a co2 json into a dataframe
#'
#' @param x A json 
#'
#' @returns a dataframe
json_to_df <- function(x) {
  x |> 
    dplyr::mutate(
      timestampArray = split_to_numeric(timestampArray) |> range01() |> paste(collapse = ";"),
      # mod_loess = list(train_loess(co2_vec = co2Array, time_vec = timestampArray)),
      co2Array = stringr::str_replace_all(co2Array, ";", ","),
      longitudeArray = stringr::str_remove_all(longitudeArray, "(0;|0$)") |> stringr::str_replace_all(",", "\\.") |> 
        stringr::str_replace_all(";", ","),
      latitudeArray = stringr::str_remove_all(latitudeArray, "(0;|0$)") |> stringr::str_replace_all(",", "\\.") |> 
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
