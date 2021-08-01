
#' @description Read transactions from file
#'
#' @return tibble
#'
#' @noRd
#'
read_data <- function(filename) {
  if (file.exists(cache_shared_data(filename))) {
    suppressMessages(readr::read_tsv(cache_shared_data(filename)))
  } else {
    return (NULL)
  }
}

cache_file_exists <- function(filename) {
  file.exists(cache_shared_data(filename))
}

write_data <- function(data, filename) {
  readr::write_tsv(data, cache_shared_data(filename))
}

read_file_and_append_rows <- function(rows, filename, filter_func = NULL, distinct_func = NULL) {
  data <- suppressMessages(read_data(filename))
  append_rows(data, rows, filename, filter_func, distinct_func)
}


append_rows <- function(data, rows, filename, filter_func = NULL, distinct_func = NULL) {
  if (is.null(data)) {
    rows |> write_data(filename)
  } else {
    if (! is.null(filter_func)) {
      log_msg("trace", "run filter_func")
      data <- data |> filter_func()
    }
    log_msg("trace", "bind rows")
    # Put new rows in bind first so that they will be given precedence in following distinct function
    data <- dplyr::bind_rows(rows, data)

    if (! is.null(distinct_func)) {
      log_msg("trace", "run distinct_func")
      data <- data |> distinct_func()
    }

    data |>
      write_data(filename)
  }

}


# read_file_and_append_list_entry <- function(row_as_list, filename, filter_func) {
#   data <- read_data(filename)
#   write_list_entry(data, row_as_list, filename, filter_func)
# }

append_list_entry <- function(data, row_as_list, filename, filter_func) {
  if (is.null(data)) {
    data |> tibble::as_tibble() |> write_data(filename)
  } else {
    if (! is.null(filter_func)) {
      data <- data |> filter_func()
    }

    do.call("add_row", c(.data = list(data), row_as_list)) |>
      write_data(filename)
  }
}

cache_shared_data <- function(filename) {
  folder <- pkg.env$data_folder
  if (folder != "" && substr(folder, nchar(folder)-2, nchar(folder)) != "/") {
    folder <- paste(folder, "/", sep="")
  }
  paste(folder, filename, sep="")
}
