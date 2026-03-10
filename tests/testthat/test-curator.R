library(xts)

test_that("fastclime preserves xts input", {
  data <- matrix(rnorm(100), 10, 10)
  colnames(data) <- paste0("V", 1:10)
  x_xts <- xts(data, order.by=Sys.Date() - 10:1)
  attr(x_xts, "my_scaling") <- "yes"

  out <- fastclime(x_xts)

  expect_s3_class(out$data, "xts")
  expect_equal(attr(out$data, "my_scaling"), "yes")
  expect_equal(colnames(out$icovlist[[1]]), colnames(data))
})

test_that("dantzig preserves xts input", {
  X_data <- matrix(rnorm(100), 10, 10)
  colnames(X_data) <- paste0("V", 1:10)
  X_xts <- xts(X_data, order.by=Sys.Date() - 10:1)
  attr(X_xts, "my_scaling") <- "yes"

  y_data <- matrix(rnorm(10), 10, 1)
  colnames(y_data) <- "y"
  y_xts <- xts(y_data, order.by=Sys.Date() - 10:1)

  out <- dantzig(X_xts, y_xts)

  expect_s3_class(out$X, "xts")
  expect_s3_class(out$y, "xts")
  expect_equal(attr(out$X, "my_scaling"), "yes")

  # Ensure BETA0 stays a matrix even if validn == 1
  expect_true(is.matrix(out$BETA0))
})
