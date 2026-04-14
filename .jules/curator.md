## 2024-04-14 - Time-Series Class Preservation in Symmetry Checks and Matrix Coercion
**Learning:** Base R functions like `isSymmetric()` lack methods for `xts`/`zoo` objects, and implicit matrix coercions (like computing `cov(x)`) strip class attributes and `colnames()`, breaking downstream expectations.
**Action:** Explicitly coerce inputs using `x_mat <- unname(as.matrix(unclass(x)))` before `isSymmetric(x_mat)`, and explicitly capture and restore attributes (like `class` and `dimnames`) when returning the processed matrices to preserve original time indices and classes.
