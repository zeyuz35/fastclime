#' Quantile LASSO Hessian (BK17 CLIME)
#'
#' @param X \eqn{T \times N} data matrix
#' @param Sigma Sample covariance matrix. Defaults to `NULL`.
#' @param lambda_1 Regularization parameter 1. Defaults to 0.1.
#' @param lambda_2 Regularization parameter 2. Defaults to `NULL`.
#' @param solver ignored
#' @param ignore_dcp ignored
#' @param warm_start ignored
#' @param parallel ignored
#' @param ... Additional arguments
#' @return List containing `Omega`, `lambda` values
#' @export
QLASSO.Hessian.Omega.BK17.CLIME <- function(
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

  if (is.null(Sigma)) {
    Sigma <- cov(X) * (1 - 1/bigT)
  }

  Rho <- eigen(Sigma, only.values = TRUE)$values
  rho_min <- max(min(Rho), 0.01)
  sigma_x <- apply(X, 2, sd)

  R <- 1 / min(Rho)

  a1 <- 2 * pmax(16, 36 * sigma_x^4) * (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2
  a2 <- sqrt(3) * sigma_x / rho_min

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

  Omega <- matrix(0, bigN, bigN)

  obj <- rep(-1, 2 * bigN)
  mat <- rbind(
    cbind(Sigma, -Sigma),
    cbind(-Sigma, Sigma),
    cbind(X, -X),
    cbind(-X, X)
  )

  for (ii in 1:bigN) {
    e_i <- rep(0, bigN)
    e_i[ii] <- 1

    rhs <- c(
      lambda_1 + e_i,
      lambda_1 - e_i,
      lambda_2,
      lambda_2
    )

    tryCatch({
      opt <- fastlp(obj, mat, rhs)
      u <- opt[1:bigN]
      v <- opt[(bigN + 1):(2 * bigN)]
      Omega[, ii] <- u - v
    }, error = function(e) {
      warning(paste("Error in column", ii, ":", e$message))
    })
  }

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

#' Quantile LASSO Hessian (BK17 Index Wise)
#'
#' @param X Data matrix
#' @param Sigma Sample covariance matrix
#' @param lambda Regularization parameter
#' @param solver ignored
#' @param ignore_dcp ignored
#' @param warm_start ignored
#' @param parallel ignored
#' @param ... Additional arguments
#' @return List containing `Omega`
#' @export
QLASSO.Hessian.Omega.BK17.index_wise <- function(
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
  Omega <- matrix(0, bigN, bigN)

  obj <- rep(-1, 2 * bigN)
  mat <- rbind(
    cbind(Sigma, -Sigma),
    cbind(-Sigma, Sigma)
  )

  if (length(lambda) == 1) {
    lambda <- rep(lambda, bigN)
  }

  for (ii in 1:bigN) {
    e_i <- rep(0, bigN)
    e_i[ii] <- 1

    rhs <- c(
      lambda + e_i,
      lambda - e_i
    )

    tryCatch({
      opt <- fastlp(obj, mat, rhs)
      u <- opt[1:bigN]
      v <- opt[(bigN + 1):(2 * bigN)]
      Omega[, ii] <- u - v
    }, error = function(e) {
      warning(paste("Error in column", ii, ":", e$message))
    })
  }

  ret_list <- list(
    Omega = Omega
  )

  return(ret_list)
}
