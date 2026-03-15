library(zoo)
library(xts)

fastclime <- function(x, lambda.min = 0.1, nlambda = 50) {
  gcinfo(FALSE)

  stopifnot(!is.null(x), length(x) > 0, is.numeric(as.matrix(x)), !anyNA(as.matrix(x)))

  cov.input <- 1
  SigmaInput <- as.matrix(x)
  d <- dim(SigmaInput)[2]

  if (!isSymmetric(unname(SigmaInput))) {
    n <- dim(SigmaInput)[1]
    SigmaInput <- cov(SigmaInput) * (1 - 1 / n)
    cov.input <- 0
  }

  return(list(data = x, cov.input = cov.input, sigmahat = SigmaInput))
}

X_zoo <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
res <- try(fastclime(X_zoo))
if (!inherits(res, "try-error")) {
    cat("Success!\n")
    cat("Returned data class:", class(res$data), "\n")
}
