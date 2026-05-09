## 2024-05-09 - Optimize t(X) %*% X with crossprod(X)
**Learning:** The expression `t(X) %*% X` is inefficient as it transposes the matrix and then performs matrix multiplication.
**Action:** Replace `t(X) %*% X` with `crossprod(X)` for better performance and readability.
