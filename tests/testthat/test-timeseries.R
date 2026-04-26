library(xts)

test_that("fastclime preserves time-series class and attributes", {
  set.seed(42)
  X <- matrix(rnorm(100*10), 100, 10)
  xts_X <- xts(X, order.by = as.Date(1:100))

  # fastclime directly on xts
  out_xts <- fastclime(xts_X, lambda.min = 0.5, nlambda = 5)
  expect_s3_class(out_xts$data, "xts")
  expect_equal(zoo::index(out_xts$data), zoo::index(xts_X))

  ts_X <- ts(X, frequency = 12, start = c(2000, 1))
  out_ts <- fastclime(ts_X, lambda.min = 0.5, nlambda = 5)
  expect_s3_class(out_ts$data, "ts")
  expect_equal(attributes(out_ts$data)$tsp, attributes(ts_X)$tsp)
})
