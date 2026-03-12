#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclime(): Main Function                                                    #
# Authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei                    #
# Emails: <hpang@princeton.edu>, <dqi@princeton,edu>, <hanliu@princeton.edu>    #
# and <rvdb@princetonedu>                                                       #
# Date: April 22th 2016                                                         #
# Version: 1.4.1          					                                            #
#-------------------------------------------------------------------------------#
fastclime <- function(x, lambda.min = 0.1, nlambda = 50) {
  gcinfo(FALSE)
  cov.input <- 1

  # Extract numeric matrix for computation while preserving original object
  x_mat <- as.matrix(x)

  SigmaInput <- x_mat
  d <- dim(SigmaInput)[2]

  # unname prevents overly strict dimnames mismatch in isSymmetric
  if (!isSymmetric(unname(x_mat))) {
    n <- dim(SigmaInput)[1]
    SigmaInput <- cov(x_mat) * (1 - 1 / n)
    cov.input <- 0
  }

  message("Allocating memory")
  maxnlambda = 0
  mu_input <- matrix(0, nlambda, d)
  iicov <- matrix(0, nlambda, d * d)
  lambdamin <- lambda.min

  message("start recovering")
  str = .C(
    "parametric",
    as.double(SigmaInput),
    as.integer(d),
    as.double(mu_input),
    as.double(lambdamin),
    as.integer(nlambda),
    as.integer(maxnlambda),
    as.double(iicov),
    PACKAGE = "fastclime"
  )

  message("preparing precision and path matrix list")

  sigmahat <- matrix(unlist(str[1]), d)
  if (!is.null(colnames(x))) {
    colnames(sigmahat) <- colnames(x)
    rownames(sigmahat) <- colnames(x)
  }

  mu <- matrix(unlist(str[3]), nlambda, d)
  maxnlambda <- unlist(str[6]) + 1
  iicov <- matrix(unlist(str[7]), nlambda, d * d)
  # keep matrix structure even when maxnlambda == 1; drop=FALSE prevents
  # back-conversion to a vector which later breaks selector() calls.
  mu <- mu[1:maxnlambda, , drop = FALSE]
  icov <- list()

  for (i in seq_len(maxnlambda)) {
    icov[[i]] <- matrix(iicov[i, ], d, d)
    if (!is.null(colnames(x))) {
      colnames(icov[[i]]) <- colnames(x)
      rownames(icov[[i]]) <- colnames(x)
    }
  }
  #icov[maxnlambda+1]=list(icov[[maxnlambda]])

  result <- list(
    "data" = x,
    "cov.input" = cov.input,
    "sigmahat" = sigmahat,
    "maxnlambda" = maxnlambda,
    "lambdamtx" = mu,
    "icovlist" = icov
  )

  rm(
    x,
    cov.input,
    sigmahat,
    maxnlambda,
    mu,
    icov,
    iicov,
    nlambda,
    lambdamin,
    mu_input,
    SigmaInput,
    d
  )
  gc()
  class(result) = "fastclime"
  message("Done!")
  return(result)
}

print.fastclime = function(x, ...) {
  if (x$cov.input) {
    message("Input: The Covariance Matrix")
  }
  if (!x$cov.input) {
    message("Input: The Data Matrix")
  }
  message("Path length:", x$nlambda)
  message("Graph dimension:", ncol(x$data))
  #cat("Sparsity level:",min(x$sparsity),"----->",max(x$sparsity),"\n")
}


plot.fastclime = function(x, ...) {
  gcinfo(FALSE)
  s <- x$lambda[, 1]
  poslambda <- s[s > 0]
  npos <- length(poslambda)

  plot(
    x$lambda[1:npos, 1],
    x$sparsity[1:npos],
    log = "x",
    xlab = "Regularization Parameter",
    ylab = "Sparsity Level",
    type = "l",
    main = "Sparsity vs. Regularization"
  )
}
