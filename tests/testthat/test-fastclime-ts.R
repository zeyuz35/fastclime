test_that("fastclime preserves colnames and handles ts/zoo/xts", {
  library(zoo)
  library(xts)
  set.seed(42)
  m <- cov(matrix(rnorm(100), 10, 10))
  colnames(m) <- paste0("V", 1:10)
  rownames(m) <- paste0("V", 1:10)

  # Test with standard matrix
  res_m <- fastclime(m)
  expect_equal(colnames(res_m$sigmahat), paste0("V", 1:10))
  expect_equal(colnames(res_m$icovlist[[1]]), paste0("V", 1:10))

  # Test with zoo
  z <- zoo(m)
  res_z <- fastclime(z)
  expect_equal(colnames(res_z$sigmahat), paste0("V", 1:10))
  expect_equal(colnames(res_z$icovlist[[1]]), paste0("V", 1:10))

  # Test with xts
  x <- xts(m, order.by=Sys.Date()-10:1)
  res_x <- fastclime(x)
  expect_equal(colnames(res_x$sigmahat), paste0("V", 1:10))
  expect_equal(colnames(res_x$icovlist[[1]]), paste0("V", 1:10))
})
