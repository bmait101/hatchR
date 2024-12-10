test_that("predict phenology works", {
  m <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye", model_id = 2,
    development_type = "hatch"
  )
  expect_warning(predict_phenology(
    data = woody_island, dates = date,
    temperature = temp_c, spawn.date = "1990-08-18", model = m
  ))
  p <- suppressWarnings(predict_phenology(
    data = woody_island, dates = date,
    temperature = temp_c, spawn.date = "1990-08-18",
    model = m
  ))
  expect_type(p, "list")
  expect_length(p, 4)
  expect_s3_class(p$ef_table, "data.frame")
  expect_s3_class(p$dev.period, "data.frame")
  expect_equal(ncol(p$dev.period), 2)
})


test_that("errors work", {
  m <- model_select(
    author = "Beacham and Murray 1990", species = "sockeye",
    model_id = 2, development_type = "hatch"
  )
  expect_error(predict_phenology(
    data = woody_island |> dplyr::mutate(date = as.character(date)),
    dates = date, temperature = temp_c, spawn.date = "1990-08-18", model = m
  ))
  expect_error(predict_phenology(
    data = woody_island, dates = date, temperature = temp_c,
    spawn.date = lubridate::ymd("1990-08-18"),
    model = m
  ))
  expect_error(predict_phenology(
    data = woody_island, dates = date, temperature = temp_c,
    spawn.date = "1990-08-18",
    model = NULL
  ))
  expect_error(predict_phenology(
    data = woody_island, dates = date, temperature = temp_c,
    spawn.date = "1990-08-18",
    model = m |> dplyr::rename(func = expression)
  ))
})
