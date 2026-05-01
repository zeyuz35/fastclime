
## 2024-05-20 - isSymmetric crash on time-series objects

**Learning:** Base R functions like `isSymmetric()` lack applicable methods for time-series objects (`xts`, `zoo`), leading to fatal POSIX or S3 dispatch errors during input validation.

**Action:** When validating symmetry, calculating covariance, or coercing inputs, safely use `as.matrix(x)` rather than `unname(as.matrix(x))` or direct inputs to prevent dispatch crashes while preserving required `dimnames`.
