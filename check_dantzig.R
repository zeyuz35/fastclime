library(zoo)
library(xts)
source("R/dantzig.R")
source("R/fastclime.R")

X_zoo <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
y_zoo <- zoo(rnorm(20), order.by = 1:20)

cat("Before fix:\n")
X2 = crossprod(X_zoo)
cat("Class of crossprod(X_zoo):", class(X2), "\n")
cat("Is numeric:", is.numeric(X2), "\n")
cat("Has dimnames:", !is.null(dimnames(X2)), "\n")
