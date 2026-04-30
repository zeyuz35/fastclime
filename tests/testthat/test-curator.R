test_that("fastclime handles xts and zoo inputs without isSymmetric crash", {
  skip_if_not_installed("xts")
  skip_if_not_installed("zoo")
  library(xts)
  library(zoo)
  x <- matrix(rnorm(100), 20, 5)
  x_xts <- xts(x, order.by = Sys.Date() - 20:1)
  x_zoo <- zoo(x, order.by = Sys.Date() - 20:1)

  expect_error(fastclime(x_xts), NA)
  expect_error(fastclime(x_zoo), NA)
})
