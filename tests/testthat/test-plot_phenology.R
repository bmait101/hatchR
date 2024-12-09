test_that("plot_phenology works", {
  x <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye", model_id = 2, development_type = "hatch")
  y <- suppressWarnings(predict_phenology(
    data = woody_island,dates = date,
    temperature = temp_c, spawn.date = "1990-08-18", model = x))
  p <- plot_phenology(y, style = "all")

  expect_type(p, "list")
  expect_s3_class(p, "gg")
  plot_names <- names(p)
  expect_s3_class(p$data, "data.frame")

})
