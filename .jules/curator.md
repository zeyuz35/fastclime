## 2024-05-29 - Fix type-instability and metadata loss during fastclime type handling
**Learning:** `isSymmetric()` on S3 class objects like `xts` throws a "no applicable method" error in base R. Using `as.matrix(x)` with `isSymmetric()` solves it but silently removes class types and attributes from `x` if `x` is overwritten with the coerced matrix.
**Action:** Use `isSymmetric(as.matrix(x), check.attributes = FALSE)` instead of directly testing `x`, to allow matrix checks without permanently changing `x`'s type and without losing time-series object structures in subsequent operations.
