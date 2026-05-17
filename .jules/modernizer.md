## 2026-05-17 - Optimize covariance matrix calculation
**Learning:** Replaced `t(X) %*% X` with `crossprod(X)` in `fastclime.BK17()` and `fastclime.ZKL15()` since `crossprod(X)` is significantly faster and more memory-efficient when computing sample covariance from a data matrix `X`.
**Action:** Always prefer `crossprod` over `t(X) %*% X` or `t(X) %*% Y` in base R, while making sure to include a code comment clarifying that this is an optimization for performance.
