load_all()

# get model parameterization
sockeye_hatch_mod <- model_select(
  author = "Beacham and Murray 1990",
  species = "sockeye",
  model = 2,
  development_type = "hatch"
)
# predict phenology
sockeye_hatch <- predict_phenology(
  data = woody_island,
  dates = date,
  temperature = temp_c,
  spawn.date = "1990-08-18",
  model = sockeye_hatch_mod
)

# vector of temperatures
temp <- c(2, 5, 8, 11, 14)
# vector of days to hatch
days <- c(194, 87, 54, 35, 28)
hatch <- tibble::tibble(temp, days)
hatch <- fit_model(df = hatch, temp = temp, days = days, species = "fish")
hatch$expression

crooked_river$date <- as.character(crooked_river$date)
crooked_river$date <- as.Date(crooked_river$date)

plot_check_temp(
  data = crooked_river,
  dates = date,
  temperature = temp_c
)

# remove a 20 random rows from crooked_river
tmp <- crooked_river[-sample(1:nrow(crooked_river), 20),]

check_continuous(tmp, date)

chk <- check_continuous(tmp, date)
chk
