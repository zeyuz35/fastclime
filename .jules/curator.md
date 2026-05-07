## 2024-05-08 - Safely Coercing Time-Series Before `isSymmetric()` Checks

**Learning:** S3 methods like `isSymmetric()` lack applicable methods for multivariate time-series objects (e.g., `xts` and `zoo`). When base matrices wrapped as time-series objects are passed into functions that validate symmetric input via `isSymmetric()`, the check crashes with an S3 dispatch error.

**Action:** Before checking symmetry or performing base operations that fail on `ts`/`xts`/`zoo`, explicitly coerce the input using `as.matrix(x)`. Do NOT use `unname(as.matrix(x))` because `unname()` is highly destructive and strips metadata like `colnames`/`rownames`, which causes silent regressions in downstream metadata propagation (like covariance `colnames`). `as.matrix(x)` safely prevents S3 dispatch crashes while preserving `dimnames`.
