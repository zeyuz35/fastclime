test_that("fastclime handles xts input properly", {
  skip_if_not_installed("xts")
  library(xts)
  set.seed(42)
  mat <- matrix(rnorm(100), 10, 10)
  # time-series is not symmetric
  x <- xts(mat, Sys.Date() + 1:10)

  expect_message(out <- fastclime(x, nlambda = 2), "Done!")
  expect_s3_class(out, "fastclime")
  expect_equal(dim(out$sigmahat), c(10, 10))
  expect_true(is.matrix(out$sigmahat))
})
