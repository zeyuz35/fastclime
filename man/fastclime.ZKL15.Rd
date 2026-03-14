\name{fastclime.ZKL15}
\alias{fastclime.ZKL15}
\title{fastclime estimator with ZKL15 constraints}
\description{
  A fast solver for the CLIME estimator with two extra ZKL15 constraints using a parameterized simplex LP solver.
}
\usage{
fastclime.ZKL15(X, Sigma = NULL, lambda_1 = 0.1, lambda_2 = NULL, lambda_3 = NULL)
}
\arguments{
  \item{X}{The data matrix.}
  \item{Sigma}{The covariance matrix. If NULL, \code{cov(X)} will be used.}
  \item{lambda_1}{Penalty parameter 1.}
  \item{lambda_2}{Penalty parameter 2.}
  \item{lambda_3}{Penalty parameter 3.}
}
\value{
  A list with the estimated precision matrix \code{Omega} and the penalization parameters \code{lambda}.
}
\author{
  Original authors: Haotian Pang, Di Qi, Han Liu and Robert Vanderbei.
  ZKL15 extension author: Jules.
}
\examples{
  \dontrun{
  bigT <- 50
  bigN <- 5
  X <- matrix(rnorm(bigT * bigN), bigT, bigN)
  res <- fastclime.ZKL15(X)
  }
}
