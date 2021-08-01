pkg.env <- new.env()

pkg.env$data_folder <- Sys.getenv("MOB_ALPHAVANTAGE_DATA_FOLDER")
pkg.env$use_cache <- FALSE
pkg.env$log_level <- "info"


#' @export
set_data_folder <- function(folder) {
  pkg.env$data_folder <- folder
}

#' @export
set_use_cache <- function(enable = TRUE) {
  pkg.env$use_cache <- enable
}

#' @export
set_log_level <- function(level) {
  if (is.na(get_log_level_numeric(level))) {
    log_msg ("error", "invalid level")
    return()
  }
  pkg.env$log_level <- level
}


