## code to prepare `idaho` dataset goes here

idaho <- readr::read_csv("C:/Users/BryanMaitland/Downloads/Isaak_et_al_2018_long 1.csv")

idaho <- idaho |>
  na.omit() |>
  dplyr::rename(date = SampleDate, temp_c = temperature)

usethis::use_data(idaho, overwrite = TRUE, compress = "xz")
