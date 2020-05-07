# Plot the predictions

# Fit a model to the data

library(tidyverse)

# Directories used
fit_dir <- here::here("model-fit")
pred_plot_dir <- here::here("pred-plot")

# Functions ===================================================================

source(file.path(fit_dir, "read_preds.R"))

plot_preds <- function(preds) {
  preds %>%
    ggplot(aes(date, fit)) +
    ggdark::dark_theme_bw(verbose = FALSE) +
    theme(
      axis.text.x = element_text(angle = 90)
    ) +
    scale_x_date("Date", breaks = "1 year") +
    scale_y_continuous("Deaths") +
    geom_point(aes(y = deaths), alpha = 0.1, shape = 18) +
    geom_ribbon(aes(ymin = fit_low, ymax = fit_high), alpha = 0.1) +
    geom_line()
}

save_plot_preds <- function(plot, name) {
  ggdark::ggsave_dark(
    file.path(pred_plot_dir, glue::glue("preds-{name}.pdf")), plot,
    width = 10, height = 10, units = "cm"
  )
}

# Script ======================================================================

sim_one_preds <- read_preds("sim-one")
plot_sim_one_preds <- plot_preds(sim_one_preds)
save_plot_preds(plot_sim_one_preds, "sim-one")
