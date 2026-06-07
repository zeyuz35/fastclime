## 2024-06-25 - Safe Symmetry Checking for Base Objects

**Learning:** Base functions like `isSymmetric()` lack applicable methods for time-series objects like `zoo` or `xts` and will return `FALSE` for valid matrices if they possess mismatched `dimnames`. This causes logic branches that detect matrix types based on symmetry (e.g., differentiating between a data matrix and a covariance matrix) to fail silently and apply incorrect mathematical transformations.
**Action:** When checking matrix symmetry for logic control, perform the check using localized coercion with attribute ignoring (`isSymmetric(as.matrix(x), check.attributes = FALSE)`) rather than stripping S3 classes permanently via reassignment, preventing silent data corruption while handling complex time-series inputs.
