## 2026-06-17 - Safe matrix symmetry check
**Learning:** `isSymmetric()` lacks applicable methods for time-series objects like `zoo` and fails for matrices with mismatched `dimnames`.
**Action:** Calculate matrix symmetry using localized coercion with attribute ignoring (`isSymmetric(as.matrix(x), check.attributes = FALSE)`) instead of global variable reassignment, avoiding metadata loss.
