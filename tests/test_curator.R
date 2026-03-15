library(zoo)
library(xts)
library(fastclime)

cat("Testing fastclime with zoo object\n")
z <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
colnames(z) <- paste0("V", 1:5)

res <- try(fastclime(z))
if (inherits(res, "try-error")) {
    stop("fastclime failed with zoo")
} else {
    stopifnot(inherits(res$data, "zoo"))
    stopifnot(all(colnames(res$sigmahat) == paste0("V", 1:5)))
    cat("fastclime success with zoo\n")
}

cat("Testing fastclime with xts object\n")
x <- xts(matrix(rnorm(100), 20, 5), order.by = as.Date(1:20))
colnames(x) <- paste0("C", 1:5)
res2 <- try(fastclime(x))
if (inherits(res2, "try-error")) {
    stop("fastclime failed with xts")
} else {
    stopifnot(inherits(res2$data, "xts"))
    stopifnot(all(colnames(res2$sigmahat) == paste0("C", 1:5)))
    cat("fastclime success with xts\n")
}


cat("Testing dantzig with zoo object\n")
X_zoo <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
colnames(X_zoo) <- paste0("X", 1:5)
y_zoo <- zoo(rnorm(20), order.by = 1:20)

res_d <- try(dantzig(X_zoo, y_zoo))
if (inherits(res_d, "try-error")) {
    stop("dantzig failed with zoo")
} else {
    stopifnot(inherits(res_d$X, "zoo"))
    stopifnot(inherits(res_d$y, "zoo"))
    stopifnot(all(rownames(res_d$BETA0) == paste0("X", 1:5)))
    cat("dantzig success with zoo\n")
}
