#' Visual check of imported temperature data
#'
#' @description
#' The `plot_check_temp` function is used to plot imported data to check temperature values.
#' The function takes a data frame with dates and temperature values,
#' and plots the temperature values over time. The function also allows users
#' to specify the minimum and maximum temperature values to be plotted.
#'
#' @param data A data.frame, or data frame extension (e.g. a tibble).
#' @param dates Vector of dates for temperature measurements. Must be date or date-time class.
#' @param temperature Vector of temperature values.
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

  check_dates <- data |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    cli::cli_abort(c(
            "`dates` must be a vector of class {.cls date} or {.cls dttm}, not a {.cls character} vector.",
      "i" = "Use {.fn lubridate::ymd} to convert to {.cls date} or {.cls dttm} vector."
    ))
  }

  # plotting parameters
  title <- "Temperature Check"
  label_x <- "Date"
  label_y <- "Temperature"
  col_min <- "dodgerblue"
  col_max <- "red"

  # plot
  p <- data |>
    ggplot2::ggplot(ggplot2::aes(x = {{ dates }}, y = {{ temperature }})) +
    ggplot2::geom_point(size = 0.5) +
    ggplot2::geom_line(linewidth = 0.5) +
    ggplot2::geom_hline(
      yintercept = c(temp_min), linetype = "dashed", color = col_min
    ) +
    ggplot2::geom_hline(
      yintercept = c(temp_max), linetype = "dashed", color = col_max
    ) +
    ggplot2::labs(title = title, x = label_x, y = label_y) +
    ggplot2::theme_classic()

  return(p)
}
