library(fastclime)
set.seed(123)
L <- fastclime.generator(n = 100, d = 20)
out1 <- fastclime(L$data, 0.1)

# expected_diag2
cat("expected_diag2 <- c(\n  ")
cat(paste(round(diag(out1$icovlist[[2]]), 5), collapse = ", "), "\n)\n")

# expected_diag3
cat("expected_diag3 <- c(\n  ")
cat(paste(round(diag(out1$icovlist[[3]]), 4), collapse = ", "), "\n)\n")
