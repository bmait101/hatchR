#' Predict phenology of fish
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Predict the phenology of fish using the effective value framework.
#'
#' @param data Dataframe with dates and temperature.
#' @param dates Date of temperature measurements.
#' @param temperature Temperature measurements.
#' @param spawn.date Date of spawning, given as a character string (e.g., "1990-08-18")
#' @param model A data.frame giving model specifications. This must have a
#' column providing a model expression. Can be obtained using `model_select()`
#' or using you own data to obtain a model expression (see `fit_model`).
#'
#' @details
#' Additional details...
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
#'  * `model.specs`: A data.frame with the model specifications.
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
#'   dev.type = "hatch"
#' )
#'
#' # predict phenology
#' sockeye_hatch <- predict_phenology(
#'   data = woody_island,
#'   dates = date,
#'   temperature = temp_c,
#'   spawn.date = "1990-08-18",
#'   model = sockeye_hatch_mod
#' )
#'
#' @references
#' Sparks, M.M., Falke, J.A., Quinn, T.P., Adkinson, M.D., Schindler, D.E.
#' (2017). Influences of spawning timing, water temperature, and
#'   climatic warming on early life history phenology in western
#'   Alaska sockeye salmon.
#'   \emph{Canadian Journal of Fisheries and Aquatic Sciences},
#'   \bold{76(1)}, 123--135
predict_phenology <- function(data, dates, temperature, spawn.date, model) {
  # arrange data by dates
  dat <- data |> dplyr::arrange({{ dates }})

  # check if dates are a character vector
  check_dates <- dat |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    stop(
      "Date column is character vector; convert to date or date-time class.",
      call. = FALSE
    )
  }

  # check if spawn.date is formatted as a character
  if (lubridate::is.timepoint(spawn.date) == TRUE ||
    lubridate::is.Date(spawn.date) == TRUE) {
    stop("Your spawn.date is formatted as a Date but needs to
         be formatted as a character string (e.g. '09-15-2000')")
  }

  # subset to spawning period
  s.d <- lubridate::ymd(spawn.date)
  spawn.position <- dat |>
    tibble::rownames_to_column() |>
    dplyr::mutate(rowname = as.numeric(.data$rowname)) |>
    dplyr::filter({{ dates }} == s.d) |>
    dplyr::pull("rowname")
  spawn.period <- dat[spawn.position:c(nrow(dat)), ]

  # bring in model df and extract the expression
  model.df <- model |>
    dplyr::pull("func")

  model.expression <- parse(text = model.df)

  # effective value function
  Ef <- model.expression

  # vector of temps for Ef to evaluate
  x <- spawn.period |> dplyr::pull({{ temperature }})

  # walk along temps and sum Ef to 1 and count how many days it takes
  D_Ef <- min(which(cumsum(eval(Ef)) >= 1))
  # If fish doesn't hatch value returns Inf

  # output results
  if (D_Ef == Inf) {

    ef.df <- spawn.period
    x <- ef.df |> dplyr::pull({{ temperature }})
    ef.df$ef_vals <- eval(Ef)
    ef.df$ef_cumsum <- cumsum(ef.df$ef_vals)
    colnames(ef.df)[1:2] <- c("dates", "temperature")

    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(ef.df$dates)
    dev.period$stop <- lubridate::as_date(NA)

    ef.results <- list(days2done=as.numeric(NA),
                       dev.period=dev.period,
                       ef.vals = ef.df$ef_vals,
                       ef.tibble = ef.df,
                       model.specs=model)
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
      ef.tibble = ef.df,
      model.specs = model
    )
  }
  return(ef.results)
}
