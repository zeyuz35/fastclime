test_that("fastclime preserves class for time series inputs", {
  set.seed(42)
  # ts
  ts_data <- ts(matrix(rnorm(100), 10, 10))
  out_ts <- fastclime(ts_data, lambda.min=0.5, nlambda=5)
  expect_true(inherits(out_ts$data, "ts"))

  # zoo
  suppressMessages(require(zoo))
  zoo_data <- zoo(matrix(rnorm(100), 10, 10), order.by = as.Date("2020-01-01") + 1:10)
  out_zoo <- fastclime(zoo_data, lambda.min=0.5, nlambda=5)
  expect_true(inherits(out_zoo$data, "zoo"))

  # xts
  suppressMessages(require(xts))
  xts_data <- xts(matrix(rnorm(100), 10, 10), order.by = as.Date("2020-01-01") + 1:10)
  out_xts <- fastclime(xts_data, lambda.min=0.5, nlambda=5)
  expect_true(inherits(out_xts$data, "xts"))
})
