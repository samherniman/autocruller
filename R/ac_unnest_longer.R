#' Unnest a co2 df list-column into rows
#'
#' @param x a dataframe from ac_get_co2()
#'
#' @returns a dataframe in long format
#'
#' @export
#' @examples
#' \dontrun{
#' ac_df <- ac_get_co2("download") |>
#' ac_unnest_longer()
#' }
ac_unnest_longer <- function(x) {
  co2readings <- obs_number <- offset <- interval <- reading_index <- NULL
  x_df <- x |> tidyr::unnest_longer(co2readings)

  if (all(c("offset", "interval") %in% names(x))) {
    x_df <- x_df |>
    dplyr::group_by(obs_number) |>
    dplyr::mutate(
      reading_index = dplyr::row_number(),
      date_time = lubridate::as_datetime(date) +
        lubridate::dminutes(offset) +
        lubridate::dminutes(interval * reading_index)
    )
  }

  return(x_df)
}
