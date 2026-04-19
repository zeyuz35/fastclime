## 2025-04-19 - Optimization of Sample Covariance Matrix Calculation

**Learning:** Replacing `(t(X) %*% X) / bigT` with `crossprod(X) / bigT` in matrix multiplication contexts (like covariance calculation) provides a minor but measurable performance optimization in R because `crossprod` avoids the memory overhead of explicitly computing the transpose of `X`.

**Action:** Look for `t(A) %*% B` or `t(X) %*% X` patterns and replace them with `crossprod(A, B)` or `crossprod(X)` where applicable, adding explanatory comments to maintain readability.
