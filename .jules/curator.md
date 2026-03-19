## 2024-05-18 - `isSymmetric()` Dispatch Failure on Time-Series Objects

**Learning:** In base R, `isSymmetric()` lacks a method for `ts`, `xts`, or `zoo` objects and strict dimension name matching causes false negatives. If unchecked, it crashes the function or redundantly computes the covariance matrix for a numerically symmetric input.

**Action:** Always coerce time-series inputs to a numeric matrix using `as.matrix()` and strip names using `unname()` before calling `isSymmetric()`, while preserving the original object and `colnames()` for the final output.
