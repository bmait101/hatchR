library(hatchR); library(tidyverse)


# Rana sylvatica ----------------------------------------------------------

# Moore, 1939 Ecology
# https://www.jstor.org/stable/1930439?seq=1

rana_s_data <- tibble(temp = c(9, 21 ,26),
                    days = c(15,13,4))

rana_s_data <- tibble(temp = c(10,15.3,18.5,19.9, 23.7),
                    hours = c(305,128,87,79,52)) |>
  mutate(days = ceiling(hours/24))

rana_s_mod <- fit_model(temp = rana_s_data$temp,
                      days = rana_s_data$days,
                      species = "Rana_sylvatica",
                      development_type = "hatch")


# Ranan pipiens -----------------------------------------------------------
# from Moore 1939

rana_pip_data <- tibble(temp = c(15.3,18.6,19.8, 26),
                      hours = c(168,116,99,57)) |>
  mutate(days = ceiling(hours/24))

rana_pip_mod <- fit_model(temp = rana_pip_data$temp,
                        days = rana_pip_data$days,
                        species = "Rana_pipiens",
                        development_type = "hatch")

# Rana clamitans ----------------------------------------------------------
# from Moore 1939

rana_c_data <- tibble(temp = c(15,19.8, 25.3,33.4),
                        hours = c(263,112,62,45)) |>
  mutate(days = ceiling(hours/24))

rana_c_mod <- fit_model(temp = rana_c_data$temp,
                          days = rana_c_data$days,
                          species = "Rana_clamitans",
                          development_type = "hatch")


# Rana palustris ----------------------------------------------------------
# from Moore 1939

rana_p_data <- tibble(temp = c(15.5,18.6, 19.9, 25.7),
                      hours = c(190,126,106,63)) |>
  mutate(days = ceiling(hours/24))

rana_p_mod <- fit_model(temp = rana_p_data$temp,
                        days = rana_p_data$days,
                        species = "Rana_palustris",
                        development_type = "hatch")
# Ascaphus truei ----------------------------------------------------------

# Brown 1975, Comparitive Biochemistry and Physicology Part A: Physiology
# https://www.sciencedirect.com/science/article/pii/030096297590033X

ascaphus_data <- tibble(temp = c(7.6,9.8,11,13,14.5,15,18),
                        days = c(44,27.1,22.6,16.1,13.4,12.7,10.7))

ascaphus_mod <- fit_model(temp = ascaphus_data$temp,
                      days = ascaphus_data$days,
                      species = "ascaphus",
                      development_type = "hatch")


# Eastern Fence lizard ----------------------------------------------------

# angilletta et al 2000, Ecology
# PDF :
efl_data <- tibble(temp = c(28,30,32,34),
                   days = c(55,48,41,40))

efl_mod <- fit_model(temp = efl_data$temp,
                          days = efl_data$days,
                          species = "efl",
                          development_type = "hatch")


# Lithobates example --------------------------------------------------------------------

temperature_data <- data.frame(temperatures = sort(rnorm(30, mean = 16, sd =3)),
                    dates = seq(ymd("2000-04-01"), ymd("2000-04-30"), by = "days"))

froggy_mods <- c(rana_s_mod$expression$expression,
                 rana_p_mod$expression$expression,
                 rana_c_mod$expression$expression,
                 rana_pip_mod$expression$expression)

froggy_hatch <- map(froggy_mods,
                    predict_phenology,
                    data = temperature_data,
                    dates = dates,
                    temperature = temperatures,
                    spawn.date = "2000-04-01") |>
  map_dbl("days_to_develop") |>
  sort(decreasing = TRUE) |>
  tibble()

colnames(froggy_hatch)[1] <- "days_to_develop"

froggy_hatch <- froggy_hatch |>
  mutate(start = ymd("2000-04-01"),
         stop = start + days_to_develop,
         species = c("Rana clamitans", "Rana palustris", "Rana pipiens", "Rana sylvaticus"),
         index = seq(20.5,17.5, by = -1))



ggplot() +
  geom_point(data = temp_data, aes(x = days, y = temps)) +
  geom_line(data = temp_data, aes(x = days, y = temps)) +
  geom_rect(data = froggy_hatch, aes(xmin = start, xmax = stop, ymax =index-.15, ymin = index-.5, fill = species)) +
  geom_label(data = froggy_hatch, aes(x = start + (stop - start) / 1.45, y = (index -0.325), label = days_to_develop)) +
  labs(x = "Date", y = "Temperature (°C)",
       title = "Development periods of four North American Frog Species") +
  scale_fill_manual(values = c("deepskyblue4", "grey23", "darkolivegreen4", "purple4")) +
  theme_classic() +
  theme(legend.position = c(0.75, 0.25))

