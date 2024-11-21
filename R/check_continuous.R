#' Check if the dates in a data frame are continuous.
#'
#' @param data A data.frame, or data frame extension (e.g. a tibble).
#' @param dates Column representing the date of the temperature measurements.
#'
#' @return
#' A message indicating if the dates are continuous or if there are breaks.
#' @export
#'
#' @examples
#' library(hatchR)
#' check_continuous(crooked_river, date)
check_continuous <- function(data, dates) {
  check_out <- data |>
    dplyr::mutate(diff = c(NA, diff({{ dates }})) == 1) |>
    with(which(diff == FALSE))

  if (length(check_out) > 0) {
    message("Breaks at the following rows were found:")
    return(check_out)
  } else {
    message("No breaks were found. All clear!")
  }
}
