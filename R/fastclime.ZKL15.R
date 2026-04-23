#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclime.ZKL15(): ZKL15 CLIME variant                                        #
#-------------------------------------------------------------------------------#

#' fastclime.ZKL15
#'
#' Implementation of the fastclime.ZKL15 variant using the fastlp solver.
#'
#' @param X T by N data matrix
#' @param Sigma Sample covariance matrix. If NULL, it will be calculated from X.
#' @param lambda_1 Regularization parameter for the precision matrix constraint.
#' @param lambda_2 Regularization parameter for the data constraint.
#' @param lambda_3 Regularization parameter for the sum constraint.
#' @param solver LP solver to use. Defaults to "fastlp".
#' @param parallel Whether to use parallel processing. Defaults to FALSE.
#' @param ... Additional arguments
#' @return List containing Omega, lambda values, and results.
#' @export
fastclime.ZKL15 <- function(
  X,
  Sigma = NULL,
  lambda_1 = 0.1,
  lambda_2 = NULL,
  lambda_3 = NULL,
  solver = "fastlp",
  parallel = FALSE,
  ...
) {
  # preliminary
  bigT <- nrow(X)
  bigN <- ncol(X)

  if (is.null(Sigma)) {
    # Bolt: optimize matrix multiplication
    Sigma <- crossprod(X) / bigT
  }

  diag_N <- diag(bigN)

  # Calculate penalty parameters if not provided
  sigma_x <- apply(X, 2, sd)
  # Bolt: optimize eigenvalue calculation for symmetric matrix
  Rho <- eigen(Sigma, symmetric = TRUE, only.values = TRUE)$values
  rho_min <- max(min(Rho), 0.01)
  R <- 1 / rho_min

  a1 <- 2 *
    pmax(16, 36 * sigma_x^4) *
    (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2

  a2 <- sqrt(3) * sigma_x / rho_min
  a3 <- sqrt(2) * sigma_x / rho_min

  if (is.null(lambda_1)) {
    lambda_1 <- a1 * R * sqrt(log(bigN) / bigT)
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

  # Prepare objects for fastlp
  # fastlp is a MAXIMIZER, so to minimize L1 norm sum(beta_pos + beta_neg),
  # we maximize its negation: max -sum(beta_pos + beta_neg).
  # Variables: x = [beta_pos; beta_neg] (length 2N)
  obj <- rep(-1, 2 * bigN)

  # Constraint matrices
  # A %*% x <= b
  # 1. Sigma(beta_pos - beta_neg) <= diag_N[ii,] + lambda_1[ii]
  # 2. -Sigma(beta_pos - beta_neg) <= -diag_N[ii,] + lambda_1[ii]
  # 3. X(beta_pos - beta_neg) <= lambda_2[ii]
  # 4. -X(beta_pos - beta_neg) <= lambda_2[ii]
  # 5. sum(X %*% beta)/sqrt(T) <= lambda_3[ii]
  # 6. -sum(X %*% beta)/sqrt(T) <= lambda_3[ii]

  sumX_sqrtT <- colSums(X) / sqrt(bigT)

  # Construct A (parts shared across columns)
  A_top <- rbind(Sigma, -Sigma)
  A_mid <- rbind(X, -X)
  A_bot <- rbind(sumX_sqrtT, -sumX_sqrtT)

  A <- rbind(
    cbind(A_top, -A_top),
    cbind(A_mid, -A_mid),
    cbind(A_bot, -A_bot)
  )

  # Solve for each column
  # We can use parallel if requested
  if (parallel && requireNamespace("parallel", quietly = TRUE)) {
    results <- parallel::mclapply(1:bigN, function(ii) {
      # rhs for column ii
      rhs <- c(
        diag_N[ii, ] + lambda_1[ii],
        -diag_N[ii, ] + lambda_1[ii],
        rep(lambda_2[ii], 2 * bigT),
        rep(lambda_3[ii], 2)
      )

      tryCatch(
        {
          opt <- fastlp(obj, A, rhs)
          beta_i <- opt[1:bigN] - opt[(bigN + 1):(2 * bigN)]
          return(list(beta_i = beta_i, status = "success"))
        },
        error = function(e) {
          return(list(
            beta_i = rep(NA, bigN),
            status = "error",
            message = e$message
          ))
        }
      )
    })
  } else {
    results <- lapply(1:bigN, function(ii) {
      rhs <- c(
        diag_N[ii, ] + lambda_1[ii],
        -diag_N[ii, ] + lambda_1[ii],
        rep(lambda_2[ii], 2 * bigT),
        rep(lambda_3[ii], 2)
      )

      tryCatch(
        {
          opt <- fastlp(obj, A, rhs)
          beta_i <- opt[1:bigN] - opt[(bigN + 1):(2 * bigN)]
          return(list(beta_i = beta_i, status = "success"))
        },
        error = function(e) {
          return(list(
            beta_i = rep(NA, bigN),
            status = "error",
            message = e$message
          ))
        }
      )
    })
  }

  Omega <- do.call(cbind, lapply(results, function(x) x$beta_i))

  ret_list <- list(
    Omega = Omega,
    lambda = data.frame(
      lambda_1 = lambda_1,
      lambda_2 = lambda_2,
      lambda_3 = lambda_3
    ),
    results = results
  )

  return(ret_list)
}
