test_that("fit_model works", {
  temp <- c(2, 5, 8, 11, 14)
  days <- c(194, 87, 54, 35, 28)
  df <- tibble::tibble(temp, days)
  m <- fit_model(df = df, temp = temp, days = days, species = "sockeye", dev.type = "hatch")

  expect_type(m, "list")

  expect_s3_class(m$func, "data.frame")
  # expect_length(m$func, 1)

  expect_type(m$m2_b, "double")
  expect_type(m$m2_a, "double")
  expect_type(m$r_squared, "double")
  expect_type(m$mse, "double")
  expect_type(m$rmse, "double")

  expect_type(m$model, "list")
  expect_s3_class(m$model, "nls")

  expect_s3_class(m$pred_plot, "gg")
  expect_invisible(plot(m$pred_plot))

})
