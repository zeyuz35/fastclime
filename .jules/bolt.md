## 2024-05-24 - Faster Matrix Cross Products
**Learning:** In R mathematical/optimization code, `crossprod(X)` and `crossprod(X, y)` are significantly faster base equivalents to `t(X) %*% X` and `t(X) %*% y`.
**Action:** When finding matrix multiplications involving a transposed matrix, use `crossprod` directly instead of doing `t()` then `%*%`. This is computationally and memory efficient because it avoids materializing the transposed matrix.
