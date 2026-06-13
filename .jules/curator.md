## 2026-06-13 - [isSymmetric attributes fix]
**Learning:** In R, `isSymmetric()` returns FALSE for valid matrices if they possess mismatched `dimnames` (e.g., differing `rownames` and `colnames`), causing silent misclassification of covariance matrices as data matrices.
**Action:** When checking matrix symmetry, calculate it using localized coercion with attribute ignoring (`isSymmetric(as.matrix(x), check.attributes = FALSE)`) rather than globally reassigning the variable.
