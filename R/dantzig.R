#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# dantzig(): Dantzig Selector Function                                          #
# Authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei                    #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                           #
# Version: 1.4.1					                                            #
#-------------------------------------------------------------------------------#
dantzig <- function(X, y, lambda = 0.01, nlambda = 50) {
  stopifnot(!is.null(X), length(X) > 0, is.numeric(as.matrix(X)), !anyNA(as.matrix(X)))
  stopifnot(!is.null(y), length(y) > 0, is.numeric(as.matrix(y)), !anyNA(as.matrix(y)))

  X_mat <- as.matrix(X)
  y_mat <- as.matrix(y)
  input_colnames <- colnames(X_mat)

  n0 <- nrow(X_mat)
  d0 <- ncol(X_mat)
  BETA0 <- matrix(0, d0, nlambda)
  lambdalist <- matrix(0, nlambda, 1)

  message("compute X^TX and X^y")

  X2 = crossprod(X_mat) # Equivalent to t(X) %*% X
  Xy = crossprod(X_mat, y_mat) # Equivalent to t(X) %*% y

  message("start recovering")

  # start.time <- Sys.time()
  str = .C(
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
  if (!is.null(input_colnames)) {
    rownames(BETA0) <- input_colnames
  }

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

  gc()
  class(result) = "dantzig"
  message("Done!")

  return(result)
}
