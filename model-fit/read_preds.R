read_preds <- function(name) {
  read_csv(
    file.path("model-fit", glue::glue("preds-{name}.csv")),
    col_types = cols()
  )
}
