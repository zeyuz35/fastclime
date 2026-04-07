test_that("BK17 CVXR variant runs without error", {
  skip_if_not_installed("CVXR")

  source(file.path(getwd(), "../../scratch/CLIME_CVXR_BK17.R"))

  set.seed(42)
  n <- 30
  p <- 4
  rho <- 0.5

  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{abs(i - j)}
    }
  }

  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)
  Sigma <- cov.wt(X, center = FALSE, method = "ML")$cov

  result <- QLASSO.Hessian.Omega.BK17.CLIME(
    X = X,
    Sigma = Sigma,
    lambda_1 = 5.0,
    lambda_2 = 5.0,
    solver = "SCS"
  )

  expect_true(is.list(result))
  expect_true("Omega" %in% names(result))
  expect_true("lambda" %in% names(result))
})

test_that("ZKL15 CVXR variant runs without error", {
  skip_if_not_installed("CVXR")

  source(file.path(getwd(), "../../scratch/CLIME_CVXR_ZKL15.R"))

  set.seed(42)
  n <- 30
  p <- 4
  rho <- 0.5

  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{abs(i - j)}
    }
  }

  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)
  Sigma <- cov.wt(X, center = FALSE, method = "ML")$cov

  result <- QLASSO.Hessian.Omega.ZKL15.CLIME(
    X = X,
    Sigma = Sigma,
    lambda_1 = 5.0,
    lambda_2 = 5.0,
    lambda_3 = 5.0,
    solver = "SCS"
  )

  expect_true(is.list(result))
  expect_true("Omega" %in% names(result))
  expect_true("lambda" %in% names(result))
})

test_that("fastclime.BK17 produces valid output", {
  set.seed(42)
  n <- 50
  p <- 5
  rho <- 0.5

  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{abs(i - j)}
    }
  }

  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)

  result <- fastclime.BK17(
    X = X,
    lambda_1 = 0.1,
    lambda_2 = 0.1
  )

  expect_true(is.matrix(result$Omega))
  expect_equal(dim(result$Omega), c(p, p))
  expect_true(isSymmetric(result$Omega))
})

test_that("fastclime.ZKL15 produces valid output", {
  set.seed(42)
  n <- 50
  p <- 5
  rho <- 0.5

  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{abs(i - j)}
    }
  }

  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)

  result <- fastclime.ZKL15(
    X = X,
    lambda_1 = 0.1,
    lambda_2 = 0.1,
    lambda_3 = 0.1
  )

  expect_true(is.matrix(result$Omega))
  expect_equal(dim(result$Omega), c(p, p))
  expect_true(isSymmetric(result$Omega))
})
