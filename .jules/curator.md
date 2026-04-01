## 2024-04-01 - Fix isSymmetric() method dispatch for zoo and xts objects

**Learning:** The `isSymmetric()` function relies heavily on checking both matrix symmetry and `dimnames` symmetry. Furthermore, it lacks applicable S3 methods for `zoo` and `xts` classes out-of-the-box, meaning that checking `isSymmetric(x)` on a time-series object (even if it's internally a symmetric covariance matrix) crashes with a method dispatch error or evaluates to `FALSE` incorrectly. This leads to silent corruption where algorithms might erroneously re-calculate `cov(x)` on already-covariance matrices.

**Action:** Before passing time-series objects or matrices with potentially asymmetric `dimnames` into `isSymmetric()` to verify mathematical symmetry, explicitly strip attributes by coercing the object: `isSymmetric(unname(as.matrix(unclass(x))))`. This ensures pure numerical symmetry is checked without losing the attributes in the final returned object.
