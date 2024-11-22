test_that("plot_check_temp() works", {
  p <- plot_check_temp(crooked_river, date, temp_c)
  expect_type(p, "list")
  expect_s3_class(p, "gg")
  plot_names <- names(p)
  expect_identical(plot_names, c("data", "layers", "scales", "guides",
                                 "mapping", "theme", "coordinates",
                                 "facet", "plot_env", "layout", "labels"))
  expect_s3_class(p$data, "data.frame")
  plot_geoms <- sapply(p$layers, function(x) class(x$geom)[1])
  expect_identical(plot_geoms, c("GeomPoint", "GeomLine", "GeomHline", "GeomHline"))
  expect_invisible(plot(p))
})
