## 2024-04-07 - isSymmetric Method Dispatch Failure on Time-Series Objects

**Learning:** `isSymmetric()` lacks applicable methods for time-series objects like `zoo` and `xts`, causing method dispatch crashes. It also performs strict `dimnames` equality checks that can yield false negatives on `ts` objects when evaluating pure numerical symmetry.

**Action:** To prevent these failures, explicitly coerce inputs to an unnamed matrix using `unname(as.matrix(unclass(x)))` before evaluating numerical symmetry.
