test_that("fastclime preserves time-series object attributes and avoids isSymmetric crash", {
  skip_if_not_installed("xts")
  skip_if_not_installed("zoo")
  library(xts)
  library(zoo)

  set.seed(42)
  mat <- matrix(rnorm(100), 10, 10)
  sym_mat <- mat + t(mat)

  # Test xts (as data matrix)
  sym_xts <- xts(mat, order.by = Sys.Date() + 1:10)
  out_xts <- fastclime(sym_xts)
  expect_true(inherits(out_xts$data, "xts"))
  expect_equal(dim(out_xts$data), c(10, 10))

  # Test zoo (as symmetric covariance matrix)
  sym_zoo <- zoo(sym_mat, order.by = Sys.Date() + 1:10)
  out_zoo <- fastclime(sym_zoo)
  expect_true(inherits(out_zoo$data, "zoo"))
  expect_equal(dim(out_zoo$data), c(10, 10))
  expect_true(out_zoo$cov.input == 1)
})
