read_data <- function(name) {
  read_csv(
    file.path("data", glue::glue("{name}.csv")),
    col_types = cols(
      day_offset = col_integer(),
      deaths = col_integer()
    )
  )
}
