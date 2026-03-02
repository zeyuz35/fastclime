fastclime.BK17 <- function(X, lambda_1 = 0.1, lambda_2 = NULL, solver = "SCS", ignore_dcp = TRUE, warm_start = TRUE, parallel = FALSE, ...) {
  bigT <- nrow(X)
  bigN <- ncol(X)
  diag_N <- diag(bigN)
  Sigma <- cov(X) * (1 - 1/bigT) # the package uses this formula internally for the sample cov

  sigma_x <- apply(X, 2, sd)

  # According to the provided implementation:
  Rho <- eigen(Sigma, only.values = TRUE)$values
  rho_min <- max(min(Rho), 0.01)
  a2 <- sqrt(3) * sigma_x / rho_min
  if (is.null(lambda_2)) {
    lambda_2 <- a2 * sqrt(log(max(bigN, bigT)))
  }
  if (length(lambda_2) == 1) {
    lambda_2 <- rep(lambda_2, bigN)
  }
  if (length(lambda_1) == 1) {
    lambda_1 <- rep(lambda_1, bigN)
  }

  # Then it calls fastlp in a loop 1:bigN
  # The constraints are:
  # norm_inf(Sigma %*% beta_i - e_i) <= lambda_1[ii]
  # norm_inf(X %*% beta_i) <= lambda_2[ii]
  # objective: minimize norm1(beta_i)
}
