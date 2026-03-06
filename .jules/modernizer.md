## 2024-03-06 - Replace t(X) %*% X with crossprod(X)

**Learning:** `crossprod(X)` and `crossprod(X, y)` are significantly faster base R equivalents to `t(X) %*% X` and `t(X) %*% y`, and should be preferred in mathematical/optimization code for performance, especially when dealing with large matrices.
**Action:** Replace explicit transpose-and-multiply operations with `crossprod` / `tcrossprod` across the codebase, ensuring equivalent base implementation is commented for clarity.
