#' Summarize temperature data to daily values
#'
#' @description
#' `r lifecycle::badge("experimental")`
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
#'   data = crooked_river,
#'   dates = date,
#'   temperature = temp_c
#' )
summarize_temp <- function(data,
                           dates,
                           temperature) {
  # check if dates are a character vector
  check_dates <- data |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    stop(
      "Date column is character vector; convert to date or date-time class.",
      call. = FALSE
    )
  }

  sum_dat <- data |>
    dplyr::mutate(date = lubridate::date({{ dates }})) |>
    dplyr::group_by(date) |>
    dplyr::summarise(daily_temp = mean({{ temperature }}))

  return(sum_dat)
}
