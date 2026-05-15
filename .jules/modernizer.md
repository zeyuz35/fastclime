## 2024-05-18 - Optimize matrix multiplication
**Learning:** In base R, `t(X) %*% X` explicitly computes the transpose in memory and multiplies it. The native `crossprod(X)` performs the equivalent mathematical operation but is optimized in C and avoids the extra memory overhead and computation.
**Action:** Always replace `t(X) %*% X` or `t(X) %*% Y` with `crossprod(X)` or `crossprod(X, Y)` for optimized performance and memory usage, and add a comment explaining why.
