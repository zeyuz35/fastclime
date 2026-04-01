library(fastclime)
library(testthat)
library(zoo)
library(xts)

test_that("fastclime works with ts, zoo, and xts inputs", {
  set.seed(42)
  mat <- matrix(rnorm(100), 10, 10)
  mat_sym <- crossprod(mat)

  t_obj <- ts(mat)
  z_obj <- zoo(mat, order.by = as.Date("2020-01-01") + 0:9)
  x_obj <- xts(mat, order.by = as.Date("2020-01-01") + 0:9)

  t_sym <- ts(mat_sym)
  z_sym <- zoo(mat_sym, order.by = as.Date("2020-01-01") + 0:9)
  x_sym <- xts(mat_sym, order.by = as.Date("2020-01-01") + 0:9)

  # Data matrix input
  expect_message(out_t <- fastclime(t_obj, 0.1), "Done!")
  expect_s3_class(out_t$data, "ts")

  expect_message(out_z <- fastclime(z_obj, 0.1), "Done!")
  expect_s3_class(out_z$data, "zoo")

  expect_message(out_x <- fastclime(x_obj, 0.1), "Done!")
  expect_s3_class(out_x$data, "xts")

  # Covariance matrix input
  expect_message(out_t_sym <- fastclime(t_sym, 0.1), "Done!")
  expect_s3_class(out_t_sym$data, "ts")

  expect_message(out_z_sym <- fastclime(z_sym, 0.1), "Done!")
  expect_s3_class(out_z_sym$data, "zoo")

  expect_message(out_x_sym <- fastclime(x_sym, 0.1), "Done!")
  expect_s3_class(out_x_sym$data, "xts")
})
