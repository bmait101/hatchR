test_that("predict phenology works", {
  m <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye",
    model_id = 2,
    development_type = "hatch"
    )
  p <- suppressWarnings(predict_phenology(
    data = woody_island,dates = date,
    temperature = temp_c,
    spawn.date = "1990-08-18",
    model = m$expression
    )
    )

  expect_type(p, "list")
  expect_length(p, 4)

  # expect_type(p$days_to_develop, "integer")

  # expect_type(p$ef.vals, "double")

  expect_s3_class(p$ef_table, "data.frame")

  expect_s3_class(p$dev.period, "data.frame")
  expect_equal(ncol(p$dev.period), 2)

  # expect_s3_class(p$model_specs, "data.frame")
  # expect_equal(ncol(p$model_specs), 5)


})
