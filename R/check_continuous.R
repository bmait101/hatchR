#' Check if the dates in a data frame are continuous.
#'
#' @param data A data.frame, or data frame extension (e.g. a tibble).
#' @param dates Column representing the date of the temperature measurements.
#'
#' @return
#' A message indicating if the dates are continuous or if there are breaks. If
#' there are breaks, a vector of row numbers where the breaks occur is returned.
#' @export
#'
#' @examples
#' library(hatchR)
#' check_continuous(crooked_river, date)
check_continuous <- function(data, dates) {

  check_dates <- data |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    cli::cli_abort(c(
      "`dates` must be a vector of class {.cls date} or {.cls dttm}, not a {.cls character} vector.",
      "i" = "Use {.fn lubridate::ymd} to convert to {.cls date} or {.cls dttm} vector."
    ))
  }

  check_out <- data |>
    dplyr::mutate(diff = c(NA, diff({{ dates }})) == 1) |>
    with(which(diff == FALSE))

  if (length(check_out) > 0) {
    cli::cli_warn(c(
      "!" = "Breaks at the following rows were found:",
      "i" = paste(check_out, collapse = ", ")
      ))
    check_out
  } else {
    cli::cli_inform(c("i" = "No breaks were found. All clear!"))
  }
}
