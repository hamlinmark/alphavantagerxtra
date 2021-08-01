Alpavantage Xtra
================

-   [Overview](#overview)
    -   [Use Cases](#use-cases)
-   [Basic Usage](#basic-usage)
-   [Set API Token](#set-api-token)
-   [IPO Calendar](#ipo-calendar)
-   [Company Overview](#company-overview)
-   [Company Balance Sheet](#company-balance-sheet)
-   [Company Cash Flow](#company-cash-flow)
-   [Company earnings](#company-earnings)
-   [Income Statement](#income-statement)
-   [More help](#more-help)
    -   [Contact the Author](#contact-the-author)

## Overview

There is an Alpha Vantage SDK shipped along with Tidyquant which
provided access to interday prices. This package aims to provide R users
with convenient functions to access other API features. Starting with
financial documents and IPO Calendar.

You will need a API key from Alpha Vantage which can be obtained by
signing up to [](https://www.alphavantage.co/).

There is basic file based caching available which is disabled by
default. Make sure you use the cachine feature if you want to download a
information for more than a handful of companies beacuase you will
quickly meet API rate limits otherwise.

### Use Cases

-   Intrinsic Valuation.
-   Portfolio Weighting.
-   Stock Selection.

R version 4.1 or higher is required.

## Basic Usage

## Set API Token

Set this environment variable in your \~/.Renviron file.  
Or set it for session with the Sys.setenv command.

``` r
library(alphavantagerxtra)
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.1 ──

    ## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
    ## ✓ tibble  3.1.2     ✓ dplyr   1.0.7
    ## ✓ tidyr   1.1.3     ✓ stringr 1.4.0
    ## ✓ readr   1.4.0     ✓ forcats 0.5.1

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
# Sys.setenv("ALPHA_VANTAGE_TOKEN" = "ABCD12345")
```

## IPO Calendar

``` r
ipo_calendar <- av_get_ipo_calendar() |> t()
knitr::kable(ipo_calendar)
```

|                    |                                                       |                                          |            |
|:-------------------|:------------------------------------------------------|:-----------------------------------------|:-----------|
| symbol             | HCNE                                                  | HCNEW                                    | WEBR       |
| name               | Jaws Hurricane Acquisition Corp. Class A Common Stock | Jaws Hurricane Acquisition Corp. Warrant | Weber Inc. |
| ipo\_date          | 2021-08-02                                            | 2021-08-02                               | 2021-08-05 |
| price\_range\_low  | 0                                                     | 0                                        | 15         |
| price\_range\_high | 0                                                     | 0                                        | 17         |
| currency           | USD                                                   | USD                                      | USD        |
| exchange           | NASDAQ                                                | NASDAQ                                   | NYSE       |

## Company Overview

``` r
# Pause to prevent API rate limits.
Sys.sleep(10)
amazon_overview <- av_get_overview("AMZN")
names(amazon_overview)
```

    ##  [1] "symbol"                        "asset_type"                   
    ##  [3] "name"                          "description"                  
    ##  [5] "cik"                           "exchange"                     
    ##  [7] "currency"                      "country"                      
    ##  [9] "sector"                        "industry"                     
    ## [11] "address"                       "fiscal_year_end"              
    ## [13] "latest_quarter"                "market_capitalization"        
    ## [15] "ebitda"                        "pe_ratio"                     
    ## [17] "peg_ratio"                     "book_value"                   
    ## [19] "dividend_per_share"            "dividend_yield"               
    ## [21] "eps"                           "revenue_per_share_ttm"        
    ## [23] "profit_margin"                 "operating_margin_ttm"         
    ## [25] "return_on_assets_ttm"          "return_on_equity_ttm"         
    ## [27] "revenue_ttm"                   "gross_profit_ttm"             
    ## [29] "diluted_epsttm"                "quarterly_earnings_growth_yoy"
    ## [31] "quarterly_revenue_growth_yoy"  "analyst_target_price"         
    ## [33] "trailing_pe"                   "forward_pe"                   
    ## [35] "price_to_sales_ratio_ttm"      "price_to_book_ratio"          
    ## [37] "ev_to_revenue"                 "ev_to_ebitda"                 
    ## [39] "beta"                          "x52week_high"                 
    ## [41] "x52week_low"                   "x50day_moving_average"        
    ## [43] "x200day_moving_average"        "shares_outstanding"           
    ## [45] "shares_float"                  "shares_short"                 
    ## [47] "shares_short_prior_month"      "short_ratio"                  
    ## [49] "short_percent_outstanding"     "short_percent_float"          
    ## [51] "percent_insiders"              "percent_institutions"         
    ## [53] "forward_annual_dividend_rate"  "forward_annual_dividend_yield"
    ## [55] "payout_ratio"                  "dividend_date"                
    ## [57] "ex_dividend_date"              "last_split_factor"            
    ## [59] "last_split_date"

``` r
amazon_overview |> human_readable_tibble() |> t() |> knitr::kable()
```

|                                  |                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
|:---------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| symbol                           | AMZN                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| asset\_type                      | Common Stock                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| name                             | Amazon.com, Inc                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| description                      | Amazon.com, Inc. is an American multinational technology company which focuses on e-commerce, cloud computing, digital streaming, and artificial intelligence. It is one of the Big Five companies in the U.S. information technology industry, along with Google, Apple, Microsoft, and Facebook. The company has been referred to as one of the most influential economic and cultural forces in the world, as well as the world’s most valuable brand. |
| cik                              | 1.0M                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| exchange                         | NASDAQ                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| currency                         | USD                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| country                          | USA                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| sector                           | TRADE & SERVICES                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| industry                         | RETAIL-CATALOG & MAIL-ORDER HOUSES                                                                                                                                                                                                                                                                                                                                                                                                                        |
| address                          | 410 TERRY AVENUE NORTH, SEATTLE, WA, US                                                                                                                                                                                                                                                                                                                                                                                                                   |
| fiscal\_year\_end                | December                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| latest\_quarter                  | 2021-03-31                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| market\_capitalization           | 1.7T                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| ebitda                           | 59.3B                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| pe\_ratio                        | 57.98                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| peg\_ratio                       | 1.339                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| book\_value                      | 226.88                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| dividend\_per\_share             | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| dividend\_yield                  | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| eps                              | 57.4                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| revenue\_per\_share\_ttm         | 881.31                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| profit\_margin                   | 0.0664                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| operating\_margin\_ttm           | 0.0669                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| return\_on\_assets\_ttm          | 0.0599                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| return\_on\_equity\_ttm          | 0.312                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| revenue\_ttm                     | 443.3B                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| gross\_profit\_ttm               | 152.8B                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| diluted\_epsttm                  | 57.4                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| quarterly\_earnings\_growth\_yoy | 0.468                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| quarterly\_revenue\_growth\_yoy  | 0.272                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| analyst\_target\_price           | 4241.33                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| trailing\_pe                     | 57.98                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| forward\_pe                      | 55.56                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| price\_to\_sales\_ratio\_ttm     | 3.851                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| price\_to\_book\_ratio           | 14.62                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ev\_to\_revenue                  | 4.061                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| ev\_to\_ebitda                   | 28.32                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| beta                             | 1.152                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| x52week\_high                    | 3773.08                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| x52week\_low                     | 2871                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| x50day\_moving\_average          | 3545.35                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| x200day\_moving\_average         | 3307.4                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| shares\_outstanding              | 504.3M                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| shares\_float                    | 453.6M                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| shares\_short                    | 3.9M                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| shares\_short\_prior\_month      | 4.5M                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| short\_ratio                     | 1.08                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| short\_percent\_outstanding      | 0.01                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| short\_percent\_float            | 0.0087                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| percent\_insiders                | 13.68                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| percent\_institutions            | 59.21                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| forward\_annual\_dividend\_rate  | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| forward\_annual\_dividend\_yield | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| payout\_ratio                    | 0                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| dividend\_date                   | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| ex\_dividend\_date               | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| last\_split\_factor              | 2:1                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| last\_split\_date                | 1999-09-02                                                                                                                                                                                                                                                                                                                                                                                                                                                |

## Company Balance Sheet

``` r
facebook_balance_sheet <- av_get_balance_sheet("FB")
names(facebook_balance_sheet)
```

    ##  [1] "fiscal_date_ending"                         
    ##  [2] "reported_currency"                          
    ##  [3] "total_assets"                               
    ##  [4] "total_current_assets"                       
    ##  [5] "cash_and_cash_equivalents_at_carrying_value"
    ##  [6] "cash_and_short_term_investments"            
    ##  [7] "inventory"                                  
    ##  [8] "current_net_receivables"                    
    ##  [9] "total_non_current_assets"                   
    ## [10] "property_plant_equipment"                   
    ## [11] "accumulated_depreciation_amortization_ppe"  
    ## [12] "intangible_assets"                          
    ## [13] "intangible_assets_excluding_goodwill"       
    ## [14] "goodwill"                                   
    ## [15] "investments"                                
    ## [16] "long_term_investments"                      
    ## [17] "short_term_investments"                     
    ## [18] "other_current_assets"                       
    ## [19] "other_non_currrent_assets"                  
    ## [20] "total_liabilities"                          
    ## [21] "total_current_liabilities"                  
    ## [22] "current_accounts_payable"                   
    ## [23] "deferred_revenue"                           
    ## [24] "current_debt"                               
    ## [25] "short_term_debt"                            
    ## [26] "total_non_current_liabilities"              
    ## [27] "capital_lease_obligations"                  
    ## [28] "long_term_debt"                             
    ## [29] "current_long_term_debt"                     
    ## [30] "long_term_debt_noncurrent"                  
    ## [31] "short_long_term_debt_total"                 
    ## [32] "other_current_liabilities"                  
    ## [33] "other_non_current_liabilities"              
    ## [34] "total_shareholder_equity"                   
    ## [35] "treasury_stock"                             
    ## [36] "retained_earnings"                          
    ## [37] "common_stock"                               
    ## [38] "common_stock_shares_outstanding"            
    ## [39] "symbol"

``` r
facebook_balance_sheet |> 
  human_readable_tibble() |> 
  select (fiscal_date_ending:cash_and_cash_equivalents_at_carrying_value) |>
  knitr::kable()
```

| fiscal\_date\_ending | reported\_currency | total\_assets | total\_current\_assets | cash\_and\_cash\_equivalents\_at\_carrying\_value |
|:---------------------|:-------------------|:--------------|:-----------------------|:--------------------------------------------------|
| 2020-12-31           | USD                | 159.3B        | 75.7B                  | 17.6B                                             |
| 2019-12-31           | USD                | 133.4B        | 66.2B                  | 19.1B                                             |
| 2018-12-31           | USD                | 97.3B         | 50.5B                  | 10.0B                                             |
| 2017-12-31           | USD                | 84.5B         | 48.6B                  | 8.1B                                              |
| 2016-12-31           | USD                | 65.0B         | 34.4B                  | 8.9B                                              |

## Company Cash Flow

``` r
# Pause to prevent API rate limits.
Sys.sleep(10)

jpmorgan_cash_flow <- av_get_cash_flow("JPM")
names(jpmorgan_cash_flow)
```

    ##  [1] "fiscal_date_ending"                                                 
    ##  [2] "reported_currency"                                                  
    ##  [3] "operating_cashflow"                                                 
    ##  [4] "payments_for_operating_activities"                                  
    ##  [5] "proceeds_from_operating_activities"                                 
    ##  [6] "change_in_operating_liabilities"                                    
    ##  [7] "change_in_operating_assets"                                         
    ##  [8] "depreciation_depletion_and_amortization"                            
    ##  [9] "capital_expenditures"                                               
    ## [10] "change_in_receivables"                                              
    ## [11] "change_in_inventory"                                                
    ## [12] "profit_loss"                                                        
    ## [13] "cashflow_from_investment"                                           
    ## [14] "cashflow_from_financing"                                            
    ## [15] "proceeds_from_repayments_of_short_term_debt"                        
    ## [16] "payments_for_repurchase_of_common_stock"                            
    ## [17] "payments_for_repurchase_of_equity"                                  
    ## [18] "payments_for_repurchase_of_preferred_stock"                         
    ## [19] "dividend_payout"                                                    
    ## [20] "dividend_payout_common_stock"                                       
    ## [21] "dividend_payout_preferred_stock"                                    
    ## [22] "proceeds_from_issuance_of_common_stock"                             
    ## [23] "proceeds_from_issuance_of_long_term_debt_and_capital_securities_net"
    ## [24] "proceeds_from_issuance_of_preferred_stock"                          
    ## [25] "proceeds_from_repurchase_of_equity"                                 
    ## [26] "proceeds_from_sale_of_treasury_stock"                               
    ## [27] "change_in_cash_and_cash_equivalents"                                
    ## [28] "change_in_exchange_rate"                                            
    ## [29] "net_income"                                                         
    ## [30] "free_cash_flow"                                                     
    ## [31] "symbol"

``` r
jpmorgan_cash_flow |> 
  human_readable_tibble() |> 
  select(fiscal_date_ending:operating_cashflow, net_income) |>
  knitr::kable()
```

| fiscal\_date\_ending | reported\_currency | operating\_cashflow | net\_income |
|:---------------------|:-------------------|:--------------------|:------------|
| 2020-12-31           | USD                | -79.9B              | 29.1B       |
| 2019-12-31           | USD                | 4.1B                | 36.4B       |
| 2018-12-31           | USD                | 15.6B               | 32.5B       |
| 2017-12-31           | USD                | -10.8B              | 24.4B       |
| 2016-12-31           | USD                | 21.9B               | 24.7B       |

## Company earnings

``` r
# Pause to prevent API rate limits.
Sys.sleep(10)

twtr_earnings <- av_get_earnings("TWTR")
names(twtr_earnings)
```

    ## [1] "symbol"             "fiscal_date_ending" "reported_eps"

``` r
twtr_earnings |> 
  human_readable_tibble() |> 
  knitr::kable()
```

| symbol | fiscal\_date\_ending | reported\_eps |
|:-------|:---------------------|--------------:|
| TWTR   | 2021-06-30           |        0.3600 |
| TWTR   | 2020-12-31           |       -0.7100 |
| TWTR   | 2019-12-31           |        2.3700 |
| TWTR   | 2018-12-31           |        0.8500 |
| TWTR   | 2017-12-31           |        0.5200 |
| TWTR   | 2016-12-31           |        0.5700 |
| TWTR   | 2015-12-31           |        0.4000 |
| TWTR   | 2014-12-31           |       -0.0821 |
| TWTR   | 2013-12-31           |       -0.1171 |

## Income Statement

Quarterly and Annuals earnings are returned in the same tibble. Filter
on the periodicity column to just get one type.

``` r
# Pause to prevent API rate limits.
Sys.sleep(10)

morgan_stanley_income_statement <- av_get_income_statement("MS")
names(morgan_stanley_income_statement)
```

    ##  [1] "symbol"                               
    ##  [2] "periodicity"                          
    ##  [3] "fiscal_date_ending"                   
    ##  [4] "reported_currency"                    
    ##  [5] "gross_profit"                         
    ##  [6] "total_revenue"                        
    ##  [7] "cost_of_revenue"                      
    ##  [8] "costof_goods_and_services_sold"       
    ##  [9] "operating_income"                     
    ## [10] "selling_general_and_administrative"   
    ## [11] "research_and_development"             
    ## [12] "operating_expenses"                   
    ## [13] "investment_income_net"                
    ## [14] "net_interest_income"                  
    ## [15] "interest_income"                      
    ## [16] "interest_expense"                     
    ## [17] "non_interest_income"                  
    ## [18] "other_non_operating_income"           
    ## [19] "depreciation"                         
    ## [20] "depreciation_and_amortization"        
    ## [21] "income_before_tax"                    
    ## [22] "income_tax_expense"                   
    ## [23] "interest_and_debt_expense"            
    ## [24] "net_income_from_continuing_operations"
    ## [25] "comprehensive_income_net_of_tax"      
    ## [26] "ebit"                                 
    ## [27] "ebitda"                               
    ## [28] "net_income"

``` r
morgan_stanley_income_statement |> 
  filter(periodicity == "annual") |>
  human_readable_tibble() |> 
  select(fiscal_date_ending:total_revenue, operating_income, ebitda, net_income) |>
  knitr::kable(caption = "Annual Earnings")
```

| fiscal\_date\_ending | reported\_currency | gross\_profit | total\_revenue | operating\_income | ebitda | net\_income |
|:---------------------|:-------------------|:--------------|:---------------|:------------------|:-------|:------------|
| 2020-12-31           | USD                | 18.2B         | 52.0B          | 3.1B              | 21.9B  | 11.0B       |
| 2019-12-31           | USD                | 15.0B         | 53.8B          | 2.1B              | 26.2B  | 9.0B        |
| 2018-12-31           | USD                | 11.3B         | 50.2B          | -17.2B            | 23.0B  | 8.7B        |
| 2017-12-31           | USD                | 10.4B         | 43.6B          | -17.7B            | 17.7B  | 6.1B        |
| 2016-12-31           | USD                | 9.8B          | 37.9B          | -16.6B            | 13.8B  | 6.0B        |

Annual Earnings

``` r
morgan_stanley_income_statement |> 
  filter(periodicity == "quarterly") |>
  human_readable_tibble() |> 
  select(fiscal_date_ending:total_revenue, operating_income, ebitda, net_income) |>
  knitr::kable(caption = "Quarterly Earnings")
```

| fiscal\_date\_ending | reported\_currency | gross\_profit | total\_revenue | operating\_income | ebitda | net\_income |
|:---------------------|:-------------------|:--------------|:---------------|:------------------|:-------|:------------|
| 2021-03-31           | USD                | 7.0B          | 16.1B          | 3.3B              | 6.6B   | 4.1B        |
| 2020-12-31           | USD                | 4.4B          | 14.0B          | 4.4B              | 6.2B   | 3.4B        |
| 2020-09-30           | USD                | 4.4B          | 12.2B          | 2.1B              | 4.9B   | 2.7B        |
| 2020-06-30           | USD                | 5.0B          | 14.2B          | 2.7B              | 5.8B   | 3.2B        |
| 2020-03-31           | USD                | 2.9B          | 11.9B          | -151.0M           | 5.0B   | 1.7B        |
| 2019-12-31           | USD                | 2.7B          | 13.4B          | 2.6B              | 5.8B   | 2.2B        |
| 2019-09-30           | USD                | 3.6B          | 13.2B          | 1.4B              | 6.5B   | 2.2B        |
| 2019-06-30           | USD                | 3.9B          | 13.7B          | 1.6B              | 7.0B   | 2.2B        |
| 2019-03-31           | USD                | 2.9B          | 13.6B          | -4.5B             | 6.8B   | 2.4B        |
| 2018-12-31           | USD                | 1.9B          | 11.7B          | 1.9B              | 5.4B   | 1.5B        |
| 2018-09-30           | USD                | 2.8B          | 12.6B          | -3.6B             | 6.0B   | 2.1B        |
| 2018-06-30           | USD                | 3.2B          | 13.0B          | -3.6B             | 6.0B   | 2.4B        |
| 2018-03-31           | USD                | 3.4B          | 13.0B          | -4.0B             | 5.7B   | 2.7B        |
| 2017-12-31           | USD                | 2.5B          | 11.1B          | 2.5B              | 4.5B   | 643.0M      |
| 2017-09-30           | USD                | 2.5B          | 10.8B          | -3.7B             | 4.5B   | 1.8B        |
| 2017-06-30           | USD                | 3.0B          | 10.9B          | -3.2B             | 4.4B   | 1.8B        |
| 2017-03-31           | USD                | 3.2B          | 10.9B          | -3.7B             | 4.4B   | 1.9B        |
| 2016-12-31           | USD                | 2.2B          | 10.0B          | 2.2B              | 3.6B   | 1.7B        |
| 2016-09-30           | USD                | 2.7B          | 9.6B           | -3.3B             | 3.6B   | 1.6B        |
| 2016-06-30           | USD                | 2.7B          | 9.7B           | -3.2B             | 3.6B   | 1.6B        |

Quarterly Earnings

# More help

Use ?alphavantagerxtra inside your R session.

## Contact the Author

-   [email Mark Hamlin @
    badattribute@gmail.com](mailto:badattribute@gmail.com)
-   [twitter](https://twitter.com/markchamlin)
-   [https://blog.badattribute.com](https://blog.badattribute.com/)
