# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'
#   Document                   'Cmd + Shift + D'   devtools::document()


#' @title alpha_vantagerxtra
#' @name alpha_vantagerxtra
#' @details
#'
#' First make sure you have set your API token. If you haven't got one yet signup up to https://www.alphavantage.co/
#'
#' @keywords internal
#' @examples
#'
#'
#' Sys.setenv("ALPHA_VANTAGE_TOKEN" = "ABCD12345")
#'
#' ipo_calendar <- av_get_ipo_calendar()
#' facebook_balance_sheet <- av_get_balance_sheet("FB")
#' jpmorgan_cash_flow <- av_get_cash_flow("JPM")
#' twtr_earnings <- av_get_earnings("TWTR")
#' morgan_stanley_income_statement <- av_get_income_statement("MS")
#' amazon_overview <- av_get_overview("AMZN")
#'
#' # Enable and utilise the file based caching
#'
#' set_data_folder("/tmp")
#' set_use_cache()
#' av_get_balance_sheet("TWTR")
#' av_get_cash_flow("TWTR")
#' twtr <- av_cache_retrieve("TWTR")
#'

"_PACKAGE"

#' @rdname av_get_response
#' @description
#' Fetch response from AlphaVantage API endpoint.
#' Primarily for internal use.
#'
#' @return httr response object
#'
#' @export
av_get_response <- function(symbol, av_fun, ...) {
  alphavantager::av_api_key(Sys.getenv("ALPHA_VANTAGE_TOKEN"))

  if (missing(symbol)) symbol <- NULL

  # Checks
  if (is.null(alphavantager::av_api_key())) {
    stop("Set API key using av_api_key(). If you do not have an API key, please claim your free API key on (https://www.alphavantage.co/support/#api-key). It should take less than 20 seconds, and is free permanently.",
         call. = FALSE)
  }

  # Setup
  dots <- list(...)
  ua   <- httr::user_agent("https://github.com/business-science")

  # Overides
  dots$symbol      <- symbol
  dots$apikey      <- alphavantager::av_api_key()

  url_params <- stringr::str_c(names(dots), dots, sep = "=", collapse = "&")
  url <- glue::glue("https://www.alphavantage.co/query?function={av_fun}&{url_params}")

  # Alpha Advantage API call
  httr::GET(url, ua)
}

#' @rdname av_json
#' @name av_json
#' @title av_json
#' @description Extract json from httr response.  Primarily for internal use.
#'
#' @return mixed
#'
#' @export
av_json <- function(response) {
  content <- httr::content(response, as = "text", encoding = "UTF-8")
  content |> jsonlite::fromJSON()
}

#' @rdname av_section
#' @name av_section
#' @title av_section
#' @description Primarily for internal use.
#'
#' @return tibble
#'
#' @export
av_section <- function(json, section) {
  json[[section]]
}

#' @title av_format
#' @name av_format
#' @description
#' Primarily for internal use. Performs some data hygiene on
#' Alpha vantage API response and converts column names to snake case.
#'
#' @return tibble
#'
#' @export
av_format <- function(data) {
  log_msg("debug", "av_format")
  data |>
    dplyr::mutate(dplyr::across(dplyr::everything(), ~replace(., . ==  "None" , NA))) |>
    dplyr::mutate_if(is_all_numeric, as.numeric) |>
    janitor::clean_names() |>
    dplyr::mutate(dplyr::across(dplyr::contains("_date"), lubridate::as_date)) |>
    dplyr::mutate(dplyr::across(dplyr::contains("latest_quarter"), lubridate::as_date)) |>
    dplyr::mutate(dplyr::across(dplyr::contains("last_split_factor"), as.character))
}


