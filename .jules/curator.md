## 2026-05-24 - Fix isSymmetric time-series metadata loss

**Learning:** In R, base functions like `isSymmetric()` lack applicable methods for time-series objects like `zoo` or `xts`. Reassigning `x <- as.matrix(x)` globally to fix this permanently strips S3 classes and time-series attributes.

**Action:** Calculate symmetry using a localized coercion (e.g., `isSymmetric(as.matrix(x), check.attributes = FALSE)`) instead of global reassignment to prevent silent metadata loss.
