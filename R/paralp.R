#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver for parameterized LP problems       #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22nd 2016                                                           #
# Version: 1.4.1						                                        #
#-------------------------------------------------------------------------------#

#' @title Parametric Simplex LP Solver
#' @description Solves parameterized linear programming problems using the parametric simplex method
#' @export

paralp <- function(obj, mat, rhs, obj_bar, rhs_bar, lambda = 0) {
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
  if (
    !is.numeric(obj_bar) ||
      !is.vector(obj_bar) ||
      anyNA(obj_bar) ||
      any(!is.finite(obj_bar))
  ) {
    stop("obj_bar must be a finite numeric vector")
  }
  if (
    !is.numeric(rhs_bar) ||
      !is.vector(rhs_bar) ||
      anyNA(rhs_bar) ||
      any(!is.finite(rhs_bar))
  ) {
    stop("rhs_bar must be a finite numeric vector")
  }
  if (any(obj_bar < 0) || any(rhs_bar < 0)) {
    stop("The perturbation vector obj_bar and rhs_bar must be nonnegative")
  }
  if (!is.numeric(lambda) || length(lambda) != 1 || !is.finite(lambda)) {
    stop("lambda must be a finite numeric scalar")
  }

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

  if (as.numeric(m0) * as.numeric(n0) > .Machine$integer.max) {
    stop("Matrix dimensions exceed maximum supported by 32-bit integer indexing.")
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
      message("\roptimal solution found!       \n", appendLF = FALSE)
      flush.console()
      return(opt)
    } else if (status == 1) {
      stop("The problem is infeasible!")
    } else if (status == 2) {
      stop("The problem is unbounded!")
    }
  }
}
