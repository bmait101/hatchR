test_that("model_select returns an expression of length 1", {
  m <- model_select(author = "Beacham and Murray 1990", species = "sockeye", model = 2, dev.type = "hatch")
  expect_length(m, 1)
  expect_type(m, "expression")
})
