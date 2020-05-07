# Simulate some hospital admission-like data

library(tidyverse)

# Directories used
data_dir <- here::here("data")
data_plot_dir <- here::here("data-plot")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

plot_temperature <- function(data) {
  data %>%
    ggplot(aes(date, temperature)) +
    ggdark::dark_theme_bw(verbose = FALSE) +
    theme(
      axis.text.x = element_text(angle = 90)
    ) +
    scale_x_date("Date", breaks = "1 year") +
    scale_y_continuous("Temperature") +
    labs(caption = "Dotted line is the expected temperature") +
    geom_line(alpha = 0.5) +
    geom_line(aes(y = temperature_exp), col = "red", linetype = "11")
}

save_plot <- function(plot, name) {
  ggdark::ggsave_dark(
    file.path(data_plot_dir, glue::glue("{name}.pdf")), plot,
    width = 10, height = 10, units = "cm"
  )
}

# Script ======================================================================

sim_one <- read_data("sim-one")
sim_one_plot_t <- plot_temperature(sim_one)
save_plot(sim_one_plot_t, "sim-one-temp")
