# A 20 second delay is put in between each test to
# prevent errors caused by API rate limits.

test_that("av_get_overview - cache disabled", {
  aapl_overview <- av_get_overview("AAPL")
  expect_true(any(names(aapl_overview) == 'symbol'))
  expect_true(any(names(aapl_overview) == 'market_capitalization'))
  expect_true(any(names(aapl_overview) == 'beta'))
  expect_equal(nrow(aapl_overview), 1)
})


test_that("av_get_overview - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_overview("AAPL")

  aapl <- av_cache_retrieve("AAPL")

  expect_true(any(names(aapl$overview) == 'symbol'))
  expect_true(any(names(aapl$overview) == 'market_capitalization'))
  expect_true(any(names(aapl$overview) == 'beta'))
  expect_equal(nrow(aapl$overview), 1)
})

test_that("av_get_earnings - cache disabled", {
  Sys.sleep(20)
  aapl_earnings <- av_get_earnings("AAPL")
  expect_true(any(names(aapl_earnings) == 'symbol'))
  expect_true(any(names(aapl_earnings) == 'fiscal_date_ending'))
  expect_true(any(names(aapl_earnings) == 'reported_eps'))
  expect_gt(nrow(aapl_earnings), 1)
})


test_that("av_get_earnings - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_earnings("AAPL")
  aapl <- av_cache_retrieve("AAPL")

  expect_true(any(names(aapl$earnings) == 'symbol'))
  expect_true(any(names(aapl$earnings) == 'fiscal_date_ending'))
  expect_true(any(names(aapl$earnings) == 'reported_eps'))
  expect_gt(nrow(aapl$earnings), 1)
})




test_that("av_get_cash_flow - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_cash_flow("AAPL")
  aapl <- av_cache_retrieve("AAPL")

  expect_true(any(names(aapl$cash_flow) == 'symbol'))
  expect_true(any(names(aapl$cash_flow) == 'fiscal_date_ending'))
  expect_gte(nrow(aapl$cash_flow), 1)
})

test_that("av_get_income_statement - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_income_statement("AAPL")
  aapl <- av_cache_retrieve("AAPL")

  expect_true(any(names(aapl$income_statement) == 'symbol'))
  expect_true(any(names(aapl$income_statement) == 'periodicity'))
  expect_true(any(names(aapl$income_statement) == 'fiscal_date_ending'))
  expect_equal(aapl$income_statement|> dplyr::pull(periodicity) |> unique() |> length(), 2)
})


test_that("av_get_balance_sheet - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_balance_sheet("AAPL")
  aapl <- av_cache_retrieve("AAPL")

  expect_true(any(names(aapl$balance_sheet) == 'symbol'))
  expect_true(any(names(aapl$balance_sheet) == 'fiscal_date_ending'))
  expect_gte(nrow(aapl$balance_sheet), 1)
})


test_that("av_get_ipo_calendar - cache enabled", {
  Sys.sleep(20)
  data_folder <- paste(tempdir(check = TRUE), uuid::UUIDgenerate(), sep="/")
  dir.create(data_folder)
  set_data_folder(data_folder)
  set_use_cache()

  av_get_ipo_calendar()
  ipo_calendar <- av_cache_retrieve_report("ipo_calendar")

  expect_true(any(names(ipo_calendar) == 'symbol'))
  expect_true(any(names(ipo_calendar) == 'name'))
  expect_true(any(names(ipo_calendar) == 'exchange'))

})

