library(xts)
library(zoo)

test_that("fastclime handles time-series classes correctly", {
  set.seed(42)
  # Generate symmetric matrix data
  mat <- matrix(rnorm(100), 10, 10)
  mat <- mat %*% t(mat)

  x_ts <- ts(mat)
  x_zoo <- zoo(mat, order.by=1:10)
  x_xts <- xts(mat, order.by=as.Date(1:10))

  # These should run without error
  out_ts <- fastclime(x_ts, lambda.min = 0.8)
  out_zoo <- fastclime(x_zoo, lambda.min = 0.8)
  out_xts <- fastclime(x_xts, lambda.min = 0.8)

  expect_s3_class(out_ts, "fastclime")
  expect_s3_class(out_zoo, "fastclime")
  expect_s3_class(out_xts, "fastclime")

  # Verify that these symmetric matrices are correctly identified as covariance matrices
  # thereby avoiding recalculation
  expect_equal(out_ts$cov.input, 1)
  expect_equal(out_zoo$cov.input, 1)
  expect_equal(out_xts$cov.input, 1)
})
