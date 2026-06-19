# setup.R ------------------------------------------------------------
#
# Test setup for CVXR ground truth functions
# These functions provide the reference implementation of CLIME using CVXR
# for verifying the fastclime C implementation
#
# Note: CVXR, MASS, and foreach must be installed for these tests
# --------------------------------------------------------------------

library(foreach)

# CLIME estimator (CVXR wrapper) ----------------------------------------

CLIME_CVXR <- function(
  X,
  Sigma = NULL,
  lambda,
  method = "index-wise",
  solver = "SCS",
  ignore_dcp = TRUE,
  warm_start = TRUE,
  ...
) {
  if (is.null(Sigma)) {
    Sigma <- cov.wt(X, center = FALSE, method = "ML")$cov
  }
  method <- match.arg(
    method,
    choices = c("index-wise", "direct")
  )
  ret_list <- switch(method,
    "index-wise" = CLIME_CVXR.index_wise(
      X = X,
      Sigma = Sigma,
      lambda = lambda,
      solver = solver,
      ignore_dcp = ignore_dcp,
      warm_start = warm_start,
      ...
    ),
    "direct" = CLIME_CVXR.direct(
      X = X,
      Sigma = Sigma,
      lambda = lambda,
      solver = solver,
      ignore_dcp = ignore_dcp,
      warm_start = warm_start,
      ...
    ),
    stop("Unknown method specified.")
  )
  class(ret_list) <- c("CLIME_CVXR", class(ret_list))
  return(ret_list)
}

# CLIME estimator (CVXR index-wise) ------------------------------------

CLIME_CVXR.index_wise <- function(
  X,
  Sigma,
  lambda,
  solver,
  ignore_dcp,
  warm_start,
  parallel = FALSE,
  ...
) {
  bigN <- ncol(Sigma)
  diag_N <- diag(bigN)
  CVXR_results <- foreach(ii = 1:bigN, .packages = "CVXR") %do% {
    beta_i <- Variable(bigN)
    clime_obj_i <- Minimize(norm1(beta_i))
    clime_constraints_i <- list(
      norm_inf(Sigma %*% beta_i - diag_N[ii, ]) <= lambda
    )
    clime_problem_i <- Problem(clime_obj_i, clime_constraints_i)
    ret_list_i <- solve(
      clime_problem_i,
      solver = solver,
      ignore_dcp = ignore_dcp,
      warm_start = warm_start,
      parallel = parallel,
      verbose = FALSE
    )
    ret_list_i$beta_i <- value(beta_i)
    return(ret_list_i)
  }
  Omega <- do.call(
    cbind,
    CVXR_results |> lapply(function(x) x$beta_i)
  )
  # Symmetrize (CLIME solves column-wise, so result is asymmetric)
  Omega <- (Omega + t(Omega)) / 2
  ret_list <- list(
    Omega = Omega,
    CVXR_results = CVXR_results
  )
  return(ret_list)
}

# CLIME estimator (CVXR direct) -----------------------------------------

CLIME_CVXR.direct <- function(
  X,
  Sigma,
  lambda,
  solver,
  ignore_dcp,
  warm_start,
  parallel = FALSE,
  ...
) {
  bigN <- ncol(Sigma)
  diag_N <- diag(bigN)
  Omega <- Variable(c(bigN, bigN), PSD = TRUE)
  clime_obj <- Minimize(norm1(Omega))
  clime_constraints <- list(norm_inf(Sigma %*% Omega - diag_N) <= lambda)
  clime_problem <- Problem(clime_obj, clime_constraints)
  CVXR_results <- solve(
    clime_problem,
    solver = solver,
    ignore_dcp = ignore_dcp,
    warm_start = warm_start,
    parallel = parallel,
    ...
  )
  Omega <- value(Omega)
  ret_list <- list(
    Omega = Omega,
    CVXR_results = CVXR_results
  )
  return(ret_list)
}
