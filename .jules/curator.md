## 2024-04-10 - isSymmetric method dispatch failure on time-series objects

**Learning:** `isSymmetric()` lacks applicable methods for time-series objects like `xts` and `zoo`, causing method dispatch crashes. It also strictly compares `dimnames` for equality.

**Action:** To prevent these failures when evaluating pure numerical symmetry, explicitly coerce inputs to an unnamed matrix using `isSymmetric(unname(as.matrix(unclass(x))))`.
