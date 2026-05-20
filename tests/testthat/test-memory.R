test_that("fastclime handles repeated invocations without crashing", {
  set.seed(2026)
  X <- matrix(rnorm(200 * 50), nrow = 200, ncol = 50)

  suppressMessages({
    fit1 <- fastclime(X, lambda.min = 0.1, nlambda = 10)
    fit2 <- fastclime(X, lambda.min = 0.1, nlambda = 10)
  })

  expect_s3_class(fit1, "fastclime")
  expect_s3_class(fit2, "fastclime")
})

test_that("fastclime.selector tolerates single-lambda paths", {
  d <- 5
  icovlist <- list(matrix(1, d, d), matrix(2, d, d))
  lambdamtx <- matrix(0.5, nrow = 1, ncol = d)

  expect_warning(
    res <- fastclime.selector(lambdamtx, icovlist, lambda = 0.3),
    "Some columns did not reach the required lambda. Consider increasing lambda.min or using a larger nlambda."
  )
  expect_true(is.list(res))
  expect_true(all(c("icov", "adaj", "sparsity") %in% names(res)))
  expect_equal(dim(res$icov), c(d, d))
})
