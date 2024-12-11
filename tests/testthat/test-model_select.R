test_that("model_select returns an expression of length 1", {
  mod <- model_select(
    author = "Beacham and Murray 1990",
    species = "sockeye",
    model_id = 2,
    development_type = "hatch"
    )
  expect_s3_class(mod, "data.frame")
  expect_equal(nrow(mod), 1)
})
