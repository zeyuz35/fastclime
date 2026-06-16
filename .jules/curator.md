## 2026-06-16 - Safe symmetry checks for time-series objects
**Learning:** In R, base functions like `isSymmetric()` lack applicable methods for time-series objects like `zoo`. When checking matrix symmetry for logic control, directly calling `isSymmetric()` on a `zoo` object causes a failure.
**Action:** Calculate it using localized coercion with attribute ignoring (e.g., `isSymmetric(as.matrix(x), check.attributes = FALSE)`) rather than globally reassigning the variable or failing out.
