#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# dantzig(): Dantzig Selector Function                                          #
# Authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei                    #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                           #
# Version: 1.4.1					                                            #
#-------------------------------------------------------------------------------#
dantzig <- function(X, y, lambda = 0.01, nlambda = 50) {
  if (!is.matrix(X) || !is.numeric(X)) {
    stop("X must be a numeric matrix")
  }
  if (!is.numeric(y) || !(is.vector(y) || (is.matrix(y) && ncol(y) == 1))) {
    stop("y must be a numeric vector or one-column numeric matrix")
  }
  if (is.matrix(y) && ncol(y) == 1) {
    y <- as.vector(y)
  }
  if (anyNA(X) || any(!is.finite(X)) || anyNA(y) || any(!is.finite(y))) {
    stop("X and y must not contain NA, NaN, or Inf values")
  }
  if (length(y) != nrow(X)) {
    stop("length(y) must equal nrow(X)")
  }
  if (!is.numeric(lambda) || length(lambda) != 1 || lambda < 0) {
    stop("lambda must be a single nonnegative numeric value")
  }
  if (!is.numeric(nlambda) || length(nlambda) != 1 || nlambda < 1) {
    stop("nlambda must be a single positive integer")
  }
  nlambda <- as.integer(nlambda)

  n0 <- nrow(X)
  d0 <- ncol(X)
  BETA0 <- matrix(0, d0, nlambda)
  lambdalist <- matrix(0, nlambda, 1)

  message("compute X^TX and X^y")

  X2 <- crossprod(X) # Equivalent to t(X) %*% X
  Xy <- crossprod(X, y) # Equivalent to t(X) %*% y

  message("start recovering")

  # start.time <- Sys.time()
  str <- .C(
    "dantzig",
    as.double(X2),
    as.double(Xy),
    as.double(BETA0),
    as.integer(d0),
    as.double(lambda),
    as.integer(nlambda),
    as.double(lambdalist),
    PACKAGE = "fastclime"
  )
  # end.time <- Sys.time()
  # t0 <- end.time - start.time

  # ptm <- proc.time()
  # cat("prepare the solution path \n")
  # proc.time() - ptm
  # print(ptm)

  rm(X2, Xy)
  BETA0 <- matrix(unlist(str[3]), d0, nlambda)
  lambdalist <- unlist(str[7])

  validn <- sum(lambdalist > 0)

  BETA0 <- BETA0[, 1:validn]

  final_lambda <- lambdalist[validn]
  message("lambdamin is ", final_lambda)

  lambdalist <- lambdalist[1:validn]
  result <- list(
    "X" = X,
    "y" = y,
    "BETA0" = BETA0,
    "n0" = n0,
    "d0" = d0,
    "validn" = validn,
    "lambdalist" = lambdalist
  )

  class(result) <- "dantzig"
  message("Done!")

  return(result)
}
