#' Visualize fish phenology
#'
#' @description
#' The function takes the output from `predict_phenology()` and creates a
#' basic ggplot2 plot object to visualize the predicted phenology.
#'
#' @param plot A list containing the output from `predict_phenology()`
#' @param style The style of the plot. A vector with possible values "all",
#'  "ef_cumsum", "ef_daily". The default is "all".
#' @param labels Logical. If TRUE (default), labels are added to the plot.
#'
#' @return
#' A object of class "gg" and "ggplot".
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' # get model parameterization
#' sockeye_hatch_mod <- model_select(
#'   author = "Beacham and Murray 1990",
#'   species = "sockeye",
#'   model = 2,
#'   development_type = "hatch"
#' )
#' # predict phenology
#' sockeye_hatch <- predict_phenology(
#'   data = woody_island,
#'   dates = date,
#'   temperature = temp_c,
#'   spawn.date = "1990-08-18",
#'   model = sockeye_hatch_mod
#' )
#' plot_phenology(sockeye_hatch)
#' plot_phenology(sockeye_hatch, style = "ef_cumsum")
#' plot_phenology(sockeye_hatch, style = "ef_daily")
#' plot_phenology(sockeye_hatch, labels = FALSE)
plot_phenology <- function(plot, style = "all", labels = TRUE) {
  dat <- plot
  x_lab <- "Date"
  y_lab <- "Mean daily temperature"
  cols <- c("#1f78b4", "#d95f02", "#1b9e77")

  if (labels == TRUE) {
    all_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev.period$start}; fish developed: {dat$dev.period$stop}",
          "<br><span style='color:#1f78b4'>Temperature</span>;
          <span style='color:#d95f02'>Scaled cumulative EF value</span>;
          <span style='color:#1b9e77'>Daily EF value (x100)</span>"
        ),
        width = 30
      )
    )

    ef_cumsum_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev.period$start}; fish developed: {dat$dev.period$stop}",
          "<br><span style='color:#1f78b4'>Temperature</span>;
          <span style='color:#d95f02'>Scaled cumulative EF value</span>"
        ),
        width = 30
      )
    )

    ef_daily_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev.period$start}; fish developed: {dat$dev.period$stop}",
          "<br><span style='color:#1f78b4'>Temperature</span>;
          <span style='color:#1b9e77'>Daily EF value (x100)</span>"
        ),
        width = 30
      )
    )
  }

  if (labels == FALSE) {
    all_label <- ggplot2::labs(x = x_lab, y = y_lab)
    ef_cumsum_label <- ggplot2::labs(x = x_lab, y = y_lab)
    ef_daily_label <- ggplot2::labs(x = x_lab, y = y_lab)
  }

  if (style == "all") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1]) +
      ggplot2::geom_point(color = cols[1], size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2]) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], size = 0.25) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3]) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], size = 0.25) +
      all_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown())
  }

  if (style == "ef_cumsum") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1]) +
      ggplot2::geom_point(color = cols[1], size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2]) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], size = 0.25) +
      ef_cumsum_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown())
  }

  if (style == "ef_daily") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1]) +
      ggplot2::geom_point(color = cols[1], size = 0.5) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3]) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], size = 0.25) +
      ef_daily_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown())
  }
  return(p)
}
