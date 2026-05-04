## 2024-04-08 - Fixed isSymmetric() method dispatch crash for xts/zoo objects

**Learning:** `isSymmetric()` lacks applicable methods for time-series objects (`xts`, `zoo`), leading to method dispatch crashes during covariance symmetry checks. It also strictly requires matching `dimnames`, causing false negatives for pure numerical symmetry.

**Action:** Explicitly coerce inputs to unnamed matrices using `isSymmetric(unname(as.matrix(unclass(x))))` before checking symmetry to prevent method dispatch failures and false negatives.
