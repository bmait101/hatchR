test_that("basic use of plot_phenology", {

  x <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye", model_id = 2, development_type = "hatch")
  y <- suppressWarnings(predict_phenology(
    data = woody_island,dates = date,
    temperature = temp_c, spawn.date = "1990-08-18", model = x))
  p <- plot_phenology(y, style = "all")

  expect_true(ggplot2::is_ggplot(p))

})
