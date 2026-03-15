library(zoo)
library(xts)
source("R/fastclime.R")
source("R/dantzig.R")

cat("Testing fastclime with zoo object\n")
z <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
res <- try(fastclime(z))
if (inherits(res, "try-error")) {
    cat("fastclime failed\n")
} else {
    cat("fastclime success\n")
    print(class(res$data))
}

cat("Testing dantzig with zoo object\n")
X <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
y <- zoo(rnorm(20), order.by = 1:20)
res_d <- try(dantzig(X, y))
if (inherits(res_d, "try-error")) {
    cat("dantzig failed\n")
} else {
    cat("dantzig success\n")
    print(class(res_d$X))
}
