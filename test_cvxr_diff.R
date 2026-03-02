diff <- max(abs(Omega_fastclime[, -c(4, 9)] - Omega_cvxr[, -c(4, 9)]))
cat("Max absolute difference:", diff, "\n")
