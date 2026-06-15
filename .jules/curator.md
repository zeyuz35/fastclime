## 2026-06-15 - [isSymmetric localization for extended classes]

**Learning:** Base R's `isSymmetric()` function lacks applicable methods for time-series objects like `zoo` and returns FALSE for valid symmetric matrices with mismatched `dimnames`. This can cause silent data corruption if `isSymmetric()` is used to identify matrices to be transformed (e.g. `cov()`).

**Action:** When checking matrix symmetry for logic control, use localized coercion with attribute ignoring (`isSymmetric(as.matrix(x), check.attributes = FALSE)`) to safely process extended classes and dimnames without modifying the original object.
