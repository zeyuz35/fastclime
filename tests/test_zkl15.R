library(fastclime)

bigT <- 100
bigN <- 5
set.seed(123)
X <- matrix(rnorm(bigT * bigN), bigT, bigN)
Sigma <- cov(X)

lambda_1 <- rep(10, bigN)
lambda_2 <- rep(10, bigN)
lambda_3 <- rep(10, bigN)

res <- fastclime.ZKL15(X, Sigma, lambda_1, lambda_2, lambda_3)
print(res$Omega)

res2 <- fastclime.ZKL15(X, Sigma)
print(res2$Omega)
