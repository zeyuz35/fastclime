# fastclime.lambda(): Function used to select the solution path for a given lambda         #
# Authors: Haotian Pang, Han Liu and Robert Vanderbei                                      #
# Emails: <hpang@princeton.edu>, <hanliu@princeton.edu> and <rvdb@princetonedu>            #
# Date: April 22nd 2016                                                           #
# Version: 1.4.1					                                                       #
#------------------------------------------------------------------------------------------#

#' @title Select Solution Path for Given Lambda
#' @description Selects the appropriate solution from the computed path for a given lambda value
#' @export

fastclime.selector <- function(lambdamtx, icovlist, lambda) {
  gcinfo(FALSE)
  d <- dim(icovlist[[1]])[2]
  # make sure lambdamtx is treated as a matrix; if it has only one row
  # the previous code in fastclime() could return a vector due to
  # drop=TRUE, leading to dimension errors here.
  lambdamtx <- as.matrix(lambdamtx)
  maxnlambda <- dim(lambdamtx)[1]
  icov <- matrix(0, d, d)
  adaj <- matrix(0, d, d)
  seq <- rep(0, d)
  threshold <- 1e-5
  status <- 0

  for (i in 1:d) {
    temp_lambda <- which(lambdamtx[, i] > lambda)
    seq[i] <- length(temp_lambda)

    if ((seq[i] + 1) > maxnlambda) {
      status <- 1
      icov[, i] <- icovlist[[seq[i]]][, i]
    } else {
      icov[, i] <- icovlist[[seq[i] + 1]][, i]
    }
  }

  # Bolt: Optimize element-wise matrix symmetrization using logical indexing
  # to avoid creating multiple large temporary matrices and redundant multiplications.
  t_icov <- t(icov)
  idx <- abs(icov) > abs(t_icov)
  icov[idx] <- t_icov[idx]

  tmpicov <- icov
  diag(tmpicov) <- 0
  adaj <- Matrix(tmpicov > threshold, sparse = TRUE) * 1

  sparsity <- sum(adaj@x) / (d^2 - d)

  if (status == 1) {
    warning(
      "Some columns do not reach the required lambda!\nYou may want to increase lambda.min or use a larger nlambda."
    )
  }

  result <- list("icov" = icov, "adaj" = adaj, "sparsity" = sparsity)
  class(result) <- "fastclime.selector"

  return(result)
}
