## 2024-05-20 - Crossprod over explicit matrix multiplication
**Learning:** `crossprod(X)` and `crossprod(X, y)` are significantly faster base equivalents to `t(X) %*% X` and `t(X) %*% y`. This is an algorithmic performance improvement without adding dependencies.
**Action:** Use `crossprod` and always leave an explanatory comment to maintain clarity on what mathematical operation is being performed.
