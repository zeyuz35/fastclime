library(fastclime)
test_that("fastclime preserves class and attributes for time-series objects", {
  skip_if_not_installed("xts")
  library(xts)
  set.seed(42)
  mat <- matrix(rnorm(100), 10, 10)
  x <- xts(mat, order.by=as.Date("2000-01-01")+1:10)

  # fastclime should not throw an error about isSymmetric
  res <- fastclime(x, nlambda=2)

  # The output data should preserve the original class
  expect_true(inherits(res$data, "xts"))
  expect_equal(dim(res$data), c(10, 10))
})
