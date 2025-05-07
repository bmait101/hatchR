library(hatchR); library(tidyverse)


# Sockeye emergence -------------------------------------------------------

## model -------------------------------------------------------------------

sockeye_emerge_mod <- model_select(
  author = "Beacham and Murray 1990",
  species = "sockeye",
  model = 2,
  development_type = "emerge"
)


## ATU 10 model ------------------------------------------------------------

out <- NULL
for (t in seq(4, 16, by =2)){
  temps <- rep(t, times = 225)
  date <- seq(ymd("2000-01-01"), ymd("2000-08-12"), by = "days")

  t.df <- data.frame(temps, date)

  res <- predict_phenology(data = t.df,
                           dates = date,
                           temperature = temps,
                           spawn.date = "2000-01-01",
                           model = sockeye_emerge_mod)

  d2d <- res$days_to_develop
  ATU_10 <- 110*10

  res_df <- data.frame(temp = t,
                       ATU_mod_days = ATU_10/t,
                       ef_mod_days = d2d,
                       mod_diff = ATU_10/t - d2d)

  out <- rbind(out, res_df)
}
out

p <- out |>
  ggplot(aes(x = temp, y = mod_diff, )) +
  geom_point() +
  geom_line()+
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(x = "Average Incubation Temperature (°C)", y = "Days off by ATU model",
       title = "ATU Emergence Model (10 °C)") +
  #scale_color_brewer(palette = "Dark2") +
  theme_classic()

ggsave("~/Downloads/ATU_ef_mods_diff_10C.png", p, width = 24, height = 16, units = "in", dpi = 1000)


## For all ATU mods --------------------------------------------------------

out_1 <- NULL
for (t in seq(4, 16, by =2)){

  atu_df <- out |>
    select(temp, ef_mod_days) |>
    mutate(ATUs = temp * ef_mod_days)

  atu_mod <- atu_df |>
    filter(temp == t) |>
    pull(ATUs)

  atu_res <- atu_df |>
    mutate(ATU_days = atu_mod/temp,
           ATU_mod_dif = ef_mod_days - ATU_days,
           ATU_mod = t)



  out_1 <- rbind(out_1, atu_res)
}
out_1
out_1$ATU_mod <- as.factor(out_1$ATU_mod)

p1 <- out_1 |>
  ggplot(aes(x = temp, y = ATU_mod_dif, color =ATU_mod, group = ATU_mod)) +
  geom_point(size = 1.75) +
  geom_line(size = 1)+
  geom_hline(yintercept = 0, linetype = "dashed", size =1) +
  labs(x = "Average Incubation Temperature (°C)", y = "Days off by ATU model",
       title = "Days Difference between Effective Value and ATU Models") +
  scale_color_brewer(palette = "RdBu", direction = -1, name = "ATU Model") +
  theme_classic(base_size = 20) +
  theme(legend.position = "inside", legend.position.inside =  c(.8, .4))

ggsave("~/Downloads/ATU_ef_mods_diff.png", p1, width = 12, height = 6, units = "in", dpi = 2000)



# RBT Hatch example -------------------------------------------------------

## run same with RBT -------------------------------------------------------
rbt_hatch <- tibble(temp = c(2,5,8,11,14),
                    days = c(115,68,42,28,22))

rbt_hatch_mod <- fit_model(temp = rbt_hatch$temp,
                           days = rbt_hatch$days,
                           species = "mykiss",
                          development_type = "hatch"
)


out_rbt <- NULL
for (t in seq(4, 16, by =2)){
  temps <- rep(t, times = 225)
  date <- seq(ymd("2000-01-01"), ymd("2000-08-12"), by = "days")

  t.df <- data.frame(temps, date)

  res <- predict_phenology(data = t.df,
                           dates = date,
                           temperature = temps,
                           spawn.date = "2000-01-01",
                           model = rbt_hatch_mod$expression)

  d2d <- res$days_to_develop
  ATU_10 <- 35*10

  res_df <- data.frame(temp = t,
                       ATU_mod_days = ATU_10/t,
                       ef_mod_days = d2d,
                       mod_diff = ATU_10/t - d2d)

  out_rbt <- rbind(out_rbt, res_df)
}
out_rbt


out_1_rbt <- NULL
for (t in seq(4, 16, by =2)){

  atu_df <- out_rbt |>
    select(temp, ef_mod_days) |>
    mutate(ATUs = temp * ef_mod_days)

  atu_mod <- atu_df |>
    filter(temp == t) |>
    pull(ATUs)

  atu_res <- atu_df |>
    mutate(ATU_days = atu_mod/temp,
           ATU_mod_dif = ef_mod_days - ATU_days,
           ATU_mod = t)



  out_1_rbt <- rbind(out_1_rbt, atu_res)
}
out_1_rbt
out_1_rbt$ATU_mod <- as.factor(out_1_rbt$ATU_mod)

out_1_rbt |>
  ggplot(aes(x = temp, y = ATU_mod_dif, color =ATU_mod, group = ATU_mod)) +
  geom_point() +
  geom_line()+
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(x = "Average Incubation Temperature (°C)", y = "Days off by ATU model",
       title = "Days Difference between Effective Value and ATU Models (RBT hatch)") +
  #scale_color_brewer(palette = "Dark2") +
  theme_bw()
