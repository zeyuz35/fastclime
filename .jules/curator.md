## 2024-06-14 - Fix silent symmetry checking failure for S3 objects and dimnames

**Learning:** Base `isSymmetric()` fails natively on time-series objects like `zoo` due to missing applicable methods, and returns FALSE for valid matrices with mismatched row/colnames. Globally reassigning to `as.matrix()` strips attributes permanently.
**Action:** Use localized coercion with attribute checking disabled `isSymmetric(as.matrix(x), check.attributes = FALSE)` when the variable is evaluated for flow-control, to preserve the object metadata downstream.
