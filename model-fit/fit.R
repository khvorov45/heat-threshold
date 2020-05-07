# Fit a model to the data

library(tidyverse)

# Directories used
data_dir <- here::here("data")
fit_dir <- here::here("model-fit")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

gen_pred <- function(fit, og_data) {
  preds <- predict(fit, se.fit = TRUE)
  og_data %>%
    mutate(
      fit_log = preds$fit,
      fit_log_se = preds$se.fit,
      fit = exp(fit_log),
      fit_low = exp(fit_log - qnorm(0.975) * fit_log_se),
      fit_high = exp(fit_log + qnorm(0.975) * fit_log_se)
    )
}

save_preds <- function(preds, name) {
  write_csv(preds, file.path(fit_dir, glue::glue("preds-{name}.csv")))
}

# Script ======================================================================

sim_one <- read_data("sim-one")

fit_sim_one <- glm(
  deaths ~ temperature + day_offset
    + splines::ns(lubridate::yday(date), df = 6),
  poisson(), sim_one
)
fit_gam_sim_one <- mgcv::gam(
  deaths ~ temperature + day_offset + s(lubridate::yday(date)),
  poisson(), sim_one
)

preds_sim_one <- list(
  "glm-sim-one" = gen_pred(fit_sim_one, sim_one),
  "gam-sim-one" = gen_pred(fit_gam_sim_one, sim_one)
)

iwalk(preds_sim_one, save_preds)
