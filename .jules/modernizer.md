## 2026-05-23 - `t(X) %*% X` optimization
**Learning:** Found instances of `t(X) %*% X` in `R/fastclime.BK17.R` and `R/fastclime.ZKL15.R`. In base R, replacing `t(X) %*% X` with `crossprod(X)` is a significant performance and memory optimization, especially for matrix multiplication.
**Action:** Replace `t(X) %*% X` with `crossprod(X)` and add a comment explaining it's a performance optimization.
