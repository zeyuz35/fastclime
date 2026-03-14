test_that("fastclime.ZKL15 solves basic inputs without memory failure", {
  bigT <- 100
  bigN <- 5
  set.seed(123)
  X <- matrix(rnorm(bigT * bigN), bigT, bigN)
  Sigma <- cov(X)

  lambda_1 <- rep(10, bigN)
  lambda_2 <- rep(10, bigN)
  lambda_3 <- rep(10, bigN)

  # Run with custom lambdas (should be all zeros if lambdas are huge)
  res <- fastclime.ZKL15(X, Sigma, lambda_1, lambda_2, lambda_3)
  expect_equal(dim(res$Omega), c(bigN, bigN))
  expect_true(all(res$Omega == 0))

  # Run with default lambdas
  res2 <- fastclime.ZKL15(X, Sigma)
  expect_equal(dim(res2$Omega), c(bigN, bigN))
  expect_true(is.numeric(res2$Omega))
})

test_that("fastclime.ZKL15 matches CVXR reference implementation", {
  skip_if_not_installed("CVXR")
  skip_if_not_installed("foreach")

  library(CVXR)
  library(foreach)

  QLASSO.Hessian.Omega.ZKL15.CLIME <- function(
    X,
    Sigma = NULL,
    lambda_1 = 0.1,
    lambda_2 = NULL,
    lambda_3 = NULL,
    solver = "SCS",
    ignore_dcp = TRUE,
    warm_start = TRUE,
    parallel = FALSE,
    ...
  ) {
    bigT <- nrow(X)
    bigN <- ncol(X)
    diag_N <- diag(bigN)

    if (is.null(Sigma)) Sigma <- cov(X)

    C_X <- 1
    Rho <- eigen(Sigma, only.values = TRUE)$values
    rho_max <- max(Rho)
    rho_min <- max(min(Rho), 0.01)
    sigma_x <- apply(X, 2, sd)
    R <- 1 / min(eigen(Sigma, only.values = TRUE)$values)

    a1 <- 2 * pmax(16, 36 * sigma_x^4) * (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2
    a2 <- sqrt(3) * sigma_x / rho_min
    a3 <- sqrt(2) * sigma_x / rho_min

    if (is.null(lambda_1)) lambda_1 <- (a1 * R * sqrt(log(bigN) / bigT))
    if (length(lambda_1) == 1) lambda_1 <- rep(lambda_1, bigN)

    if (is.null(lambda_2)) lambda_2 <- a2 * sqrt(log(max(bigN, bigT)))
    if (length(lambda_2) == 1) lambda_2 <- rep(lambda_2, bigN)

    if (is.null(lambda_3)) lambda_3 <- a3 * sqrt(log(max(bigN, bigT)))
    if (length(lambda_3) == 1) lambda_3 <- rep(lambda_3, bigN)

    CVXR_results <- foreach(ii = 1:bigN, .errorhandling = "pass") %do% {
      tryCatch({
        beta_i <- Variable(rows = bigN)
        clime_obj_i <- Minimize(norm1(beta_i))
        clime_constraints_i <- list(
          norm_inf(Sigma %*% beta_i - diag_N[ii, ]) <= lambda_1[ii],
          norm_inf(X %*% beta_i) <= lambda_2[ii],
          abs((1 / sqrt(bigT)) * sum(X %*% beta_i)) <= lambda_3[ii]
        )
        clime_problem_i <- Problem(clime_obj_i, clime_constraints_i)
        ret_list_i <- solve(clime_problem_i, solver = solver, ignore_dcp = ignore_dcp, warm_start = warm_start, parallel = parallel)

        if (ret_list_i$status == "optimal") {
          ret_list_i$beta_i <- ret_list_i$getValue(beta_i)
        } else {
          ret_list_i$beta_i <- rep(NA, bigN)
        }
        return(ret_list_i)
      }, error = function(e) {
        return(list(status = "error", message = e$message, beta_i = rep(NA, bigN)))
      })
    }

    Omega <- do.call(cbind, lapply(CVXR_results, function(x) as.numeric(x$beta_i)))
    lambda <- data.frame(lambda_1 = lambda_1, lambda_2 = lambda_2, lambda_3 = lambda_3)

    list(Omega = Omega, lambda = lambda, CVXR_results = CVXR_results)
  }

  bigT <- 50
  bigN <- 5
  set.seed(42)
  X <- matrix(rnorm(bigT * bigN), bigT, bigN)
  Sigma <- cov(X)

  # lambda = 0.8 is small enough to not be all-zero but large enough to be feasible
  lambda_1 <- rep(0.8, bigN)
  lambda_2 <- rep(0.8, bigN)
  lambda_3 <- rep(0.8, bigN)

  res_fastclime <- fastclime.ZKL15(X, Sigma, lambda_1, lambda_2, lambda_3)
  res_cvxr <- QLASSO.Hessian.Omega.ZKL15.CLIME(X, Sigma, lambda_1, lambda_2, lambda_3, solver="ECOS")

  # Verify matching dimensions
  expect_equal(dim(res_fastclime$Omega), c(bigN, bigN))
  expect_equal(dim(res_cvxr$Omega), c(bigN, bigN))

  # Allow for small differences due to ECOS vs Simplex exact numeric precision
  diff_norm <- max(abs(res_fastclime$Omega - res_cvxr$Omega), na.rm = TRUE)
  expect_lt(diff_norm, 1e-3)
})
