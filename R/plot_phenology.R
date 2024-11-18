#' Plot phenology
#'
#' @param plot object output from predict_phenology
#' @param style different plot types: all, ef_cumsum, ef_daily
#' @param labels true or false, used to turn on and off the information at the top of plots
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' library(hatchR)
#' #plot_phenology(WI_hatch, style = "ef_cumsum") # shows a plot with just the ef cumulative sum values
#' #plot_phenology(WI_hatch, style = "ef_daily") # shows a plot with just the ef daily values
#' #plot_phenology(WI_hatch, labels = FALSE) # turns off the labeling for a cleaner figure
plot_phenology <- function(plot, style = "all", labels = TRUE) {
  dat <- plot

  if (labels == TRUE) {
    all_label <- ggplot2::labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temp,  dark green = scaled cumulative ef_val, light green = daily ef_val(x100)")
    )

    ef_cumsum_label <- ggplot2::labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temperature, green = scaled cumulative effective value")
    )

    ef_daily_label <- ggplot2::labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temperature,  green = daily effective value (x100)")
    )
  }

  if (labels == FALSE) {
    all_label <- ggplot2::labs(x = "Date", y = "Mean daily temperature")
    ef_cumsum_label <- ggplot2::labs(x = "Date", y = "Mean daily temperature")
    ef_daily_label <- ggplot2::labs(x = "Date", y = "Mean daily temperature")
  }

  if (style == "all") {
    p <- dat$ef.tibble |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = "darkblue") +
      ggplot2::geom_point(color = "darkblue", size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = "olivedrab4") +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = "olivedrab4", size = 0.25) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = "olivedrab3") +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = "olivedrab3", size = 0.25) +
      all_label +
      ggplot2::theme_classic()
  }

  if (style == "ef_cumsum") {
    p <- dat$ef.tibble |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = "darkblue") +
      ggplot2::geom_point(color = "darkblue", size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = "olivedrab4") +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = "olivedrab4", size = 0.25) +
      ef_cumsum_label +
      ggplot2::theme_classic()
  }

  if (style == "ef_daily") {
    p <- dat$ef.tibble |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = "darkblue") +
      ggplot2::geom_point(color = "darkblue", size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = "olivedrab3") +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = "olivedrab3", size = 0.25) +
      ef_daily_label +
      ggplot2::theme_classic()
  }
  return(p)
}
