library(fastclime)
library(testthat)

test_that("Curator attributes loss final check", {
  library(xts)
  library(zoo)
  set.seed(123)
  mat <- matrix(rnorm(100), 10, 10)
  sym_mat <- mat + t(mat)
  colnames(sym_mat) <- paste0("V", 1:10)
  rownames(sym_mat) <- paste0("V", 1:10)

  ts_data <- ts(sym_mat, start = c(2000, 1), frequency = 12)
  res <- fastclime(ts_data, lambda.min = 0.1, nlambda = 5)

  expect_equal(colnames(res$sigmahat), paste0("V", 1:10))
  expect_equal(colnames(res$icovlist[[1]]), paste0("V", 1:10))
})
