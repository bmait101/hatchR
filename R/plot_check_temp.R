#' Visual check of imported data
#'
#' The `plot_check_temp` function is used to plot imported data to check temperature values.
#' The function takes a data frame with dates and temperature values,
#' and plots the temperature values over time. The function also allows users
#' to specify the minimum and maximum temperature values to be plotted.
#'
#' @param data A data.frame, or data frame extension (e.g. a tibble).
#' @param dates Column representing the date of the temperature measurements
#' @param temperature Column representing the temperature values.
#' @param temp_min Threshold for lower range of expected temperature. Default is 0.
#' @param temp_max Threshold for upper range of expected temperature. Default is 25.
#'
#' @return
#' A object of class "gg" and "ggplot" that can be printed to the console or saved as an image.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' plot_check_temp(
#'   data = crooked_river,
#'   dates = date,
#'   temperature = temp_c
#' )
plot_check_temp <- function(data,
                            dates,
                            temperature,
                            temp_min = 0,
                            temp_max = 25) {
  check_dates <- data |>
    dplyr::pull({{ dates }}) |>
    is.character()

  if (check_dates == TRUE) {
    stop(
      "Date column is not Date or Date-time class; convert to date or
      date-time (e.g. `lubridate::ymd()`.",
      call. = FALSE
    )
  }

  p <- data |>
    ggplot2::ggplot(ggplot2::aes(x = {{ dates }}, y = {{ temperature }})) +
    ggplot2::geom_point(size = 0.5) +
    ggplot2::geom_line(linewidth = 0.5) +
    ggplot2::geom_hline(
      yintercept = c(temp_min), linetype = "dashed", color = "dodgerblue"
    ) +
    ggplot2::geom_hline(
      yintercept = c(temp_max), linetype = "dashed", color = "red"
    ) +
    ggplot2::labs(x = "Date", y = "Temperature") +
    ggplot2::theme_classic()

  return(p)
}

# TO DO:
# - Add a title to the plot
# - Add a subtitle to the plot
# - add x and y axis scales that depend on the data
