#' Fit B&M model 2 to new data using `stats::nls()`
#'
#' @description
#' `r lifecycle::badge("experimental")`
#' Generate your own custom parameterized models for predicting hatching and emergence phenology.
#'
#' @details
#' `hatchR` also includes functionality to generate your own custom
#' parameterized models for predicting hatching and emergence phenology.
#' Importantly, the custom parameterization relies on the model format
#' developed from model 2 of Beacham and Murray (1990), which we chose
#' because of its overall simplicity and negligible loss of accuracy.
#' See Beacham and Murray (1990) and Sparks et al. (2019) for more
#' specific discussion regarding model 2 and the development of the
#' effective value approach.
#'
#' @param df Data.frame with new data
#' @param temp Column with temperature measurement
#' @param days Column with day of temperature measurement
#' @param species Character string of species name (e.g., "sockeye")
#' @param dev.type Character string of development type: "hatch" or "emerge"
#'
#' @return List with fit model object, model coefficients, model specifications
#' data.frame, and plot of observations and model fit.
#'
#' @export
#'
#' @examples
#' library(hatchR)
#' # vector of temperatures
#' temperature <- c(2, 5, 8, 11, 14)
#' # vector of days to hatch
#' days_to_hatch <- c(194, 87, 54, 35, 28)
#' quinn_bt_hatch <- tibble::tibble(temperature, days_to_hatch)
#' bt_hatch_mod <- fit_model(df = quinn_bt_hatch, temp = temperature,
#' days = days_to_hatch, species = "sockeye", dev.type = "hatch")
fit_model <- function(df, temp, days, species = NULL, dev.type = NULL) {

  # check if species is NULL
  if (is.null(species)) {
    cli::cli_abort(c(
            "`species` cannot be NULL.",
      "i" = "Provide a species name using `species = 'your_species'`."
      ))
  }

  # check if dev.type is NULL
  if (is.null(dev.type)) {
    cli::cli_abort(c(
            "`dev.type` cannot be NULL",
      "i" = "Provide a dev.type name using `dev.type = 'hatch' or `dev.type = 'emerge'`."
    ))
  }

  # fit linear model to log data
  m1 <- stats::lm(log(days) ~ log(temp), data = df)
  summary(m1)

  # estimate starting values for nls
  m1_a <- exp(stats::coef(m1)[1]) # exponentiate the intercept
  m1_b <- stats::coef(m1)[2]

  # fit model 2 from Beacham & Murray (1990) to data
  m2 <- stats::nls(days ~ a / (temp - b), data = df, start = list(a = m1_a, b = m1_b))
  summary(m2)

  # check coefficients
  m2_a <- log(stats::coef(m2)[1])
  m2_b <- stats::coef(m2)[2]

  # model specs for hatch function
  func <- paste("1 / exp(", m2_a, " - log(x + ", m2_b * -1, "))", sep = "") # is *-1 correct?
  func <- tibble::tibble(
    species = species,
    dev.type = dev.type,
    func = func
    )
  # mod <- parse(text = mod)  # no longer parsing until predict_phenology()

  # plot predictions and data --------------------------

  grid <- data.frame(temp = seq(min(temp), max(temp), 0.1))
  grid$pred <- stats::predict(m2, newdata = grid)
  p_pred <- df |>
    ggplot2::ggplot(ggplot2::aes(x = temp, y = days)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(data = grid, ggplot2::aes(x = .data$temp, y = .data$pred), col = "blue") +
    ggplot2::theme_classic()
  p_pred

  # model diagnostics --------------------------------

  # Predicted values
  y <- temp
  y_pred <- stats::predict(m2)

  # Calculate residuals
  residuals <- y - y_pred

  # Calculate total sum of squares (SST)
  sst <- sum((y - mean(y))^2)

  # Calculate sum of squared residuals (SSR)
  ssr <- sum(residuals^2)

  # Calculate peudo R-squared
  r_squared <- 1 - (ssr / sst)

  # Mean Squared Error (MSE)
  mse <- mean(residuals^2)

  # Root Mean Squared Error (RMSE)
  rmse <- sqrt(mse)

  # list of outputs ----------------------
  out <- list(
    model = m2,
    m2_a = m2_a,
    m2_b = m2_b,
    func = func,
    pred_plot = p_pred,
    r_squared = r_squared,
    mse = mse,
    rmse = rmse
  )

  return(out)
}
