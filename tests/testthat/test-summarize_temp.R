test_that("multiplication works", {
  s <- summarize_temp(data = crooked_river, dates = date, temperature = temp_c)
  expect_s3_class(s, "data.frame")
  expect_identical(class(s$date), "Date")
})
