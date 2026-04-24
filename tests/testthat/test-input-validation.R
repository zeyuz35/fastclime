test_that("dantzig.selector edge cases and errors", {
  lambdalist <- c(0.5, 0.4, 0.3, 0.2, 0.1)
  BETA0 <- matrix(1:20, nrow = 4, ncol = 5)

  # Invalid dimensions
  expect_error(
    dantzig.selector(lambdalist, matrix(1:16, 4, 4), 0.2),
    "BETA0 and lambdalist dimensions are incompatible"
  )

  # Lambda greater than max available (gets the sparsest one, at index 1)
  res_max <- dantzig.selector(lambdalist, BETA0, 0.6)
  expect_equal(res_max, BETA0[, 1])

  # Lambda matching exactly
  res_exact <- dantzig.selector(lambdalist, BETA0, 0.3)
  expect_equal(res_exact, BETA0[, 3])

  # Lambda between values
  res_between <- dantzig.selector(lambdalist, BETA0, 0.35)
  expect_equal(res_between, BETA0[, 3])
})

test_that("paralp/fastlp validate NA/Inf inputs", {
  A = matrix(c(-1, -1, 0, 1, -2, 1), nrow = 3)
  b_lp = c(-1, -2, 1)
  c_lp = c(-2, 3)

  # NA in obj
  c_na <- c_lp
  c_na[1] <- NA
  expect_error(fastlp(c_na, A, b_lp), "obj must be a finite numeric vector")
  expect_error(
    paralp(c_na, A, b_lp, c_lp, b_lp),
    "obj must be a finite numeric vector"
  )

  # Inf in mat
  A_inf <- A
  A_inf[1, 1] <- Inf
  expect_error(fastlp(c_lp, A_inf, b_lp), "mat must be a finite numeric matrix")
  expect_error(
    paralp(c_lp, A_inf, b_lp, c_lp, b_lp),
    "mat must be a finite numeric matrix"
  )

  # Negative perturbation vector in paralp
  expect_error(
    paralp(c_lp, A, b_lp, c(-1, 1), b_lp),
    "The perturbation vector obj_bar and rhs_bar must be nonnegative"
  )
  expect_error(
    paralp(c_lp, A, b_lp, c_lp, c(-1, 1, 1)),
    "The perturbation vector obj_bar and rhs_bar must be nonnegative"
  )
})

test_that("fastclime validates inputs", {
  set.seed(42)
  X <- matrix(rnorm(100), 10, 10)

  # NA in data matrix
  X_na <- X
  X_na[1, 1] <- NA
  expect_error(fastclime(X_na), "x must not contain NA, NaN, or Inf values")
})

test_that("fastclime works with ts/xts/zoo objects", {
  library(xts)
  set.seed(42)
  x_mat <- matrix(rnorm(100), 10, 10)
  x_xts <- xts(x_mat, order.by = as.Date("2020-01-01") + 0:9)

  # fastclime should run without error and preserve the input class
  out <- fastclime(x_xts)
  expect_true(inherits(out$data, "xts"))

  # Symmetric case
  x_sym_mat <- crossprod(x_mat)
  x_sym_xts <- xts(x_sym_mat, order.by = as.Date("2020-01-01") + 0:9)
  out_sym <- fastclime(x_sym_xts)
  expect_true(inherits(out_sym$data, "xts"))
  expect_true(inherits(out_sym$sigmahat, "xts"))
})
