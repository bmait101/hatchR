#' Plot imported data
#'
#' @param data imported data
#' @param dates date column
#' @param temperature temperature column
#' @param temp_min min temp on plot
#' @param temp_max max temp on plot
#'
#' @return
#' @export
#'
#' @examples
plot_check_temp <- function(data, dates, temperature, temp_min, temp_max){
  # null values for temp_min and temp_max (for plotting lines)
  if(missing(temp_min)){
    temp_min = 0
  }
  if(missing(temp_max)){
    temp_max = 25
  }

  # object holder for dates character check
  d <- data |> dplyr::pull({{dates}})

  # if dates is string, convert to timepoint via lubridate
  if(is.character(d)){
    p <- data  |>
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
    p <- data |>
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
