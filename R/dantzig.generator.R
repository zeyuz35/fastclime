#---------------------------------------------------------------------------------#
# Package: fastclime                                                              #
# Dantzig.generator: Generates sparse linear regression model for testing dantzig #
# Authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei                      #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu>   #
# Date: April 22nd 2016                                                           #
# Version: 1.4.1                                                                  #
#---------------------------------------------------------------------------------#

#' @title Dantzig Generator
#' @description Generates sparse linear regression model for testing dantzig selector.
#'
#' @param n Integer specifying the number of observations (sample size).
#' @param d Integer specifying the number of variables (dimension).
#' @param sparsity Numeric value for sparsity.
#'   If less than 1, it specifies the proportion of nonzero entries.
#'   If greater than or equal to 1, it specifies the exact number of nonzero entries.
#' @param sigma0 Numeric specifying the standard deviation of the noise vector.
#' @return An object of class \code{sim} containing:
#'   \item{X0}{The \code{n} by \code{d} matrix for the generated data}
#'   \item{y}{A length \code{n} response vector for the generated data}
#'   \item{BETA0}{A length \code{d} regression coefficient vector}
#'   \item{s}{The number of nonzero entries out of \code{d}}
#'   \item{pos}{A vector containing the indices of the nonzero entries}
#' @export
dantzig.generator <- function(n = 50, d = 100, sparsity = 0.1, sigma0 = 1) {
  # Section Setup -------------------------------------------------------------
  if (sparsity < 1) {
    s <- floor(d * sparsity)
  } else {
    s <- sparsity
  }

  BETA <- rep(0, d)
  pos <- rep(0, s)

  for (i in 1:s) {
    a <- rnorm(1, mean = 0, sd = 1)
    si <- 2 * (rbinom(1, 1, 0.5) - 0.5)
    n1 <- floor(runif(1, min = 1, max = d + 1))
    BETA[n1] <- si * (1 + a)
    pos[i] <- n1
  }

  sigma <- rnorm(n, mean = 0, sd = sigma0)

  X0 <- matrix(rnorm(n * d, mean = 0, sd = 1), n, d)
  y <- X0 %*% BETA + sigma

  sim <- list(X0 = X0, y = y, BETA0 = BETA, s = s, pos = pos)
  class(sim) <- "sim"
  return(sim)
}
