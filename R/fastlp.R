#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver                                     #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                           #
# Version: 1.4.1					                                            #
#-------------------------------------------------------------------------------#

fastlp <- function(obj, mat, rhs, lambda = 0) {
  stopifnot(!is.null(obj), length(obj) > 0, is.numeric(as.vector(obj)), !anyNA(as.vector(obj)))
  stopifnot(!is.null(mat), length(mat) > 0, is.numeric(as.matrix(mat)), !anyNA(as.matrix(mat)))
  stopifnot(!is.null(rhs), length(rhs) > 0, is.numeric(as.vector(rhs)), !anyNA(as.vector(rhs)))
  stopifnot(!is.null(lambda), length(lambda) == 1, is.numeric(lambda), !is.na(lambda))
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
