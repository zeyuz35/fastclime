library(testthat)

test_that("fastclime preserves metadata", {
  x <- matrix(rnorm(100), 20, 5)
  colnames(x) <- paste0("V", 1:5)
  res <- fastclime::fastclime(x)
  expect_equal(colnames(res$lambdamtx), paste0("V", 1:5))
  expect_equal(colnames(res$icovlist[[1]]), paste0("V", 1:5))
  expect_equal(rownames(res$icovlist[[1]]), paste0("V", 1:5))
})

test_that("fastclime.selector preserves metadata", {
  x <- matrix(rnorm(100), 20, 5)
  colnames(x) <- paste0("V", 1:5)
  res <- fastclime::fastclime(x)
  res2 <- fastclime::fastclime.selector(res$lambdamtx, res$icovlist, 0.2)
  expect_equal(colnames(res2$icov), paste0("V", 1:5))
  expect_equal(rownames(res2$icov), paste0("V", 1:5))
  expect_equal(colnames(res2$adaj), paste0("V", 1:5))
  expect_equal(rownames(res2$adaj), paste0("V", 1:5))
})

test_that("dantzig preserves metadata", {
  x <- matrix(rnorm(100), 20, 5)
  colnames(x) <- paste0("V", 1:5)
  y <- rnorm(20)
  res <- fastclime::dantzig(x, y)
  expect_equal(rownames(res$BETA0), paste0("V", 1:5))
})
