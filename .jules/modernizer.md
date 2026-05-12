## 2026-05-12 - crossprod Optimization

**Learning:** When generating a symmetric matrix multiplication (i.e. `t(X) %*% X`) in base R where `X` is used purely to estimate a covariance `Sigma`, using `crossprod(X)` avoids memory reallocation for the transposed matrix, resulting in significantly faster and memory-efficient computations.

**Action:** Look for instances of `t(X) %*% X` or `t(X) %*% Y` and replace them with their more performant counterparts, `crossprod(X)` or `crossprod(X, Y)`. Add explicit code comments to clarify that it's an optimization for performance vs readability.
