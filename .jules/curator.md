## 2026-06-19 - Safe Matrix Symmetry Checking for Time-Series Objects

**Learning:** Base R functions like `isSymmetric()` lack methods for time-series objects like `zoo` and fail on valid matrices with mismatched `dimnames`.

**Action:** Calculate matrix symmetry using localized coercion with attribute ignoring (`isSymmetric(as.matrix(x), check.attributes = FALSE)`) instead of global variable reassignment, which strips S3 classes and metadata permanently.
