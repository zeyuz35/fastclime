## 2024-05-18 - isSymmetric breaks on time-series objects

**Learning:** `isSymmetric()` drops or errors on time-series objects like `zoo` and `xts` because they lack a specific method for it. Passing them directly can cause silent attribute loss or explicit errors during dispatch.

**Action:** Explicitly coerce such inputs to a numeric matrix using `as.matrix()` (and `unname()` to prevent strict `dimnames` mismatches during symmetry checks) before evaluating base function calls like `isSymmetric()`, while preserving the original object separately.
