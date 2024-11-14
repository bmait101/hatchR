#' Summarize Temperature Data
#'
#' The `summarize_temp` function is used to summarize sub-daily temperature
#' measurements to obtain mean daily temperature.
#'
#' @param data data.frame with dates and temperature
#' @param dates date column
#' @param temperature temperature column
#'
#' @return
#' A data frame with summarized daily temperature values.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' summarize_temp(data = RMRS_MT103, dates = SampleDate, temperature = temperature)
summarize_temp <- function(data,
                           dates,
                           temperature
                           ){

  check_dates <- data |> dplyr::pull({{dates}}) |> is.character()
  if(check_dates == TRUE){
    stop(
      "Date column is not Date or Date-time class; convert to date or date-time (e.g. `lubridate::ymd()`.",
      call. = FALSE
    )
  }

  sum_dat <- data  |>
    dplyr::mutate(date = lubridate::date({{dates}}))  |>
    dplyr::group_by(date)  |>
    dplyr::summarise(daily_temp = mean({{temperature}}))

  return(sum_dat)
}
