library(readr)

crooked_river <- read_csv("data-raw/crooked_river.csv")

usethis::use_data(crooked_river, overwrite = TRUE)
