ac_make_linestring <- function(lon, lat) {
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
      dist_lag > units::as_units(100, "km"),
      dist_lead > units::as_units(100, "km")
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
