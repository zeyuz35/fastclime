
## 2024-05-24 - Optimize covariance matrix calculation
**Learning:** In base R, the operation `t(X) %*% X` performs redundant matrix transposition and allocation before multiplication, making it less memory and CPU efficient.
**Action:** Replace `t(X) %*% X` with `crossprod(X)` where possible. This optimized C-level function skips the explicit transpose operation, which saves memory allocation and yields speed improvements, particularly for large input matrices.
