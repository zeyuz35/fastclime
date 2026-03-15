library(zoo)
library(xts)
source("R/fastclime.R")
source("R/dantzig.R")

cat("Testing fastclime with zoo object\n")
z <- zoo(matrix(rnorm(100), 20, 5), order.by = 1:20)
res <- try(fastclime(z))

cat("Testing fastclime with numeric object\n")
n <- matrix(rnorm(100), 20, 5)
res2 <- try(fastclime(n))
