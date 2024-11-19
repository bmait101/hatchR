#' Predict phenology of fish
#'
#' @description
#' A short description...
#'
#' @param data Dataframe with dates and temperature.
#' @param dates Date of temperature measurements.
#' @param temperature Temperature measurements.
#' @param spawn.date Date of spawning.
#' @param model Model to predict phenology.
#'
#' @return
#' A list with the following elements:
#' * `ef.vals`: A numeric vector of each day's effective value.
#' * `days2done`: A numeric vector of length 1; number of predicted days to hatch or emerge.
#' * `ef.tibble`: An n x 4 tibble (n = number of days to hatch or emerge) with
#'  the dates, temperature, effective values, and cumulative sum of the effective values.
#' * `dev.period`: a 1x2 dataframe with the dates corresponding to when your
#'  fish's parent spawned (input with `predict_phenology(spawn.date = ...)`)
#'  and the date when the fish is predicted to hatch or emerge.
#'
#' @export
#'
#' @examples
#' # to come...
#'
#' @references
#' Sparks, M.M., Falke, J.A., Quinn, T.P., Adkinson, M.D., Schindler, D.E.
#' (2017). Influences of spawning timing, water temperature, and
#'   climatic warming on early life history phenology in western
#'   Alaska sockeye salmon.
#'   \emph{Canadian Journal of Fisheries and Aquatic Sciences},
#'   \bold{76(1)}, 123--135
predict_phenology <- function(data, dates, temperature, spawn.date, model) {
  dat <- data |> dplyr::arrange({{ dates }})

  if (lubridate::is.timepoint(spawn.date) == TRUE ||
    lubridate::is.Date(spawn.date) == TRUE) {
    stop("Your spawn.date is formatted as a Date but needs to
         be formatted as a character string (e.g. '09-15-2000')")
  }

  check <- dat |>
    dplyr::pull({{ dates }}) |>
    is.character()

  if (check == TRUE) {
    stop("Your dates are formatted as a character, they need to
         be formatted as a timepoint (e.g. using ymd())")
  }

  # turn dates from strings to datetime for using lubridate
  s.d <- lubridate::ymd(spawn.date)
  # dat[,dates] <-mdy(dat[,dates] )

  # subset to spawn date
  # spawn.position <- which(dat[,dates] == s.d)  #old base R version
  spawn.position <- dat |>
    tibble::rownames_to_column() |>
    dplyr::mutate(rowname = as.numeric(.data$rowname)) |>
    dplyr::filter({{ dates }} == s.d) |>
    dplyr::pull("rowname")

  spawn.period <- dat[spawn.position:c(nrow(dat)), ]

  # effective value function
  Ef <- model
  # Ef.t <-function(x){1 / exp(6.727 - log(x + 2.394))}

  x <- spawn.period |> dplyr::pull({{ temperature }}) # vector of temps for Ef to evluate

  # walk along temps and sum Ef to 1 and count how many days
  # D_Ef <- min(which(cumsum(Ef.t(spawn.period[, temps])) >= 1)) #Apply Effective Value model


  D_Ef <- min(which(cumsum(eval(Ef)) >= 1))

  ####  If fish doesn't hatch value returns Inf, if that's the case this returns ef.results as NULL ####
  #### which can be used in a loop to pass over the Inf vals and skip to next iteration             ####
  if (D_Ef == Inf) {
    ef.results <- NULL
    message(
      "| Fish did not develop, did not accrue enough
            effective units. Spawn date = ",
      spawn.date,
      ". Did your fish spawn too close to the end of your data?"
    )
  } else {
    # make df with Ef info (dates, temps, Ef vals)
    ef.df <- dat[spawn.position:(spawn.position + (D_Ef - 1)), ]
    x <- ef.df |> dplyr::pull({{ temperature }})
    ef.df$ef_vals <- eval(Ef)
    ef.df$ef_cumsum <- cumsum(ef.df$ef_vals)
    colnames(ef.df)[1:2] <- c("dates", "temperature")

    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(ef.df$dates)
    dev.period$stop <- max(ef.df$dates)

    # output a list with the various data stored
    ef.results <- list(
      days2done = D_Ef,
      dev.period = dev.period,
      ef.vals = ef.df$ef_vals,
      ef.tibble = ef.df
    )
  }
  return(ef.results)
}
