% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alphavantagerxtra.R
\docType{package}
\name{alpha_vantagerxtra}
\alias{alphavantagerxtra}
\alias{alphavantagerxtra-package}
\title{alpha_vantagerxtra}
\description{
Provide features missing from the core Alphavantager 
    library.
}
\details{
First make sure you have set your API token. If you haven't got one yet signup up to https://www.alphavantage.co/
}
\examples{


Sys.setenv("ALPHA_VANTAGE_TOKEN" = "ABCD12345")

ipo_calendar <- av_get_ipo_calendar()
facebook_balance_sheet <- av_get_balance_sheet("FB")
jpmorgan_cash_flow <- av_get_cash_flow("JPM")
twtr_earnings <- av_get_earnings("TWTR")
morgan_stanley_income_statement <- av_get_income_statement("MS")
amazon_overview <- av_get_overview("AMZN")

# Enable and utilise the file based caching

set_data_folder("/tmp")
set_use_cache()
av_get_balance_sheet("TWTR")
av_get_cash_flow("TWTR")
twtr <- av_cache_retrieve("TWTR")

}
\keyword{internal}
