library(testthat)
library(fastclime)

test_that("fastclime preserves class and attributes of time-series objects", {
  skip_if_not_installed("zoo")
  library(zoo)

  set.seed(123)
  mat <- matrix(rnorm(100), 10, 10)
  colnames(mat) <- paste0("V", 1:10)

  # For symmetric zoo, covariance computation is skipped and data is preserved
  mat_sym <- t(mat) %*% mat
  colnames(mat_sym) <- paste0("V", 1:10)
  x_zoo_sym <- zoo(mat_sym, order.by = as.Date("2020-01-01") + 1:10)
  attr(x_zoo_sym, "scale") <- TRUE

  res_zoo <- fastclime(x_zoo_sym)
  expect_identical(class(res_zoo$data), class(x_zoo_sym))
  expect_identical(attributes(res_zoo$data), attributes(x_zoo_sym))

  # 2. ts/mts object
  x_ts <- ts(mat)
  attr(x_ts, "transform") <- "log"

  res_ts <- fastclime(x_ts)
  expect_identical(class(res_ts$data), class(x_ts))
  expect_identical(attributes(res_ts$data), attributes(x_ts))

  # 3. plain matrix
  res_mat <- fastclime(mat)
  expect_identical(class(res_mat$data), class(mat))
  expect_identical(attributes(res_mat$data), attributes(mat))
})

test_that("dantzig preserves class and attributes of time-series objects", {
  skip_if_not_installed("zoo")
  library(zoo)

  set.seed(123)
  mat <- matrix(rnorm(100), 10, 10)
  colnames(mat) <- paste0("V", 1:10)
  y <- rnorm(10)

  # 1. zoo object
  x_zoo <- zoo(mat, order.by = as.Date("2020-01-01") + 1:10)
  y_zoo <- zoo(y, order.by = as.Date("2020-01-01") + 1:10)
  attr(x_zoo, "scale") <- TRUE

  res_zoo <- dantzig(x_zoo, y_zoo)
  expect_identical(class(res_zoo$X), class(x_zoo))
  expect_identical(attributes(res_zoo$X), attributes(x_zoo))
  expect_identical(class(res_zoo$y), class(y_zoo))
  expect_identical(attributes(res_zoo$y), attributes(y_zoo))

  # 2. ts/mts object
  x_ts <- ts(mat)
  y_ts <- ts(y)
  attr(x_ts, "transform") <- "log"

  res_ts <- dantzig(x_ts, y_ts)
  expect_identical(class(res_ts$X), class(x_ts))
  expect_identical(attributes(res_ts$X), attributes(x_ts))
  expect_identical(class(res_ts$y), class(y_ts))
  expect_identical(attributes(res_ts$y), attributes(y_ts))

  # 3. plain matrix
  res_mat <- dantzig(mat, y)
  expect_identical(class(res_mat$X), class(mat))
  expect_identical(attributes(res_mat$X), attributes(mat))
  expect_identical(class(res_mat$y), class(y))
  expect_identical(attributes(res_mat$y), attributes(y))
})
