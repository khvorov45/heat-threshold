read_data <- function(name) {
  read_csv(
    file.path("data", glue::glue("{name}.csv")),
    col_types = cols(
      year = col_integer(),
      month = col_integer(),
      day_offset = col_integer()
    )
  )
}
