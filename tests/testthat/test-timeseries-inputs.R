library(testthat)

test_that("fastclime gracefully handles time-series objects and restores dimnames", {
  skip_if_not_installed("xts")
  library(xts)

  dates <- as.Date("2020-01-01") + 1:10
  X <- xts(matrix(rnorm(50), 10, 5), order.by = dates)
  colnames(X) <- paste0("V", 1:5)

  res1 <- fastclime(X, nlambda=2)
  expect_equal(dim(res1$lambdamtx)[2], 5)

  res2 <- fastclime.BK17(X)
  expect_equal(colnames(res2$Omega), paste0("V", 1:5))
  expect_equal(rownames(res2$Omega), paste0("V", 1:5))

  res3 <- fastclime.ZKL15(X)
  expect_equal(colnames(res3$Omega), paste0("V", 1:5))
  expect_equal(rownames(res3$Omega), paste0("V", 1:5))
})
