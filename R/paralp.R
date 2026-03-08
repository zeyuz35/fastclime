#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver for parameterized LP problems       #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                         #
# Version: 1.4.1						                                                    #
#-------------------------------------------------------------------------------#

#' A solver for parameterized LP problems
#'
#' A parameterized linear programming solver using parametric simplex method.
#'
#' This function is used to solve a general linear programming in standard
#' inequality form:
#' \deqn{\max obj^T x + obj\_bar \times \lambda \quad subject\ to:
#' mat \times x \le rhs + rhs\_bar \times \lambda, x \ge 0}
#'
#' @param obj The objective vector of the coefficient with length \code{n}.
#' @param mat The constraint matrix of the linear programming with dimension
#'   \code{m} by \code{n}.
#'   Note this argument must be in matrix form even it is a vector.
#' @param rhs The right hand side vector of the constraint with length \code{m}.
#' @param obj_bar The vector used to time the parameter and added to the
#'   objective vector, with length \code{n}.
#'   This perturbation vector must be nonnegative.
#' @param rhs_bar The vector used to time the parameter and added to the
#'   right hand side vector, with length \code{m}.
#'   This perturbation vector must be nonnegative.
#' @param lambda The parametric simplex method will stop when the calculated
#'   parameter is smaller than \code{lambda}.
#'   The default value is zero and it corresponds to the optimal value.
#'
#' @return The optimal value will be returned if it exists with a proper value
#'   of chosen lambda.
#'   Otherwise the function will indicate the problem is infeasible or
#'   unbounded.
#'
#' @author Haotian Pang, Han Liu and Robert Vanderbei \cr
#'   Maintainer: Haotan Pang <hpang@princeton.edu>
#' @seealso \code{\link{fastclime}} and \code{\link{fastclime-package}}
#' @examples
#' # Generate an LP problem and solve it
#' A <- matrix(c(-1, -1, 0, 1, -2, 1), nrow = 3)
#' b <- c(-1, -2, 1)
#' c <- c(-2, 3)
#' b_bar <- c(1, 1, 1)
#' c_bar <- c(1, 1)
#' paralp(c, A, b, c_bar, b_bar)
#' @export
paralp <- function(obj, mat, rhs, obj_bar, rhs_bar, lambda = 0) {
  # Section Setup --------------------------------------------------------------
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
    str <- .C(
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
      opt
    } else if (status == 1) {
      stop("The problem is infeasible!")
    } else if (status == 2) {
      stop("The problem is unbounded!")
    }
  }
}
