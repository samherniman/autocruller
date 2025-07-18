#' Get data from indoorco2map.org
#'
#' @returns A dataframe with up to date co2 measurements
#' @export
#'
#' @examples
#' \dontrun{
#' # Get building data with one of three options
#' ac_df <- ac_get_co2()
#' ac_df <- ac_get_co2("web")
#' ac_df <- ac_get_co2("download")
#' 
#' # Get transit data
#' ac_df <- ac_get_co2("transit")
#' }
#'
ac_get_co2 <- function(x = "web") {

  if (!(x %in% c("web", "download", "transit"))) {
    cli::cli_abort(c(
      "Error while getting co2 data:",
      "x must be either \"web\", \"download\", or \"transit\"",
      "if you want building data, set x to \"web\"",
      "if you want transit data, set x to \"transit\""
    ))
  }
  
  if (x == "web") {
    return(ac_get_co2_web())
  }

  if (x == "download") {
    return(ac_get_co2_download())
  }

  if (x == "transit") {
    return(ac_get_co2_transit())
  }
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
