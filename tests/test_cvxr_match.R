library(fastclime)
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
  # preliminary
  bigT <- nrow(X)
  bigN <- ncol(X)
  # bigN <- ncol(Sigma)
  diag_N <- diag(bigN)

  if (is.null(Sigma)) Sigma <- cov(X)

  C_X <- 1
  Rho <- eigen(Sigma, only.values = TRUE)$values
  rho_max <- Rho |> max()
  rho_min <- max(Rho |> min(), 0.01)
  # Do this as a vector
  sigma_x <- apply(X, 2, sd)
  R <- 1 / min(eigen(Sigma, only.values = TRUE)$values)

  # These are for the CLIME design
  a1 <- 2 *
    pmax(16, 36 * sigma_x^4) *
    (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2

  a2 <- sqrt(3) * sigma_x / rho_min
  a3 <- sqrt(2) * sigma_x / rho_min

  # lambda penalties
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

  if (is.null(lambda_3)) {
    lambda_3 <- a3 * sqrt(log(max(bigN, bigT)))
  }
  if (length(lambda_3) == 1) {
    lambda_3 <- rep(lambda_3, bigN)
  }

  CVXR_results <- foreach(ii = 1:bigN, .errorhandling = "pass") %do%
    {
      tryCatch(
        {
          beta_i <- Variable(rows = bigN)
          clime_obj_i <- Minimize(norm1(beta_i))
          clime_constraints_i <- list(
            norm_inf(Sigma %*% beta_i - diag_N[ii, ]) <= lambda_1[ii],
            norm_inf(X %*% beta_i) <= lambda_2[ii],
            abs(
              (1 / sqrt(bigT)) * sum(X %*% beta_i)
            ) <=
              lambda_3[ii]
          )
          clime_problem_i <- Problem(clime_obj_i, clime_constraints_i)
          ret_list_i <- solve(
            clime_problem_i,
            solver = solver,
            ignore_dcp = ignore_dcp,
            warm_start = warm_start,
            parallel = parallel
          )
          if (ret_list_i$status == "optimal") {
            ret_list_i$beta_i <- ret_list_i$getValue(beta_i)
          } else {
            ret_list_i$beta_i <- rep(NA, bigN)
          }
          return(ret_list_i)
        },
        error = function(e) {
          return(list(
            status = "error",
            message = e$message,
            beta_i = rep(NA, bigN)
          ))
        }
      )
    }

  Omega <- do.call(
    cbind,
    CVXR_results |> lapply(function(x) as.numeric(x$beta_i))
  )
  lambda <- data.frame(
    lambda_1 = lambda_1,
    lambda_2 = lambda_2,
    lambda_3 = lambda_3
  )
  ret_list <- list(
    Omega = Omega,
    lambda = lambda,
    CVXR_results = CVXR_results
  )
  return(ret_list)
}

bigT <- 50
bigN <- 5
set.seed(42)
X <- matrix(rnorm(bigT * bigN), bigT, bigN)
Sigma <- cov(X)
diag_N <- diag(bigN)

lambda_1 <- rep(0.8, bigN)
lambda_2 <- rep(0.8, bigN)
lambda_3 <- rep(0.8, bigN)

cat("Running fastclime.ZKL15 ...\n")
res_fastclime <- fastclime.ZKL15(X, Sigma, lambda_1, lambda_2, lambda_3)

cat("Running CVXR ...\n")
res_cvxr <- QLASSO.Hessian.Omega.ZKL15.CLIME(X, Sigma, lambda_1, lambda_2, lambda_3, solver="ECOS")

omega_f <- res_fastclime$Omega
omega_c <- res_cvxr$Omega

cat("dim(omega_f):", dim(omega_f), "\n")
cat("dim(omega_c):", dim(omega_c), "\n")
print(omega_f)
print(omega_c)

diff_norm <- max(abs(omega_f - omega_c), na.rm=TRUE)
cat(sprintf("Max difference between fastclime and CVXR solutions: %f\n", diff_norm))

if (diff_norm < 1e-3) {
  cat("SUCCESS: Both implementations match!\n")
} else {
  cat("WARNING: Solutions differ.\n")
  stop("Implementations do not match.")
}
