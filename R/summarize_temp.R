#' Summarize temperature data to daily values
#'
#' @description
#' The `summarize_temp` function is used to summarize sub-daily temperature
#' measurements to obtain mean daily temperature.
#'
#' @param data A data.frame, or data frame extension (e.g. a tibble).
#' @param dates Column representing the date of temperature measurements.
#' @param temperature Column representing temperature values.
#'
#' @return
#' A data.frame with summarized daily temperature values.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' summarize_temp(
#'   data = idaho,
#'   dates = date,
#'   temperature = temp_c
#' )
summarize_temp <- function(data,
                           dates,
                           temperature) {
  check_dates <- data |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    cli::cli_abort(c(
      "`dates` must be a vector of class {.cls date} or {.cls dttm}, not a {.cls character} vector.",
      "i" = "Use {.fn lubridate::ymd} to convert to {.cls date} or {.cls dttm} vector."
    ))
  }

  sum_dat <- data |>
    dplyr::mutate(date = lubridate::date({{ dates }})) |>
    dplyr::group_by(date) |>
    dplyr::summarise(daily_temp = mean({{ temperature }}))

  return(sum_dat)
}
