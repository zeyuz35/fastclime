## 2024-05-24 - fastclime strips attributes and fails on xts objects

**Learning:** Base `isSymmetric()` and `cov()` functions silently drop or reject time-series class objects (`ts`, `xts`, `zoo`) and strictly compare dimnames for equality. This causes method dispatch failures (`no applicable method for 'isSymmetric' applied to an object of class c('xts', 'zoo')`) and silent attribute loss when calculating the empirical covariance matrix.

**Action:** Explicitly extract the numeric data matrix and cache `colnames()` using `x_mat <- as.matrix(unclass(x))`, perform operations on `x_mat`, and bypass strict symmetry checks using `isSymmetric(unname(x_mat))`. Then, restore the `colnames()` to both the resulting empirical covariance matrix (`sigmahat`) and all precision matrices (`icovlist`), while returning the original, unmodified `x` object (preserving its class and all attributes) to ensure robust downstream behavior and data integrity.
