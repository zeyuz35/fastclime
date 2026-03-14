# This file is loaded by testthat before any tests are run

# CVXR implementations of BK17 methods for benchmarking and correctness verification
if (requireNamespace("CVXR", quietly = TRUE)) {
  library(CVXR)

  QLASSO.Hessian.Omega.BK17.CLIME.CVXR <- function(
    X,
    Sigma = NULL,
    lambda_1 = 0.1,
    lambda_2 = NULL,
    solver = "SCS",
    ignore_dcp = TRUE,
    warm_start = TRUE,
    parallel = FALSE,
    ...
  ) {
    # preliminary
    bigT <- nrow(X)
    bigN <- ncol(X)
    diag_N <- diag(bigN)

    if (is.null(Sigma)) {
       Sigma <- cov(X) * (1 - 1/bigT)
    }

    sigma_x <- apply(X, 2, sd)
    Rho <- eigen(Sigma, only.values = TRUE)$values
    rho_min <- max(min(Rho), 0.01)

    a1 <- 2 * pmax(16, 36 * sigma_x^4) * (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2
    a2 <- sqrt(3) * sigma_x / rho_min
    R <- 1 / min(Rho)

    if (is.null(lambda_1)) {
      lambda_1 <- (a1 * R * sqrt(log(bigN) / bigT))
    }
    if (length(lambda_1) == 1) {
      lambda_1 <- rep(lambda_1, bigN)
    }

    if (is.null(lambda_2)) {
      lambda_2 <- a2 * sqrt(log(max(bigN, bigT)))
    }
    if (length(lambda_2) == 1) {
      lambda_2 <- rep(lambda_2, bigN)
    }

    CVXR_results <- lapply(1:bigN, function(ii) {
        beta_i <- Variable(rows = bigN)
        clime_obj_i <- Minimize(norm1(beta_i))
        clime_constraints_i <- list(
          norm_inf(Sigma %*% beta_i - diag_N[ii, ]) <= lambda_1[ii],
          norm_inf(X %*% beta_i) <= lambda_2[ii]
        )
        clime_problem_i <- Problem(clime_obj_i, clime_constraints_i)
        ret_list_i <- solve(
          clime_problem_i,
          solver = solver,
          ignore_dcp = ignore_dcp,
          warm_start = warm_start
        )
        ret_list_i$beta_i <- ret_list_i$getValue(beta_i)
        return(ret_list_i)
    })

    Omega <- do.call(cbind, lapply(CVXR_results, function(x) x$beta_i))

    lambda <- data.frame(
      lambda_1 = lambda_1,
      lambda_2 = lambda_2
    )

    ret_list <- list(
      Omega = Omega,
      lambda = lambda
    )
    return(ret_list)
  }

  QLASSO.Hessian.Omega.BK17.index_wise.CVXR <- function(
    X,
    Sigma,
    lambda,
    solver = "SCS",
    ignore_dcp = TRUE,
    warm_start = TRUE,
    parallel = FALSE,
    ...
  ) {
    if (missing(Sigma) || is.null(Sigma)) {
      bigT <- nrow(X)
      Sigma <- cov(X) * (1 - 1/bigT)
    }

    bigN <- ncol(Sigma)
    diag_N <- diag(bigN)
    Omega <- Variable(bigN, bigN, PSD = FALSE) # No PSD in original script, user set it to TRUE but we test non-PSD equivalence here
    clime_obj <- Minimize(norm1(Omega))

    clime_constraints <- list()
    if (length(lambda) == 1) {
      lambda_vec <- rep(lambda, bigN)
    } else {
      lambda_vec <- lambda
    }

    # User's CVXR uses norm_inf(Sigma %*% Omega - diag_N) <= lambda
    # Meaning max abs element of the whole matrix <= lambda
    clime_constraints <- list(norm_inf(Sigma %*% Omega - diag_N) <= lambda)

    clime_problem <- Problem(clime_obj, clime_constraints)
    CVXR_results <- solve(
      clime_problem,
      solver = solver,
      ignore_dcp = ignore_dcp,
      warm_start = warm_start
    )

    Omega <- CVXR_results$getValue(Omega)
    ret_list <- list(
      Omega = Omega
    )
    return(ret_list)
  }
}
