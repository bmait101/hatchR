#' Predict phenology of fish
#'
#' @description
#' Predict the phenology of fish using the effective value framework.
#'
#' @param data Data frame with dates and temperature.
#' @param dates Date of temperature measurements.
#' @param temperature Temperature measurements.
#' @param spawn.date Date of spawning, given as a character string
#' (e.g., "1990-08-18"). Must be year-month-day in format shown.
#' @param model A data.frame with a column named "expression" or a character vector
#' giving model specifications. Can be obtained using `model_select()`
#' or using you own data to obtain a model expression (see `fit_model`).
#'
#' @return
#' A list with the following elements:
#' * `days_to_develop`: A numeric vector of length 1; number of predicted
#'    days to hatch or emerge.
#' * `ef_table`: An n x 4 tibble (n = number of days to hatch or emerge) with
#'    the dates, temperature, effective values, and cumulative sum of the
#'    effective values.
#' * `dev.period`: a 1x2 dataframe with the dates corresponding to when your
#'    fish's parent spawned (input with `predict_phenology(spawn.date = ...)`)
#'    and the date when the fish is predicted to hatch or emerge.
#' * `model_specs`: A data.frame with the model specifications.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' # get model parameterization
#' sockeye_hatch_mod <- model_select(
#'   author = "Beacham and Murray 1990",
#'   species = "sockeye",
#'   model_id = 2,
#'   development_type = "hatch"
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
#' @references
#' Sparks, M.M., Falke, J.A., Quinn, T.A., Adkinson, M.D.,
#' Schindler, D.E. (2019). Influences of spawning timing, water temperature,
#' and climatic warming on early life history phenology in western
#' Alaska sockeye salmon.
#'   \emph{Canadian Journal of Fisheries and Aquatic Sciences},
#'   \bold{76(1)}, 123--135.
predict_phenology <- function(data, dates, temperature, spawn.date, model) {
  # assign data and arrange data by dates
  dat <- data |>
    dplyr::arrange({{ dates }}) |>
    tibble::rownames_to_column(var = "index") |>
    dplyr::mutate(index = as.numeric(.data$index))

  # check if dates are a character vector
  check_dates <- dat |> dplyr::pull({{ dates }})
  if (is.character(check_dates) == TRUE) {
    cli::cli_abort(c(
      "`dates` must be a vector of class {.cls date} or {.cls dttm}, not a {.cls character} vector.",
      "i" = "Use {.fn lubridate::ymd} to convert to {.cls date} or {.cls dttm} vector."
    ))
  }

  # check if spawn.date is formatted as a date
  if (lubridate::is.timepoint(spawn.date) == TRUE ||
    lubridate::is.Date(spawn.date) == TRUE) {
    cli::cli_abort(
      "Your spawn.date is formatted as a Date but needs to be formatted as a character string (e.g. '09-15-2000')"
    )
  }

  # get spawn date
  s.d <- lubridate::ymd(spawn.date)

  # subset data to spawning period (after spawn date)
  spawn.index <- dat |>
    dplyr::filter({{ dates }} == s.d) |>
    dplyr::pull("index")
  dat_spawn <- dat[spawn.index:c(nrow(dat)), ]

  # model prep
  # bring in model df and extract the expression
  if (is.null(model)) {
    cli::cli_abort("You must provide a model specification.")
  } else if (is.data.frame(model) & !"expression" %in% colnames(model)) {
    cli::cli_abort("Model object must have a column named 'expression'.")
  } else if (is.data.frame(model) & "expression" %in% colnames(model)) {
    mod.exp <- model |> dplyr::pull("expression")
  } else if (is.character(model)) {
    mod.exp <- model
  } else {
    cli::cli_abort("Model object must be a data.frame or character string.")
  }

  # Parse model expression to get effective value function
  Ef <- parse(text = mod.exp)

  # Vector of temps for Ef to evaluate
  x <- dat_spawn |> dplyr::pull({{ temperature }})

  # Vector of effective values (will catch NaNs)
  Ef.vals <- suppressWarnings(eval(Ef))

  # Vector of cumsum of effective values
  Ef.cumsum <- suppressWarnings(cumsum(eval(Ef)))

  # Walk along temps and sum Ef to 1 and count how many days it takes
  #     If fish doesn't hatch value returns Inf
  Ef.days <- suppressWarnings(min(which(Ef.cumsum >= 1)))

  # Table of outs
  dat_out <- tibble::tibble(
    index = dat_spawn$index,
    dates = dat_spawn$date,
    temperature = x,
    ef_vals = Ef.vals,
    ef_cumsum = Ef.cumsum
  )

  # Results ----------------------------------------

  # Deal with NaN values from negative temperatures but with hatch/emergence
  if (NaN %in% Ef.vals & Ef.days != Inf) {
    # subset out data to period from spawn to hatch or emergence
    dat_out_sub <- dat_out[1:(1 + (Ef.days - 1)), ]

    # get development period
    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(dat_out_sub$dates)
    dev.period$stop <- max(dat_out_sub$dates)
    # dev.period$stop <- lubridate::as_date(NA)

    ef.results <- list(
      days_to_develop = Ef.days,
      dev.period = dev.period,
      ef_table = dat_out_sub,
      model_specs = model
    )

    # get dates with NaN values
    ef_nans <- dat_out[which(is.na(dat_out$ef_vals)), c("dates")]
    ef_nans <- as.character(ef_nans$dates)

    cli::cli_warn(c(
      "!" = "Fish developed, but negative temperature values resulted in NaNs after development.",
      "i" = "Check date(s): {ef_nans}",
      "i" = "Fish spawn date was: {s.d}"
    ))

    # NaNs and fish does not hatch
  } else if (NaN %in% Ef.vals & Ef.days == Inf) {
    # dont subset data, return all
    dat_out_sub <- dat_out

    # get development period
    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(dat_out_sub$dates)
    # dev.period$stop <- max(dat_out_sub$dates)
    dev.period$stop <- lubridate::as_date(NA)

    ef.results <- list(
      days_to_develop = Ef.days,
      dev.period = dev.period,
      ef_table = dat_out_sub,
      model_specs = model
    )

    # get dates with NaN values
    ef_nans <- dat_out[which(is.na(dat_out$ef_vals)), c("dates")]
    ef_nans <- as.character(ef_nans$dates)

    cli::cli_warn(c(
      "!" = "Negative temperatures resulted in NaNs, and fish did not develop.",
      "i" = "Check date(s): {ef_nans}",
      "i" = "Fish spawn date was: {s.d}"
    ))

    # Fish does not hatch
  } else if (Ef.days == Inf) {

    # dont subset data, return all
    dat_out_sub <- dat_out

    # get development period
    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(dat_out_sub$dates)
    # dev.period$stop <- max(dat_out_sub$dates)
    dev.period$stop <- lubridate::as_date(NA)

    ef.results <- list(
      days_to_develop = as.numeric(NA),
      dev.period = dev.period,
      ef_table = dat_out_sub,
      model_specs = model
    )

    cli::cli_inform(c(
      "!" = "Fish did not accrue enough effective units to develop.",
      "i" = "Did your fish spawn too close to the end of your data?",
      "i" = "Spawn date {s.d}."
    ))

  } else {

    # subset out data to period from spawn to hatch or emergence
    dat_out_sub <- dat_out[1:(1 + (Ef.days - 1)), ]

    # get development period
    dev.period <- data.frame(matrix(NA, nrow = 1, ncol = 2))
    colnames(dev.period) <- c("start", "stop")
    dev.period$start <- min(dat_out_sub$dates)
    dev.period$stop <- max(dat_out_sub$dates)

    ef.results <- list(
      days_to_develop = Ef.days,
      dev.period = dev.period,
      ef_table = dat_out_sub,
      model_specs = model
    )
  }
  return(ef.results)
}
