library(xts)
library(zoo)

test_that("fastclime preserves xts input class and attributes", {
  set.seed(123)
  data <- matrix(rnorm(100), 10, 10)
  colnames(data) <- paste0("V", 1:10)
  xts_data <- xts(data, order.by=Sys.Date() + 1:10)
  attr(xts_data, "transform") <- "scaled"

  out <- fastclime(xts_data, lambda.min = 0.1)

  expect_equal(class(out$data), c("xts", "zoo"))
  expect_equal(attr(out$data, "transform"), "scaled")
  expect_true(!is.null(colnames(out$sigmahat)))
  expect_true(!is.null(colnames(out$icovlist[[1]])))
})
