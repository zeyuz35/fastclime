test_that("fastclime preserves time-series attributes", {
  library(xts)
  library(zoo)
  X <- matrix(rnorm(100), 20, 5)
  y <- matrix(rnorm(20), 20, 1)

  xts_X <- xts(X, order.by=Sys.Date() - 20:1)
  ts_X <- ts(X)

  # fastclime
  out_fc_xts <- fastclime(xts_X)
  expect_true(inherits(out_fc_xts$data, "xts"))
  out_fc_ts <- fastclime(ts_X)
  expect_true(inherits(out_fc_ts$data, "ts"))
})
