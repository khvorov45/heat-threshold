# Simulate some hospital admission-like data

library(tidyverse)
library(lubridate)

# Directories used
data_dir <- here::here("data")

# Functions ===================================================================

simulate <- function(start_date, end_date) {
  tibble(
    date = seq(start_date, end_date, by = "days"),
    year = year(date),
    month = month(date),
    temperature_exp = 20 + (1 / 365 * ((date - start_date) / ddays(1)))
  )
}

save_sim <- function(data, name) {
  write_csv(data, file.path(data_dir, glue::glue("sim-{name}.csv")))
}

# Script ======================================================================

simulated <- simulate(ymd("2000-01-01"), ymd("2005-12-31"))
save_sim(simulated, "one")
