library(zoo)
library(xts)

dantzig <- function(X, y, lambda = 0.01, nlambda = 50) {
  stopifnot(!is.null(X), length(X) > 0, is.numeric(as.matrix(X)), !anyNA(as.matrix(X)))
  stopifnot(!is.null(y), length(y) > 0, is.numeric(as.matrix(y)), !anyNA(as.matrix(y)))

  X_mat <- as.matrix(X)
  y_mat <- as.matrix(y)

  n0 <- nrow(X_mat)
  d0 <- ncol(X_mat)
  BETA0 <- matrix(0, d0, nlambda)
  lambdalist <- matrix(0, nlambda, 1)

  X2 = crossprod(X_mat)
  Xy = crossprod(X_mat, y_mat)

  return(list(X = X, y = y, BETA0 = BETA0))
}

X_zoo <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
y_zoo <- zoo(rnorm(20), order.by = 1:20)
res <- try(dantzig(X_zoo, y_zoo))
if (!inherits(res, "try-error")) {
    cat("Success!\n")
    cat("Returned X class:", class(res$X), "\n")
    cat("Returned y class:", class(res$y), "\n")
}
