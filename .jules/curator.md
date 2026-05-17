## 2024-05-17 - Fix class issue with isSymmetric for xts/zoo objects

**Learning:** `isSymmetric()` in base R lacks an applicable method for time-series objects like `xts` and `zoo`. When these objects are passed into `fastclime()`, the `isSymmetric(x)` check fails with a POSIX time-index ambiguity error, preventing the package from running.

**Action:** Calculate symmetry using a localized coercion (i.e. `isSymmetric(as.matrix(x))`) rather than globally reassigning the variable. We don't want to reassign `x <- as.matrix(x)` globally because that would permanently strip S3 classes and time-series attributes from the object.
