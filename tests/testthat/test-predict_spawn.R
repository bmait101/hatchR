test_that("predict spawn works", {
  m <- model_select(
    author = "Beacham and Murray 1990", species = "sockeye",
    model_id = 2, development_type = "hatch"
  )
  expect_warning(predict_phenology(
    data = woody_island, dates = date,
    temperature = temp_c, spawn.date = "1990-08-18", model = m
  ))
  p <- suppressWarnings(predict_spawn(data = crooked_river,
                                      dates = date,
                                      temperature = temp_c,
                                      develop.date = "2015-03-21",
                                      model = m
  ))
  expect_type(p, "list")
  expect_length(p, 4)
  expect_s3_class(p$ef_table, "data.frame")
  expect_s3_class(p$dev_period, "data.frame")
  expect_equal(ncol(p$dev_period), 2)
})

