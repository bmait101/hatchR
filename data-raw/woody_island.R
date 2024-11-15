library(readr)

woody_island <- read_csv("data-raw/woody_island.csv")
woody_island$date <- as.Date(woody_island$date, format = "%m/%d/%Y")

usethis::use_data(woody_island, overwrite = TRUE)
