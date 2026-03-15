library(MASS)
library(Matrix)
library(igraph)
set.seed(123)
install.packages(".", repos=NULL, type="source")
library(fastclime)

L = fastclime.generator(n = 100, d = 20)
out1 = fastclime(L$data, 0.1)
cat("diag2:\n")
dput(diag(out1$icovlist[[2]]))

cat("diag3:\n")
dput(diag(out1$icovlist[[3]]))
