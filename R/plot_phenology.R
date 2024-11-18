#' Plot phenology
#'
#' @param plot object output from predict_phenology
#' @param style different plot types (all, ef_cumsum, ef_daily)
#' @param labels true or false, used to turn on and off the information at the top of plots
#'
#' @return ggplot2 object
#' @export
#'
#' @examples
#' to come...
plot_phenology <- function(plot, style, labels) {
  dat <- plot

  if (missing(style)) {
    style <- "all"
  }
  if (missing(labels)) {
    labels <- TRUE
  }

  # switch labels on/off
  if (labels == TRUE) {
    all_label <- labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temp,  dark green = scaled cumulative ef_val, light green = daily ef_val(x100)")
    )

    ef_cumsum_label <- labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temperature, green = scaled cumulative effective value")
    )

    ef_daily_label <- labs(
      x = "Date", y = "Mean daily temperature",
      title = paste(dat$days2done, "days to hatch/emerge"),
      subtitle = paste("Fish spawned", dat$dev.period$start, "and hatched/emerged", dat$dev.period$stop, "\nblue = temperature,  green = daily effective value (x100)")
    )
  }

  if (labels == FALSE) {
    all_label <- labs(x = "Date", y = "Mean daily temperature")
    ef_cumsum_label <- labs(x = "Date", y = "Mean daily temperature")
    ef_daily_label <- labs(x = "Date", y = "Mean daily temperature")
  }

  if (style == "all") {
    p <- dat$ef.tibble %>%
      ggplot(aes(x = dates, y = temperature)) +
      geom_line(color = "darkblue") +
      geom_point(color = "darkblue", size = 0.5) +
      geom_line(aes(y = ef_cumsum * max(temperature)), color = "olivedrab4") +
      geom_point(aes(y = ef_cumsum * max(temperature)), color = "olivedrab4", size = 0.25) +
      geom_line(aes(y = ef_vals * 100), color = "olivedrab3") +
      geom_point(aes(y = ef_vals * 100), color = "olivedrab3", size = 0.25) +
      all_label +
      theme_classic()
  }

  if (style == "ef_cumsum") {
    p <- dat$ef.tibble %>%
      ggplot(aes(x = dates, y = temperature)) +
      geom_line(color = "darkblue") +
      geom_point(color = "darkblue", size = 0.5) +
      geom_line(aes(y = ef_cumsum * max(temperature)), color = "olivedrab4") +
      geom_point(aes(y = ef_cumsum * max(temperature)), color = "olivedrab4", size = 0.25) +
      ef_cumsum_label +
      theme_classic()
  }

  if (style == "ef_daily") {
    p <- dat$ef.tibble %>%
      ggplot(aes(x = dates, y = temperature)) +
      geom_line(color = "darkblue") +
      geom_point(color = "darkblue", size = 0.5) +
      geom_line(aes(y = ef_vals * 100), color = "olivedrab3") +
      geom_point(aes(y = ef_vals * 100), color = "olivedrab3", size = 0.25) +
      ef_daily_label +
      theme_classic()
  }
  return(p)
}
