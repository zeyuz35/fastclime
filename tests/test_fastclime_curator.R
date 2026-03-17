library(fastclime)
library(testthat)
library(zoo)
library(xts)

test_that("fastclime preserves attributes and handles ts/zoo objects", {
  set.seed(123)
  mat <- matrix(rnorm(100), 10, 10)
  colnames(mat) <- paste0("V", 1:10)

  # Test with data matrix (not symmetric)
  xts_data <- xts(mat, order.by = as.Date("2000-01-01") + 1:10)
  out_xts <- fastclime(xts_data, lambda.min = 0.5, nlambda = 2)
  expect_equal(colnames(out_xts$sigmahat), colnames(mat))
  expect_equal(rownames(out_xts$sigmahat), colnames(mat))
  expect_true(inherits(out_xts$data, "xts"))

  # Test with symmetric matrix with asymmetric dimnames
  sym_mat <- cov(mat)
  colnames(sym_mat) <- paste0("V", 1:10)
  rownames(sym_mat) <- NULL # asymmetric dimnames

  # This should be detected as symmetric and not recalculate cov()
  out_sym <- fastclime(sym_mat, lambda.min = 0.5, nlambda = 2)
  expect_equal(out_sym$cov.input, 1)
  expect_equal(colnames(out_sym$sigmahat), colnames(sym_mat))
  expect_equal(rownames(out_sym$sigmahat), colnames(sym_mat))
})
