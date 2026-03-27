#-------------------------------------------------------------------------------#
# Package: fastclime                                                            #
# fastclime(): Main Function                                                    #
# Authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei                    #
# Emails: <hpang@princeton.edu>, <dqi@princeton,edu>, <hanliu@princeton.edu>    #
# and <rvdb@princetonedu>                                                       #
# Date: April 22th 2016                                                         #
# Version: 1.4.1          					                                            #
#-------------------------------------------------------------------------------#
#' The main solver for fastclime package
#'
#' A fast parametric simplex solver for constrainted l1 minimization approach to sparse precision matrix estimation.
#'
#' @param x There are 2 options: (1) \code{x} is an \code{n} by \code{d} data matrix (2) a \code{d} by \code{d} sample covariance matrix. The program automatically identifies the input matrix by checking the symmetry. (\code{n} is the sample size and \code{d} is the dimension)
#' @param lambda.min This is the smallest value of lambda you would like the solver to explorer. The default value is \code{0.1}. If \code{nlambda} is large enough, the precision matrix selector function \code{\link{fastclime.selector}} will be able to find all precision matrix corresponding to all lambda values ranging from \code{1} to \code{lambda.min}.
#' @param nlambda It is the number of the path length one would like to achieve. The default length is 50. Note if d is large and nlambda is also large, it is possible that the program will fail to allocate memory for the path.
#'
#' @details
#' This program uses parametric simplex linear programming method to solve CLIME (Constrained l1 Minimization Sparse Precision Matrix Estimation) problem. The solution path of the problem corresponds to the parameter in the parametric simplex method.
#' The formulation of CLIME is given as:
#' \deqn{\min ||\Omega||_1 \quad \mathrm{subject\ to} \quad ||\hat{\Sigma} \Omega - I||_\infty \le \lambda}
#' where \eqn{\hat{\Sigma}} is the empirical covariance matrix and \eqn{\Omega} is the precision matrix.
#'
#' @note
#' The program will stop when either the maximum number of iteration for each column \code{nlambda} is achieved or when the required \code{lambda.min} is achieved for each column. When the dimension is huge, make sure \code{nlambda} is small so that there are enough memory to allocate the solution path. \code{lambdamtx} and \code{icovlist} will be used in \code{\link{fastclime.selector}}.
#'
#' @return An object with S3 class \code{"fastclime"} is returned:
#' \item{data}{The \code{n} by \code{d} data matrix or \code{d} by \code{d} sample covariance matrix from the input}
#' \item{cov.input}{An indicator of the sample covariance.}
#' \item{sigmahat}{The empirical covariance of the data. If cov.inpu is TRUE, sigmahat = data}
#' \item{maxnlambda}{The length of the path. If the program finds \code{lambda.min} in less than \code{nlambda} iterations for all columns, then the acutal maximum lenth for all columns will be returned. Otherwise it equals \code{nlambda}.}
#' \item{lambdamtx}{The sequence of regularization parameters for each column, it is a \code{nlambda} by \code{d} matrix. It will be filled with 0 when the program finds the required \code{lambda.min} value for that column. This parameter is required for \code{\link{fastclime.selector}}.}
#' \item{icovlist}{A \code{nlambda} list of \code{d} by \code{d} precision matrices as an alternative graph path (numerical path) corresponding to \code{lambdamtx}. This parameter is also required for \code{\link{fastclime.selector}}.}
#'
#' @author
#' Haotian Pang, Han Liu and Robert Vanderbei \cr
#' Maintainer: Haotian Pang<hpang@princeton.edu>
#'
#' @references
#' Cai, T., Liu, W., & Luo, X. (2011). A constrained \eqn{\ell_1} minimization approach to sparse precision matrix estimation. \emph{Journal of the American Statistical Association}, 106(494), 594-607. \cr
#' Cai, T., and Liu, W. (2011). A Dantzig selector-type estimator for statistical estimation. \emph{Annals of Statistics}, 39(5).
#'
#' @seealso \code{\link{fastclime.generator}}, \code{\link{fastclime.plot}}, \code{\link{fastclime.selector}} and \code{\link{fastclime-package}}.
#' @examples
#' \dontrun{
#' #generate data
#' L = fastclime.generator(n = 100, d = 20)
#'
#' #graph path estimation
#' out1 = fastclime(L$data,0.1)
#' out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)
#' fastclime.plot(out2$adaj)
#'
#' #graph path estimation using the sample covariance matrix as the input.
#' out1 = fastclime(cor(L$data),0.1)
#' out2 = fastclime.selector(out1$lambdamtx, out1$icovlist,0.2)
#' fastclime.plot(out2$adaj)
#' }
#' @export
fastclime <- function(x, lambda.min = 0.1, nlambda = 50) {
  if (is.data.frame(x)) {
    x <- data.matrix(x)
  }
  if (!is.matrix(x) || !is.numeric(x)) {
    stop("x must be a numeric matrix or data frame")
  }
  if (anyNA(x) || any(!is.finite(x))) {
    stop("x must not contain NA, NaN, or Inf values")
  }
  if (nrow(x) < 2 || ncol(x) < 1) {
    stop("x must have at least 2 rows and 1 column")
  }
  if (!is.numeric(lambda.min) || length(lambda.min) != 1 || lambda.min < 0) {
    stop("lambda.min must be a single nonnegative numeric value")
  }
  if (!is.numeric(nlambda) || length(nlambda) != 1 || nlambda < 1) {
    stop("nlambda must be a single positive integer")
  }
  nlambda <- as.integer(nlambda)

  gcinfo(FALSE)
  cov.input <- 1
  SigmaInput <- x
  d <- dim(SigmaInput)[2]

  if (!isSymmetric(unname(as.matrix(unclass(x))))) {
    n <- dim(SigmaInput)[1]
    SigmaInput <- cov(x) * (1 - 1 / n)
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
  mu <- matrix(unlist(str[3]), nlambda, d)
  maxnlambda <- unlist(str[6]) + 1
  iicov <- matrix(unlist(str[7]), nlambda, d * d)
  # keep matrix structure even when maxnlambda == 1; drop=FALSE prevents
  # back-conversion to a vector which later breaks selector() calls.
  mu <- mu[1:maxnlambda, , drop = FALSE]
  icov <- list()

  for (i in seq_len(maxnlambda)) {
    icov[[i]] <- matrix(iicov[i, ], d, d)
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

  class(result) = "fastclime"
  message("Done!")
  return(result)
}

#' @export
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


#' @export
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
