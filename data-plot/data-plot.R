# Plot the data

library(tidyverse)

# Directories used
data_dir <- here::here("data")
data_plot_dir <- here::here("data-plot")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

plot_timeseries <- function(data, yname = "temperature") {
  yname_exp <- paste0(yname, "_exp")
  data %>%
    ggplot(aes(date, !!rlang::sym(yname))) +
    ggdark::dark_theme_bw(verbose = FALSE) +
    theme(
      axis.text.x = element_text(angle = 90)
    ) +
    scale_x_date("Date", breaks = "1 year") +
    scale_y_continuous(tools::toTitleCase(yname)) +
    labs(caption = paste0("Dotted line is the expected ", yname)) +
    geom_point(alpha = 0.1, shape = 18) +
    geom_line(aes(y = !!rlang::sym(yname_exp)), col = "red", linetype = "11")
}

plot_xy <- function(data) {
  data %>%
    ggplot(aes(temperature, deaths)) +
    ggdark::dark_theme_bw(verbose = FALSE) +
    theme(
      panel.grid.minor.y = element_blank()
    ) +
    scale_x_continuous("Temperature") +
    scale_y_log10("Deaths") +
    geom_point(alpha = 0.1, shape = 18)
}

save_plot <- function(plot, name) {
  ggdark::ggsave_dark(
    file.path(data_plot_dir, glue::glue("{name}.pdf")), plot,
    width = 10, height = 10, units = "cm"
  )
}

# Script ======================================================================

sim_one <- read_data("sim-one")

sim_one_plots <- list(
  "sim-one-temp" = plot_timeseries(sim_one),
  "sim-one-deaths" = plot_timeseries(sim_one, "deaths"),
  "sim-one-xy" = plot_xy(sim_one)
)

iwalk(sim_one_plots, save_plot)
