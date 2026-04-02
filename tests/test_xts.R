library(fastclime)
library(xts)

x <- matrix(c(1, 0.5, 0.5, 1), 2, 2)
colnames(x) <- c("a", "b")
x_xts <- xts(x, order.by=as.Date("2023-01-01") + 1:2)

out <- fastclime(x_xts)
stopifnot(inherits(out$data, "xts"))
stopifnot(identical(colnames(out$lambdamtx), c("a", "b")))
stopifnot(identical(colnames(out$icovlist[[1]]), c("a", "b")))
