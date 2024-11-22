test_that("predict phenology works", {
  m <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye",model = 2,dev.type = "hatch")
  p <- suppressWarnings(predict_phenology(
    data = woody_island,dates = date,
    temperature = temp_c,spawn.date = "1990-08-18",model = m))

  expect_type(p, "list")
  expect_length(p, 4)

  expect_type(p$days2done, "integer")

  expect_type(p$ef.vals, "double")

  expect_s3_class(p$ef.tibble, "data.frame")
  expect_equal(ncol(p$ef.tibble), 4)

  expect_s3_class(p$dev.period, "data.frame")
  expect_equal(ncol(p$dev.period), 2)

})
