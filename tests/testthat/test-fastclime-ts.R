library(testthat)
library(zoo)
library(xts)

test_that("fastclime works with ts, xts, zoo objects without isSymmetric crash", {
  n <- 50
  d <- 10
  mat <- matrix(rnorm(n * d), n, d)

  # ts
  ts_mat <- ts(mat)
  expect_no_error({ res_ts <- fastclime(ts_mat) })
  expect_true(inherits(res_ts$data, "ts"))

  # zoo
  z_mat <- zoo(mat, order.by = 1:n)
  expect_no_error({ res_zoo <- fastclime(z_mat) })
  expect_true(inherits(res_zoo$data, "zoo"))

  # xts
  x_mat <- xts(mat, order.by = as.Date("2020-01-01") + 1:n)
  expect_no_error({ res_xts <- fastclime(x_mat) })
  expect_true(inherits(res_xts$data, "xts"))
})
