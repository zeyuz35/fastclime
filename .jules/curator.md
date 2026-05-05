## 2024-05-05 - Fix isSymmetric dispatch for time-series inputs

**Learning:** Base `isSymmetric()` lacks applicable methods for time-series objects like `xts` and `zoo`. Passing these directly causes fatal dispatch errors. When detecting covariance matrices, `as.matrix()` must be used to safely coerce the input before symmetry checks and covariance computations to prevent crashes while preserving the original input class for downstream returns.

**Action:** Wrap time-series inputs in `as.matrix()` before passing to base functions like `isSymmetric()` or `cov()` to ensure safe handling without stripping the original object's class.
