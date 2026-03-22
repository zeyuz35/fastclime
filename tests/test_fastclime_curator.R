library(zoo)
library(xts)
library(fastclime)

x <- zoo(matrix(c(1, 0.5, 0.5, 1), 2, 2))
colnames(x) <- c("A", "B")

out <- fastclime(x)

stopifnot(inherits(out$data, "zoo"))
stopifnot(identical(colnames(out$sigmahat), c("A", "B")))
stopifnot(identical(colnames(out$lambdamtx), c("A", "B")))
stopifnot(identical(colnames(out$icovlist[[1]]), c("A", "B")))

x2 <- xts(matrix(c(1, 0.5, 0.5, 1), 2, 2), as.Date('2020-01-01') + 0:1)
colnames(x2) <- c("A", "B")

out2 <- fastclime(x2)

stopifnot(inherits(out2$data, "xts"))
stopifnot(identical(colnames(out2$sigmahat), c("A", "B")))
stopifnot(identical(colnames(out2$lambdamtx), c("A", "B")))
stopifnot(identical(colnames(out2$icovlist[[1]]), c("A", "B")))

x3 <- matrix(c(1, 0.5, 0.5, 1), 2, 2)
colnames(x3) <- c("A", "B")

out3 <- fastclime(x3)

stopifnot(inherits(out3$data, "matrix"))
stopifnot(identical(colnames(out3$sigmahat), c("A", "B")))
stopifnot(identical(colnames(out3$lambdamtx), c("A", "B")))
stopifnot(identical(colnames(out3$icovlist[[1]]), c("A", "B")))

print("Curator tests passed!")
