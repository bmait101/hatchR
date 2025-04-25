library(hatchR); library(tidyverse); library(patchwork)

bt_hatch_mod <- model_select(
  author = "Beacham and Murray 1990",
  species = "sockeye",
  model = 2,
  development_type = "hatch"
)

x = c(4:16)

bt_example <- tibble(temp =x)



bt_data <- bt_example |>
  mutate(ef_val = eval(parse(text = bt_hatch_mod$expression))) |>
  mutate(days = ceiling(1/ef_val)) |>
  mutate(ATU = temp*days)

p1 <- bt_data |>
  ggplot(aes(x = temp, y = days)) +
  geom_point() +
  geom_line() +
  labs(x = "Average Incubation Temperature (°C)", y = "Days to Hatch") +
  theme_classic()

p2 <- bt_data |>
  ggplot(aes(x = temp, y = ATU)) +
  geom_point() +
  geom_line() +
  labs(x = "Average Incubation Temperature (°C)", y = "ATUs") +
  theme_classic()

plots <- p1 + p2

plots & theme_classic(base_size = 22)

bt_data |>
  ggplot(aes(x = temp, y = ef_val)) +
  geom_point() +
  geom_line() +
  labs(x = "Daily Average Incubation Temperature (°C)", y = "Effective Value") +
  theme_classic(base_size = 22)

crooked_river |>
  filter(date >= ymd("2014-08-01", tz = "UTC") & date <= ymd("2015-02-25", tz = "UTC")) |>
  ggplot(aes(x = date, y = temp_c)) +
  geom_point() +
  geom_line() +
  labs(x = "Date", y = "Temperature (°C)") +
  theme_classic(base_size = 22)

