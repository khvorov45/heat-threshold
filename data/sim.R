# Simulate some hospital admission-like data

library(tidyverse)
library(lubridate)

# Directories used
data_dir <- here::here("data")

# Functions ===================================================================

simulate <- function(start_date, end_date) {
  tibble(
    date = seq(start_date, end_date, by = "days"),
    day_offset = (date - start_date) / ddays(1),
    temperature_exp = 20 + # Baseline
      1 / 800 * day_offset + # Yearly increase
      10 * sin(2 * pi / 365 * (day_offset + 50)), # Cyclical variation
    temperature = rnorm(length(date), temperature_exp, 3),
    logdeaths_exp = 3 + # Baseline
      0.03 * temperature + # Temperature impact
      1 / 4000 * day_offset, # Linear time impact (e.g. population growth)
      + 1 * sin(2 * pi / 180 * (day_offset - 130)), # Cyclical variation
    deaths_exp = exp(logdeaths_exp),
    deaths = rpois(length(date), deaths_exp)
  )
}

save_sim <- function(data, name) {
  write_csv(data, file.path(data_dir, glue::glue("sim-{name}.csv")))
}

# Script ======================================================================

simulated <- simulate(ymd("2000-01-01"), ymd("2005-12-31"))
save_sim(simulated, "one")
