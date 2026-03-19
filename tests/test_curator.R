library(xts)
library(zoo)

# Load package fastclime
library(fastclime)

set.seed(123)
mat <- matrix(rnorm(100), 10, 10)
colnames(mat) <- paste0('V', 1:10)

# Test 1: Symmetric xts input
mat_sym <- crossprod(mat)
colnames(mat_sym) <- paste0('V', 1:10)
rownames(mat_sym) <- paste0('V', 1:10)
xts_sym <- xts(mat_sym, order.by = as.Date('2020-01-01') + 1:10)

res_sym <- fastclime(xts_sym)
stopifnot(res_sym$cov.input == 1)
stopifnot(identical(class(res_sym$data), class(xts_sym)))
stopifnot(identical(colnames(res_sym$sigmahat), colnames(xts_sym)))

# Test 2: Asymmetric xts input
xts_asym <- xts(mat, order.by = as.Date('2020-01-01') + 1:10)
res_asym <- fastclime(xts_asym)
stopifnot(res_asym$cov.input == 0)
stopifnot(identical(class(res_asym$data), class(xts_asym)))
stopifnot(identical(colnames(res_asym$sigmahat), colnames(xts_asym)))

message("All curator tests passed!")
