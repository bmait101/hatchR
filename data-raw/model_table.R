## code to prepare `model_table` dataset goes here

library(readr)

model_table <- read_csv("data-raw/model_table.csv")

usethis::use_data(model_table, overwrite = TRUE)
