## 2024-03-24 - Preserving Symmetry Detection for Time-Series Objects

**Learning:** `isSymmetric()` returns FALSE for `zoo` and `xts` objects due to method dispatch failure and strict `dimnames` comparison, causing algorithms to misidentify symmetric time-series covariance matrices as raw data matrices.

**Action:** Explicitly coerce inputs using `as.matrix()` and strip names using `unname()` before calling `isSymmetric()` to ensure pure numerical symmetry evaluation without stripping original attributes from the return object.
