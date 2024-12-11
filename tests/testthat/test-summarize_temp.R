test_that("summary function works", {
  s <- summarize_temp(data = idaho, dates = date, temperature = temp_c)
  expect_s3_class(s, "data.frame")
  expect_identical(class(s$date), "Date")
  expect_equal(nrow(s), 1826)
})
