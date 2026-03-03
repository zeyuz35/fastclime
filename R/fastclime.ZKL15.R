#-------------------------------------------------------------------------------#
# fastclime.ZKL15(): A variant of fastclime with ZKL15 constraints              #
#-------------------------------------------------------------------------------#

fastclime.ZKL15 <- function(
  X,
  Sigma = NULL,
  lambda_1 = 0.1,
  lambda_2 = NULL,
  lambda_3 = NULL
) {
  if (is.null(Sigma)) {
    Sigma <- cov(X)
  }

  bigT <- nrow(X)
  bigN <- ncol(X)
  diag_N <- diag(bigN)

  Rho <- eigen(Sigma, only.values = TRUE)$values
  rho_max <- max(Rho)
  rho_min <- max(min(Rho), 0.01)
  sigma_x <- apply(X, 2, sd)
  R <- 1 / min(eigen(Sigma, only.values = TRUE)$values)

  a1 <- 2 * pmax(16, 36 * sigma_x^4) * (5 + 4 * exp(2) * pmax(4, 6 * sigma_x^2))^2
  a2 <- sqrt(3) * sigma_x / rho_min
  a3 <- sqrt(2) * sigma_x / rho_min

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

  w <- colSums(X) / sqrt(bigT)

  mat <- rbind(
    cbind(Sigma, -Sigma),
    cbind(-Sigma, Sigma),
    cbind(X, -X),
    cbind(-X, X),
    c(w, -w),
    c(-w, w)
  )

  obj <- rep(-1, 2 * bigN)

  Omega <- matrix(NA, nrow = bigN, ncol = bigN)

  for (ii in 1:bigN) {
    ei <- diag_N[ii, ]

    rhs1 <- lambda_1[ii] + ei
    rhs2 <- lambda_1[ii] - ei
    rhs3 <- rep(lambda_2[ii], bigT)
    rhs4 <- rep(lambda_2[ii], bigT)
    rhs5 <- lambda_3[ii]
    rhs6 <- lambda_3[ii]

    rhs <- c(rhs1, rhs2, rhs3, rhs4, rhs5, rhs6)

    m <- length(rhs)
    n <- length(obj)

    opt <- rep(0, n)
    status <- 0
    str <- .C(
      "fastlp",
      as.double(obj),
      as.double(t(mat)),
      as.double(rhs),
      as.integer(m),
      as.integer(n),
      as.double(opt),
      as.integer(status),
      as.double(0),
      PACKAGE = "fastclime"
    )

    out_status <- unlist(str[7])
    out_opt <- unlist(str[6])

    if (out_status == 0) {
      Omega[, ii] <- out_opt[1:bigN] - out_opt[(bigN + 1):(2 * bigN)]
    } else {
      Omega[, ii] <- rep(NA, bigN)
    }
  }

  lambda <- data.frame(
    lambda_1 = lambda_1,
    lambda_2 = lambda_2,
    lambda_3 = lambda_3
  )

  ret_list <- list(
    Omega = Omega,
    lambda = lambda
  )

  class(ret_list) <- "fastclime.ZKL15"
  return(ret_list)
}