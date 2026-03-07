## 2025-03-07 - Optimize matrix multiplication with crossprod

**Learning:** Replaced `t(X) %*% X` with `crossprod(X)` and `t(X) %*% y` with `crossprod(X, y)` in `R/dantzig.R`. This is a significantly faster base equivalent to standard matrix multiplication involving transposes.

**Action:** Always look for `t(X) %*% X` and `t(X) %*% y` and replace them with `crossprod` for performance, but make sure to add an explanatory comment to clarify what the code does, keeping it readable.
