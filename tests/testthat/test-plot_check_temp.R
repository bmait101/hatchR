test_that("basic usage of plot_check_temp()", {
  p <- plot_check_temp(crooked_river, date, temp_c)
  expect_true(ggplot2::is_ggplot(p))
  expect_s3_class(p$data, "data.frame")
})
