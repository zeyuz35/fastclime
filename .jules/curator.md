## 2026-05-09 - Safely Handle isSymmetric on Time Series

**Learning:** In R, base functions like `isSymmetric()` lack applicable methods for time-series objects like `zoo` or `xts`. Using `isSymmetric(x)` on such objects causes S3 dispatch crashes.

**Action:** Always coerce input safely using `as.matrix(x)` before running base mathematical validations like `isSymmetric()` while preserving the underlying object attributes.
