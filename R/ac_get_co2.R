#' Get data from indoorco2map.org
#'
#' @returns A dataframe with up to date co2 measurements
#' @export
#'
#' @examples
#' \dontrun{
#' ac_df <- ac_get_co2()
#' }
#'
ac_get_co2 <- function() {
  measurements <- .id <- startTime <- NULL

  icm_response <-
    httr2::request("https://indoorco2map.com/chartdata/IndoorCO2MapData.json.gz") |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  icm_response <-
    data.table::rbindlist(icm_response, idcol = TRUE) |>
    suppressWarnings()

  j_lst <- lapply(icm_response$measurements, jsonlite::fromJSON)
  j_lst <- lapply(j_lst, co2_to_numeric)
  j_lst <- data.table::rbindlist(j_lst, idcol = TRUE)

  ac_df <- icm_response |>
    dplyr::select(-measurements) |>
    dplyr::left_join(j_lst, by = dplyr::join_by(.id)) |>
    dplyr::mutate(
      # remove the last few digits from the unix time because they are in milliseconds and not needed
      date = stringr::str_sub(startTime, end = -4) |>
        as.numeric() |>
        as.POSIXct()
    ) |>
    sf::st_as_sf(
      coords = c("lon", "lat"),
      crs = sf::st_crs(4326)
    )

  return(ac_df)
}

#' Convert the co2 character array to a numeric list
#'
#' @param x a list containing measurements from json
#'
#' @returns list of co2 records
#'
co2_to_numeric <- function(x) {
  x$co2array <-
    x$co2array |>
    stringr::str_split(";", simplify = TRUE) |>
    as.numeric() |>
    list()

  return(x)
}
