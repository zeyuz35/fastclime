## 2024-05-20 - isSymmetric() fails on time-series objects

**Learning:** `isSymmetric()` drops or rejects time-series class objects like `zoo` and `xts` because there's no method for them. It also performs strict dimname comparison (returning `FALSE` for symmetric numerical matrices with asymmetric dimnames).

**Action:** Before applying `isSymmetric()`, explicitly coerce to a numeric matrix using `as.matrix()` and `unname()` to check for pure numerical symmetry, which prevents method dispatch errors and redundant covariance recalculation. Also, remember to preserve and restore the original attributes and class of the input data so that they are not stripped during computations.
