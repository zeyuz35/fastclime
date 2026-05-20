#' @title Select Dantzig Selector Solution
#' @description Selects the appropriate solution from the Dantzig selector path
#' @export

dantzig.selector <- function(lambdalist, BETA0, lambda) {
  # if BETA0 dimensions do not match, throw error
  if (length(lambdalist) != dim(BETA0)[2]) {
    stop("BETA0 and lambdalist dimensions are incompatible \n")
  }

  if (lambdalist[length(lambdalist)] > lambda) {
    beta0 <- BETA0[, length(lambdalist)]
  } else {
    beta0 <- BETA0[, which.max(lambdalist <= lambda)]
  }

  # Curator: Preserve rownames of beta matrix as names for output vector
  names(beta0) <- rownames(BETA0)

  return(beta0)
}
