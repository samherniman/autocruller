#' Make spatial transit data into an sf linestring
#'
#' @param lon vector of numeric longitude values
#' @param lat vector of numeric latitude values
#' @param noise_distance Distance in km to specify how far
#' apart GPS points can be to remain in the sf linestring. See details
#'
#' @description
#' Turns the GPS locations and origin and destination points into sf linestrings.
#' This function is mainly used internally. Try using ac_make_transit_spatial()
#' instead.
#' Also does some cleaning to remove points at 0, 0 and points that are more than
#' 100 km from the nearest other points. This function is pretty slow. I recommend
#' that you use it every time you get transit measurements, but it can be skipped
#' if you want to save time
#'
#' @details
#' Points that are greater than `noise_distance` from the points before and after
#' themselves will be removed from the linestring. This tends to remove erroneous
#' points although it may remove some correct points. The default is set to 100 km.
#' If you do not want points removed for their distance set the `noise_distance` to
#' something really high.
#'
#' @returns sf object of linestring or point
#' @export
#'
ac_make_linestring <- function(lon, lat, noise_distance = 100) {
  geometry <- dist_lag <- dist_lead <- NULL
  nd <- units::as_units(noise_distance, "km")

  if (all(is_na_or_zero(lon)) && all(is_na_or_zero(lat))) {
    return(sf::st_point(x = c(NA_real_, NA_real_), dim = "XYZ"))
  }

  x_matrix <-
    tibble::tibble(
      lon = unlist(lon),
      lat = unlist(lat)
    ) |>
    tidyr::drop_na() |>
    dplyr::filter_out(
      lon == 0 & lat == 0
    ) |>
    sf::st_as_sf(
      coords = c("lon", "lat"),
      crs = 4326
    ) |>
    dplyr::mutate(
      dist_lag = sf::st_distance(geometry, dplyr::lag(geometry), by_element = TRUE),
      dist_lead = sf::st_distance(geometry, dplyr::lead(geometry), by_element = TRUE),
    ) |>
    tidyr::replace_na(list(dist_lag = units::as_units(0, "m"), dist_lead = units::as_units(0, "m"))) |>
    dplyr::filter_out(
      dist_lag > nd,
      dist_lead > nd
    ) |>
    dplyr::select(geometry) |>
    sf::st_coordinates()

  if (all(is.na(x_matrix))) {
    return(sf::st_point(x = c(NA_real_, NA_real_), dim = "XYZ"))
  }

  if (nrow(x_matrix) > 1) {
    sf::st_linestring(x_matrix, dim = "XY")
  } else {
    sf::st_point(x_matrix, dim = "XY")
  }

}

