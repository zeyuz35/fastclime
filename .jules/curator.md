## 2026-06-04 - Fix `isSymmetric` logic for input coercion in fastclime()
**Learning:** `isSymmetric(x)` fails silently (returns `FALSE`) for time-series class matrices (e.g., `zoo`, `xts`) if they possess mismatched `dimnames` (such as differing rownames and colnames).
**Action:** When identifying matrix symmetry to determine if the input is a covariance matrix, check it using `isSymmetric(as.matrix(x), check.attributes = FALSE)`. This safely coerces the object to a standard matrix and ignores attribute mismatches without globally altering the object and destroying metadata.
