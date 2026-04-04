## 2024-04-04 - Fix implicit coercion and isSymmetric method failures for time-series objects

**Learning:** `isSymmetric()` lacks applicable methods for time-series objects like `xts` and `zoo` and strictly compares `dimnames` for equality. Passing these objects natively causes crashes. Implicit coercions can silently drop classes.

**Action:** Explicitly convert inputs to a pure numeric matrix using `as.matrix(unclass(x))` before running validation checks and `isSymmetric(unname(...))` to avoid strict equality and missing dispatch errors, while returning the unmodified data object to maintain integrity.
