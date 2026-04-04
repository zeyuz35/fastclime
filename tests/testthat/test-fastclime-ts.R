library(fastclime)
library(testthat)
library(xts)

test_that("fastclime preserves xts inputs natively", {
  set.seed(42)
  # Generate some dummy data
  mat <- matrix(rnorm(100), ncol=5)
  x_ts <- xts(mat, order.by = as.Date("2023-01-01") + 1:20)

  expect_error(out <- fastclime(x_ts), NA)
  expect_s3_class(out, "fastclime")
  expect_equal(class(out$data), class(x_ts))
  expect_true(is.xts(out$data))
})
