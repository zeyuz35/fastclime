library(testthat)
library(zoo)

test_that("fastclime handles time-series inputs correctly", {
  set.seed(42)
  x_mat <- matrix(rnorm(100), 10, 10)

  # Test ts
  x_ts <- ts(x_mat)
  res_ts <- fastclime(x_ts, nlambda = 2)
  # When ts() is called on a matrix, it returns class c("mts", "ts", "matrix", "array")
  expect_equal(class(res_ts$data), class(x_ts))

  # Test zoo
  x_zoo <- zoo(x_mat, order.by = 1:10)
  res_zoo <- fastclime(x_zoo, nlambda = 2)
  expect_equal(class(res_zoo$data), class(x_zoo))
  expect_equal(index(res_zoo$data), index(x_zoo))
})
