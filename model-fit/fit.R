# Fit a model to the data

library(tidyverse)

# Directories used
data_dir <- here::here("data")
fit_dir <- here::here("model-fit")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

gen_pred <- function(fit) {
  preds <- predict(fit, se.fit = TRUE)
  fit$data %>%
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

fit_sim_one <- glm(deaths ~ temperature, poisson(), sim_one)
preds_sim_one <- gen_pred(fit_sim_one)
save_preds(preds_sim_one, "sim-one")