#' @title av_get_balance_sheet
#' @name av_get_balance_sheet
#' @description Get Balance Sheet
#'
#' @param symbol A ticker symbol e.g. FB
#' @return tibble
#' @examples
#' av_get_balance_sheet("FB")
#'
#' @export
av_get_balance_sheet <- function(symbol) {
  log_msg("debug", "av_get_balance_sheet enter")
  data <- av_get_response(symbol, av_fun = "BALANCE_SHEET") |>
    av_json() |>
    av_section("annualReports") |>
    av_format() |>
    dplyr::mutate(symbol = symbol)

  if (pkg.env$use_cache) {
    read_file_and_append_rows(data,  av_data_set_files()$balance_sheet,
                            distinct_func = (function(x) dplyr::distinct(x, symbol, fiscal_date_ending, .keep_all = TRUE)))
  }
  return(data)
}

#' @title av_get_cash_flow
#' @name av_get_cash_flow
#' @description Get Cash Flow financial document
#'
#' @param symbol A ticker symbol e.g. JPM
#' @return tibble
#' @examples
#' av_get_cash_flow("JPM")
#'
#' @export
av_get_cash_flow <- function(symbol) {
  log_msg("debug", "av_get_cash_flow enter")
  data <- av_get_response(symbol, av_fun = "CASH_FLOW") |>
    av_json() |>
    av_section("annualReports") |>
    av_format() |>
    dplyr::mutate(free_cash_flow = operating_cashflow - capital_expenditures) |>
    dplyr::mutate(symbol = symbol)
  if (pkg.env$use_cache) {
    read_file_and_append_rows(data,  av_data_set_files()$cash_flow,
                            distinct_func = (function(x) dplyr::distinct(x, symbol, fiscal_date_ending, .keep_all = TRUE)))
  }
  return(data)
}

#' @title av_get_overview
#' @name av_get_overview
#' @description Get business overview
#'
#' @param symbol A ticker symbol e.g. AMZN
#' @return tibble
#' @examples
#' av_get_overview("AMZN")
#'
#' @export
av_get_overview <- function(symbol) {
  log_msg("debug", "av_get_overview enter")
  data <- av_get_response(symbol, av_fun = "OVERVIEW") |>
    av_json() |>
    tibble::as_tibble() |>
    av_format()
  log_msg("debug", "got data")

  if (pkg.env$use_cache) {
    existing_data <- read_data(av_data_set_files()$overview)
    if (!is.null(existing_data)) {
      existing_data <- existing_data |>
        dplyr::mutate(dplyr::across(dplyr::contains("last_split_factor"), as.character))
    }
    append_rows(existing_data, data, av_data_set_files()$overview,
                distinct_func = (function(x) dplyr::distinct(x, symbol, .keep_all = TRUE)))
  }
  return(data)
}


#' @title av_get_earnings
#' @name av_get_earnings
#' @description Get earnings
#'
#' @param symbol A ticker symbol e.g. TWTR
#' @return tibble
#' @examples
#' av_get_earnings("TWTR")
#'
#' @export
av_get_earnings <- function(symbol) {
  log_msg("debug", "av_get_earnings enter")
  data <- av_get_response(symbol, av_fun = "EARNINGS") |>
    av_json() |>
    av_section("annualEarnings") |>
    av_format() |>
    dplyr::mutate(symbol = symbol) |>
    dplyr::relocate(symbol)
  log_msg("debug", "got data")

  if (pkg.env$use_cache) {
    read_file_and_append_rows(data, av_data_set_files()$earnings,
                              distinct_func = (function(x) dplyr::distinct(x, symbol, fiscal_date_ending, .keep_all = TRUE)))
  }
  return(data)
}


#' @title av_get_income_statement
#' @name av_get_income_statement
#' @description Get Income statement for company
#'
#' @param symbol A ticker symbol e.g. MS
#' @return tibble
#' @examples
#' av_get_income_statement("MS")
#'
#' @export
av_get_income_statement <- function(symbol) {
  log_msg("debug", "av_get_income_statement enter")
  data_deserialised <- av_get_response(symbol, av_fun = "INCOME_STATEMENT") |>
    av_json()

  data <- dplyr::bind_rows(
    data_deserialised$annualReports |>
      dplyr::mutate(symbol = symbol, periodicity = "annual") |>
      dplyr::relocate(symbol, periodicity),
    data_deserialised$quarterlyReports |>
      dplyr::mutate(symbol = symbol, periodicity = "quarterly") |>
      dplyr::relocate(symbol, periodicity)) |>
    av_format()

  log_msg("debug", "got data")

  if (pkg.env$use_cache) {
    read_file_and_append_rows(data, av_data_set_files()$income_statement,
                              distinct_func = (function(x) dplyr::distinct(x, symbol, periodicity, fiscal_date_ending, .keep_all = TRUE)))
  }
  return(data)
}



