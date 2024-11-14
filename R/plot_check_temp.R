#' Plot imported data
#'
#' @param df data.frame with dates and temperature
#' @param dates date column
#' @param temperature temperature column
#' @param temp_min min temp on plot
#' @param temp_max max temp on plot
#'
#' @return
#' @export
#'
#' @examples
plot_check_temp <- function(df,
                            dates,
                            temperature,
                            temp_min = 0,
                            temp_max = 25
                            ){

  check_dates <- df |>
    pull({{dates}}) |>
    is.character()

  if(check == TRUE){
    stop("Date column is a character vector; covert to timepoint object with lubridate (e.g. `ymd()`.")
    }

  # object holder for dates character check
  d <- df |> dplyr::pull({{dates}})

  # if dates is string, convert to timepoint via lubridate
  if(is.character(d)){
    p <- df  |>
      dplyr::mutate(dates = lubridate::ymd_hms({{dates}})) |>
      ggplot2::ggplot(ggplot2::aes(x = dates, y = {{temperature}})) +
      ggplot2::geom_point(size =0.5) +
      ggplot2::geom_line(linewidth =0.5) +
      ggplot2::geom_hline(
        yintercept = c(temp_min), linetype = "dashed", color = "dodgerblue") +
      ggplot2::geom_hline(
        yintercept = c(temp_max), linetype = "dashed", color = "red") +
      ggplot2::labs(x = "Date", y = "Temperature") +
      ggplot2::theme_classic()

  } else{
    p <- df |>
      ggplot2::ggplot(ggplot2::aes(x = {{dates}}, y = {{temperature}})) +
      ggplot2::geom_point(size =0.5) +
      ggplot2::geom_line(linewidth =0.5) +
      ggplot2::geom_hline(
        yintercept = c(temp_min), linetype = "dashed", color = "dodgerblue") +
      ggplot2::geom_hline(
        yintercept = c(temp_max), linetype = "dashed", color = "red") +
      ggplot2::labs(x = "Date", y = "Temperature") +
      ggplot2::theme_classic()

  }
  return(p)
}
