## 2024-05-28 - Base R Optimization over %*%

**Learning:** `t(X) %*% X` and `t(X) %*% y` can be optimized by using the base R equivalent `crossprod(X)` and `crossprod(X, y)` which is significantly faster for large matrices.

**Action:** Always replace `t(X) %*% X` with `crossprod(X)` and `t(X) %*% y` with `crossprod(X, y)` and add an explanatory comment to document the equivalent implementation for clarity.
