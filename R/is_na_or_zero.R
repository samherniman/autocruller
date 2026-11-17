#' NA or zero
#'
#' @param x vector of values
#'
#' @returns TRUE or FALSE
#' @export
#'
#' @examples
#' is_na_or_zero(c(0, NA, 1, "howihgew"))
is_na_or_zero <- function(x) {
  is.na(x) | x == 0
}
