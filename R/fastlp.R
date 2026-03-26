#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver                                     #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                           #
# Version: 1.4.1					                                            #
#-------------------------------------------------------------------------------#

fastlp <- function(obj, mat, rhs, lambda = 0) {
  if (
    !is.numeric(obj) || !is.vector(obj) || anyNA(obj) || any(!is.finite(obj))
  ) {
    stop("obj must be a finite numeric vector")
  }
  if (
    !is.matrix(mat) || !is.numeric(mat) || anyNA(mat) || any(!is.finite(mat))
  ) {
    stop("mat must be a finite numeric matrix")
  }
  if (
    !is.numeric(rhs) || !is.vector(rhs) || anyNA(rhs) || any(!is.finite(rhs))
  ) {
    stop("rhs must be a finite numeric vector")
  }
  if (!is.numeric(lambda) || length(lambda) != 1 || !is.finite(lambda)) {
    stop("lambda must be a finite numeric scalar")
  }

  m <- length(rhs)
  n <- length(obj)
  m0 <- dim(mat)[1]
  n0 <- dim(mat)[2]

  opt <- rep(0, n)
  status <- 0
  error <- 0

  if (m != m0 || n != n0) {
    stop("Dimensions do not match!")
  }

  if (error == 0) {
    str = .C(
      "fastlp",
      as.double(obj),
      as.double(t(mat)),
      as.double(rhs),
      as.integer(m0),
      as.integer(n0),
      as.double(opt),
      as.integer(status),
      as.double(lambda),
      PACKAGE = "fastclime"
    )

    opt <- unlist(str[6])
    status <- unlist(str[7])

    if (status == 0) {
      message("optimal solution found!")
      return(opt)
    } else if (status == 1) {
      stop("The problem is infeasible!")
    } else if (status == 2) {
      stop("The problem is unbounded!")
    }
  }
}
