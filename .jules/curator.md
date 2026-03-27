## 2024-03-27 - isSymmetric Method Dispatch on Time-Series Objects

**Learning:** `isSymmetric()` lacks applicable methods for time-series objects like `xts` and `zoo` (causing method dispatch crashes) and strictly compares `dimnames` for equality (causing false negatives for asymmetric dimnames). When evaluating pure numerical symmetry on input objects, these objects must be coerced to an unnamed matrix.

**Action:** Explicitly coerce inputs to an unnamed matrix using `isSymmetric(unname(as.matrix(unclass(x))))` when checking matrix symmetry, especially in entry-point functions taking arbitrary numerical objects.
