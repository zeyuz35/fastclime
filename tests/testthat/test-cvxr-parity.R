# test-cvxr-parity.R -------------------------------------------------
#
# Verify fastclime C implementation produces results consistent with
# CVXR ground truth implementation (sourced from setup.R)
#
# Tolerances:
#   - Frobenius relative error < 0.15 (15% - allows for algorithm differences)
#   - Correlation > 0.95
# --------------------------------------------------------------------

test_that("fastclime matches CVXR ground truth", {
  skip_if_not_installed("CVXR")
  skip_if_not_installed("MASS")
  skip_if_not_installed("foreach")

  # MASS and foreach are loaded via Depends/Namespace when package loads
  testthat::local_edition(3)

  set.seed(42)
  n <- 100
  p <- 10
  rho <- 0.5

  # AR(1) covariance matrix
  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{
        abs(i - j)
      }
    }
  }

  # Generate data from multivariate normal
  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)

  # Sample covariance
  Sigma <- cov.wt(X, center = FALSE, method = "ML")$cov

  # CVXR ground truth (index-wise method)
  cvxr_result <- CLIME_CVXR(
    X = X,
    Sigma = Sigma,
    lambda = 0.1,
    method = "index-wise",
    solver = "SCS"
  )

  # fastclime C implementation
  fl <- fastclime(X, lambda.min = 0.05, nlambda = 10)

  # Select solution at lambda = 0.1
  selector_result <- fastclime.selector(fl$lambdamtx, fl$icovlist, lambda = 0.1)

  # Extract Omega matrices
  Omega_cvxr <- cvxr_result$Omega
  Omega_fastclime <- selector_result$icov

  # Basic validity checks for CVXR result
  expect_true(is.matrix(Omega_cvxr))
  expect_equal(dim(Omega_cvxr), c(p, p))
  expect_true(isSymmetric(Omega_cvxr))
  expect_false(any(is.na(Omega_cvxr)))
  expect_true(all(diag(Omega_cvxr) > 0))

  # Basic validity checks for fastclime result
  expect_true(is.matrix(Omega_fastclime))
  expect_equal(dim(Omega_fastclime), c(p, p))
  expect_true(isSymmetric(Omega_fastclime))
  expect_false(any(is.na(Omega_fastclime)))
  expect_true(all(diag(Omega_fastclime) > 0))

  # Comparison metrics
  frob_error <- sqrt(sum((Omega_cvxr - Omega_fastclime)^2)) /
    sqrt(sum(Omega_cvxr^2))
  correlation <- cor(as.vector(Omega_cvxr), as.vector(Omega_fastclime))

  # Ground truth parity check
  expect_true(
    frob_error < 0.15,
    info = sprintf("Frobenius relative error %f exceeds 0.15", frob_error)
  )
  expect_true(
    correlation > 0.95,
    info = sprintf("Correlation %f below 0.95", correlation)
  )
})

test_that("CVXR index-wise and direct methods agree", {
  skip_if_not_installed("CVXR")
  skip_if_not_installed("MASS")
  skip_if_not_installed("foreach")

  testthat::local_edition(3)

  set.seed(42)
  n <- 50
  p <- 5
  rho <- 0.5

  Sigma_true <- matrix(0, nrow = p, ncol = p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      Sigma_true[i, j] <- rho^{
        abs(i - j)
      }
    }
  }

  X <- MASS::mvrnorm(n, mu = rep(0, p), Sigma = Sigma_true)
  Sigma <- cov.wt(X, center = FALSE, method = "ML")$cov

  result_index <- CLIME_CVXR(
    X,
    Sigma,
    lambda = 0.1,
    method = "index-wise",
    solver = "SCS"
  )
  result_direct <- CLIME_CVXR(
    X,
    Sigma,
    lambda = 0.1,
    method = "direct",
    solver = "SCS"
  )

  # Both should produce valid symmetric matrices
  expect_true(isSymmetric(result_index$Omega))
  expect_true(isSymmetric(result_direct$Omega))

  # Correlation between methods should be high
  correlation <- cor(
    as.vector(result_index$Omega),
    as.vector(result_direct$Omega)
  )
  expect_true(
    correlation > 0.90,
    info = sprintf(
      "Index-wise and direct methods correlation %f below 0.90",
      correlation
    )
  )
})
