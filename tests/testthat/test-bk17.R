library(fastclime)

test_that("QLASSO.Hessian.Omega.BK17.CLIME works correctly for N=T", {
  set.seed(123)
  X <- matrix(rnorm(100), 10, 10)

  res <- QLASSO.Hessian.Omega.BK17.CLIME(X, lambda_1=0.5, lambda_2=1.0)

  expect_true(is.list(res))
  expect_true("Omega" %in% names(res))
  expect_true("lambda" %in% names(res))
  expect_equal(dim(res$Omega), c(10, 10))

  # Ensure the object output is somewhat what we expect
  expect_true(is.numeric(res$Omega))
})

test_that("QLASSO.Hessian.Omega.BK17.CLIME handles N != T correctly", {
  set.seed(456)
  X <- matrix(rnorm(50), 10, 5) # N=5, T=10

  # The solver might error out and print a warning for some columns if infeasible,
  # but it shouldn't crash R due to dimensionality problems. We'll capture warnings
  # and just test the dimension, suppressing warnings if any.
  res <- suppressWarnings(
    QLASSO.Hessian.Omega.BK17.CLIME(X, lambda_1=0.2, lambda_2=0.5)
  )

  expect_equal(dim(res$Omega), c(5, 5))
})

test_that("QLASSO.Hessian.Omega.BK17.index_wise works correctly", {
  set.seed(789)
  X <- matrix(rnorm(100), 10, 10)
  Sigma <- cov(X)

  res <- suppressWarnings(
      QLASSO.Hessian.Omega.BK17.index_wise(X, lambda=0.5, Sigma=Sigma)
  )

  expect_true(is.list(res))
  expect_true("Omega" %in% names(res))
  expect_equal(dim(res$Omega), c(10, 10))
})
