#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclp(): A parametric simplex LP solver                                     #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                           #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu> #
# Date: April 22th 2016                                                         #
# Version: 1.4.1					                                                      #
#-------------------------------------------------------------------------------#

#' A generic LP solver
#'
#' A generic linear programming solver using parametric simplex method.
#'
#' @details
#' This function is used to solve a general linear programming in standard
#' inequality form.
#' \deqn{\text{maximize} \quad obj^T x}
#' \deqn{\text{subject to} \quad mat \times x \le rhs, x \ge 0}
#'
#' @param obj The objective vector of the coefficient with length \code{n}.
#' @param mat The constraint matrix of the linear programming with dimension
#'   \eqn{m \times n}. Note this argument must be in matrix form even it is
#'   a vector.
#' @param rhs The right hand side vector of the constraint with length \code{m}.
#' @param lambda The parametric simplex method will stop when the calculated
#'   parameter is smaller than \code{lambda}. The default value is zero and it
#'   corresponds to the optimal value.
#'
#' @return The optimal value will be returned if it exists. Otherwise the
#'   function will indicate the problem is infeasible or unbounded.
#'
#' @note
#' The linear programming should be in the form: maximize \eqn{obj^T x},
#' subject to: \eqn{mat \times x \le rhs}, \eqn{x \ge 0}.
#' If the original problem is not in this form, the user has to convert it
#' into this form. For example, the equality constraints can be separated into
#' two inequality constraints.
#'
#' @author Haotian Pang, Han Liu and Robert Vanderbei \cr
#'   Maintainer: Haotan Pang<hpang@princeton.edu>
#'
#' @seealso \code{\link{fastclime}} and \code{\link{fastclime-package}}
#'
#' @examples
#' # generate an LP problem and solve it
#' A <- matrix(c(-1, -1, 0, 1, -2, 1), nrow = 3)
#' b <- c(-1, -2, 1)
#' c <- c(-2, 3)
#' fastlp(c, A, b)
#' @export
fastlp <- function(obj, mat, rhs, lambda = 0) {
  # Section Setup --------------------------------------------------------------
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
    str <- .C(
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
