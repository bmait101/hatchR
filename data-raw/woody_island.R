woody_island <- readr::read_csv(
  "data-raw/woody_island.csv",
  col_types = readr::cols(
    date = readr::col_date(format = "%m/%d/%Y"),
    temp_c = readr::col_double()
  )
)

usethis::use_data(woody_island, overwrite = TRUE)
