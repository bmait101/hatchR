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
#' @param temp Numeric vector of temperatures
#' @param days Numeric vector of days to hatch or emerge
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
#' bt_hatch_mod <- fit_model(temp = temperature,
#' days = days_to_hatch, species = "sockeye", dev.type = "hatch")
fit_model <- function(temp, days, species = NULL, dev.type = NULL) {
  df <- tibble::tibble(x = temp, y = days)

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


  # fit linear model to estimate starting values for nls
  m1 <- stats::lm(log(y) ~ x, data = df)
  # summary(m1)

  # pull out starting values
  st <- list(
    a = exp(stats::coef(m1)[1]),
    b = stats::coef(m1)[2]
    )

  # fit model 2 from Beacham & Murray (1990) to data using nls
  m2 <- stats::nls(y ~ a / (x - b), data = df, start = st)
  # summary(m2)

  # get coefficients
  log_a <- log(stats::coef(m2)[1])
  b <- stats::coef(m2)[2]

  # model expression and specs for predict_phenology()
  func <- paste("1 / exp(", log_a, " - log(x + ", b * -1, "))", sep = "")
  func <- tibble::tibble(
    species = species,
    dev.type = dev.type,
    func = func
    )

  # plot predictions and data --------------------------

  grid <- data.frame(x = seq(min(df$x), max(df$x), 0.1))
  grid$pred <- stats::predict(m2, newdata = grid)
  p_pred <- df |>
    ggplot2::ggplot(ggplot2::aes(x = .data$x, y = .data$y)) +
    ggplot2::geom_point() +
    ggplot2::geom_line(data = grid, ggplot2::aes(x = .data$x, y = .data$pred), col = "blue") +
    ggplot2::theme_classic()
  p_pred

  # model diagnostics --------------------------------

  # Predicted values
  y <- df$y
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
    log_a = log_a[[1]],
    b = b[[1]],
    mse = mse,
    rmse = rmse,
    r_squared = r_squared,
    func = func,
    pred_plot = p_pred
  )

  return(out)
}
