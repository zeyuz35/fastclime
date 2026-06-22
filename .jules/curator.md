## 2026-06-22 - Safe Symmetry Checking for Time-Series Objects

**Learning:** Base `isSymmetric()` lacks applicable methods for time-series objects like `zoo` and returns `FALSE` for valid matrices with mismatched `dimnames`. Globally coercing `x <- as.matrix(x)` strips S3 classes and time-series metadata permanently.

**Action:** When checking matrix symmetry for logic control (e.g., identifying covariance matrices), use localized coercion with attribute ignoring: `isSymmetric(as.matrix(x), check.attributes = FALSE)`. This preserves data integrity and metadata.