#' @title av_get_ipo_calendar
#' @name av_get_ipo_calendar
#' @description Get IPO Calendar
#'
#' @return tibble
#' @examples
#' av_get_ipo_calendar()
#'
#' @export
av_get_ipo_calendar <- function() {
  log_msg("debug", "av_get_ipo_calendar enter")
  data <- av_get_response(av_fun = "IPO_CALENDAR") |>
    httr::content( as = "text", encoding = "UTF-8") |>
    readr::read_csv() |>
    janitor::clean_names()

  if (pkg.env$use_cache) {
    read_file_and_append_rows(data, av_data_set_files()$ipo_calendar,
                              distinct_func = (function(x) dplyr::distinct(x, symbol, .keep_all = TRUE)))
  }
  return(data)
}

#' @title av_get_annual_reports
#' @name av_get_annual_reports
#' @description Get primary financial documents for a given symbol including
#' Balance Sheet, Cash Flow,
#' @param symbol A ticker symbol e.g. AAPL
#' @return structure with 3 tibbles
#' @examples
#' av_get_annual_reports("IBM")
#'
#' @export
av_get_annual_reports <- function(symbol) {
  reports <- list()
  reports$cash_flow <- av_get_cash_flow(symbol)
  reports$overview <- av_get_overview(symbol)
  reports$balance_sheet <- av_get_balance_sheet(symbol)
  reports
}


#' @title av_data_set_files
#' @name av_data_set_files
#' @description Cache file names. Primarily for internal use only.
#'
#' @return tibble
#' @examples
#' av_data_set_files()
#'
#' @export
av_data_set_files <- function() {
  list(
    balance_sheet = "av_balance_sheet.tsv",
    cash_flow = "av_cash_flow.tsv",
    overview = "av_overview.tsv",
    income_statement = "av_income_statement.tsv",
    earnings = "av_earnings.tsv",
    ipo_calendar = "av_ipo_calendar.tsv"
  )
}

#' @title av_cache_retrieve_report
#' @name av_cache_retrieve_report
#' @description Retrieve cache file by report type.
#' @param data_set balance_sheet|cash_flow|overview|income_statement|earnings|ipo_calendar
#'
#' @return tibble
#' @examples
#' av_cache_retrieve_report("ipo_calendar")
#'
#'
#' @export
av_cache_retrieve_report <- function(data_set) {
  if (cache_file_exists(av_data_set_files()[data_set])) {
    return(read_data(av_data_set_files()[data_set]))
  } else {
    return(NULL)
  }
}

#' @title av_cache_retrieve
#' @name av_cache_retrieve
#' @description Retrieve all cached reports for company
#' @param insymbol A ticker symbol e.g. AAPL
#'
#' @return tibble
#' @examples
#' av_cache_retrieve("AAPL")
#'
#' @export
av_cache_retrieve <- function(insymbol) {
  #reports <- structure(rep(NULL, length(av_data_set_files())), names = names(av_data_set_files()))
  reports <- list()
  report_set <- av_data_set_files() |> remove_list_element("ipo_calendar")
  reports <- sapply(report_set, function(x) {reports[[x]] <- NULL})
  for (data_set in names(reports)) {
    if (cache_file_exists(av_data_set_files()[data_set])) {
      reports[[data_set]] <- read_data(av_data_set_files()[data_set]) |> dplyr::filter(symbol==insymbol)
    }
  }
  reports
}

