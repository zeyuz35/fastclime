#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver for parameterized LP problems       #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                           #
# Version: 1.4.1						                                        #
#-------------------------------------------------------------------------------#

paralp <- function(obj, mat, rhs, obj_bar, rhs_bar, lambda = 0) {
  stopifnot(!is.null(obj), length(obj) > 0, is.numeric(as.matrix(obj)), !anyNA(as.matrix(obj)), !is.null(mat), length(mat) > 0, is.numeric(as.matrix(mat)), !anyNA(as.matrix(mat)), !is.null(rhs), length(rhs) > 0, is.numeric(as.matrix(rhs)), !anyNA(as.matrix(rhs)), !is.null(obj_bar), length(obj_bar) > 0, is.numeric(as.matrix(obj_bar)), !anyNA(as.matrix(obj_bar)), !is.null(rhs_bar), length(rhs_bar) > 0, is.numeric(as.matrix(rhs_bar)), !anyNA(as.matrix(rhs_bar)))
  m <- length(rhs)
  n <- length(obj)
  m1 <- length(rhs_bar)
  n1 <- length(obj_bar)
  m0 <- dim(mat)[1]
  n0 <- dim(mat)[2]

  opt <- rep(0, n)
  status <- 0
  error <- 0

  if (m != m0 || n != n0 || m != m1 || n != n1) {
    stop("Dimensions do not match!")
  }

  if (any(obj_bar < 0) || any(rhs_bar < 0)) {
    stop("The pertubation vector obj_bar and rhs_bar must be nonnegative!")
  }

  if (error == 0) {
    str = .C(
      "paralp",
      as.double(obj),
      as.double(t(mat)),
      as.double(rhs),
      as.integer(m0),
      as.integer(n0),
      as.double(opt),
      as.integer(status),
      as.double(lambda),
      as.double(rhs_bar),
      as.double(obj_bar),
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
