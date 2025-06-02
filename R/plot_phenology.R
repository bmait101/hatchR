#' Visualize fish phenology
#'
#' @description
#' The function takes the output from `predict_phenology()` and creates a
#' basic ggplot2 plot object to visualize the predicted phenology.
#'
#' @details
#' When displayed, scaled daily effective temperature (EF) values plot to the
#' primary y-axis. Cumulative EF values plot to the secondary y-axis.
#'
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
  size.pts <- 1.0
  size.line <- 1.0

  if (labels == TRUE) {
    all_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev_period$start}; fish developed: {dat$dev_period$stop}",
          "<br><span style='color:{cols[1]}'>Temperature</span>;
          <span style='color:{cols[2]}'>Cumulative EF value</span>;
          <span style='color:{cols[3]}'>Daily EF value (x100)</span>"
        ),
        width = 30
      )
    )

    ef_cumsum_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev_period$start}; fish developed: {dat$dev_period$stop}",
          "<br><span style='color:{cols[1]}'>Temperature</span>;
          <span style='color:{cols[2]}'>Cumulative EF value</span>"
        ),
        width = 30
      )
    )

    ef_daily_label <- ggplot2::labs(
      x = x_lab, y = y_lab,
      title = paste(dat$days_to_develop, "days to develop"),
      subtitle = stringr::str_wrap(
        stringr::str_glue(
          "Fish spawned: {dat$dev_period$start}; fish developed: {dat$dev_period$stop}",
          "<br><span style='color:{cols[1]}'>Temperature</span>;
          <span style='color:{cols[3]}'>Daily EF value (x100)</span>"
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

  sec_axis_scalar <- max(dat$ef_table$temperature, na.rm = TRUE)
  if (style == "all") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1], linewidth = size.line) +
      ggplot2::geom_point(color = cols[1], size = size.pts) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], linewidth = size.line) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], size = size.pts) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], linewidth = size.line) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], size = size.pts) +
      all_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown()) +
      ggplot2::scale_y_continuous(
        sec.axis = ggplot2::sec_axis(~. / sec_axis_scalar, name = "Cumulative EF Value")
      )
  }

  if (style == "ef_cumsum") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1], linewidth = size.line) +
      ggplot2::geom_point(color = cols[1], size = size.pts) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], linewidth = size.line) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_cumsum * max(.data$temperature)), color = cols[2], size = size.pts) +
      ef_cumsum_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown()) +
      ggplot2::scale_y_continuous(
        sec.axis = ggplot2::sec_axis(~. / sec_axis_scalar, name = "Cumulative EF Value")
      )
  }

  if (style == "ef_daily") {
    p <- dat$ef_table |>
      ggplot2::ggplot(ggplot2::aes(x = .data$dates, y = .data$temperature)) +
      ggplot2::geom_line(color = cols[1], linewidth = size.line) +
      ggplot2::geom_point(color = cols[1], size = size.pts) +
      ggplot2::geom_line(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], linewidth = size.line) +
      ggplot2::geom_point(ggplot2::aes(y = .data$ef_vals * 100), color = cols[3], size = size.pts) +
      ef_daily_label +
      ggplot2::theme_classic() +
      ggplot2::theme(plot.subtitle = ggtext::element_markdown())
      # ggplot2::scale_y_continuous(
      #   sec.axis = ggplot2::sec_axis(~. / sec_axis_scalar, name = "Cumulative EF Value")
      # )
  }
  return(p)
}
