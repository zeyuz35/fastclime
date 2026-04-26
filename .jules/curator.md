## 2024-05-18 - `isSymmetric()` crashing on time-series matrices

**Learning:** `isSymmetric()` from base R does not have applicable methods for time-series objects like `xts` or `zoo`. Calling `isSymmetric(x)` directly on these objects crashes with S3 dispatch errors, even though they represent matrices.

**Action:** Capture attributes, coerce to numeric matrix `unname(as.matrix(x))` before checking symmetry and running matrix operations, then restore attributes on output data.
