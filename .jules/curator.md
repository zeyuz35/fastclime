
## 2024-05-08 - Base function dispatch failures with time-series objects

**Learning:** Base R functions like `isSymmetric()` lack applicable methods for time-series objects like `xts` and `zoo`, causing fatal S3 dispatch crashes.

**Action:** When performing symmetry checks or computing covariance on input matrices, safely coerce them first using `as.matrix(x)` to prevent crashes while preserving `dimnames`.
