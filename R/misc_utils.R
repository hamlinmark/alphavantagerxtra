remove_list_element <- function(list, name) {
  list[names(list) != name]
}

is_all_numeric <- function(x) {
  !any(is.na(suppressWarnings(as.numeric(stats::na.omit(x))))) & is.character(x)
}

is_all_date <- function(x) {
  !any(is.na(suppressWarnings(lubridate::as_date(stats::na.omit(x))))) & is.character(x)
}


get_log_level_numeric <- function(level) {
  match(level, c("trace", "debug", "info", "warning", "error"))
}

log_msg <- function(level, message) {
  if (get_log_level_numeric(level) >= get_log_level_numeric(pkg.env$log_level) ) {
    print(paste( format(Sys.time(), "%Y-%m-%d %H:%M:%S"), " ", "[", level,"] ", message, sep=""))
  }
}


human_readable_number <- function(number, accuracy=0.1) {
  scales::label_number_si(accuracy=accuracy)(number)
}

numbers_are_large <- function(numbers) {
  is.numeric(numbers) &&
    any(numbers > 9999)
}

#' @rdname human_readable_tibble
#' @description
#' Convert tibble column values to human readable numbers
#'
#' @return httr response object
#'
#' @export
human_readable_tibble <- function(data) {
  data |> dplyr::mutate_if(numbers_are_large, human_readable_number)
}
