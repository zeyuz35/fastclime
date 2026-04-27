library(fastclime)
library(xts)

test_that("fastclime handles ts and xts objects correctly", {
  set.seed(123)
  x <- matrix(rnorm(100), 20, 5)
  colnames(x) <- paste0("V", 1:5)
  ts_x <- ts(x)
  xts_x <- xts(x, order.by = as.Date(1:20))

  # Should not error
  out_ts <- fastclime(ts_x)
  out_xts <- fastclime(xts_x)

  # Output data should be exactly the input class
  expect_equal(out_ts$data, ts_x)
  expect_equal(out_xts$data, xts_x)

  # Dimnames must be preserved on sigmahat
  expect_equal(colnames(out_ts$sigmahat), colnames(ts_x))
  expect_equal(colnames(out_xts$sigmahat), colnames(xts_x))
})
