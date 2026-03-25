test_that("fastclime accepts xts and zoo and preserves class", {
  library(xts)
  set.seed(123)
  mat <- matrix(rnorm(100), 20, 5)
  colnames(mat) <- paste0("V", 1:5)
  x_xts <- xts(mat, order.by = as.Date(1:20))

  res <- fastclime(x_xts)
  expect_s3_class(res$data, "xts")
  expect_s3_class(res$data, "zoo")

  # test symmetric case
  mat_sym <- matrix(rnorm(25), 5, 5)
  mat_sym <- mat_sym + t(mat_sym)
  colnames(mat_sym) <- paste0("V", 1:5)
  rownames(mat_sym) <- paste0("V", 1:5)
  x_sym_xts <- xts(mat_sym, order.by = as.Date(1:5))

  res_sym <- fastclime(x_sym_xts)
  expect_s3_class(res_sym$data, "xts")
})
