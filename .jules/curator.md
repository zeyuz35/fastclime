## 2026-06-21 - Fix isSymmetric metadata loss

**Learning:** In R, base functions like `isSymmetric()` lack applicable methods for time-series objects or matrices with mismatched `dimnames` and return FALSE for valid matrices.

**Action:** Calculate it using localized coercion with attribute ignoring (e.g., `isSymmetric(as.matrix(x), check.attributes = FALSE)`) rather than global reassignment.
