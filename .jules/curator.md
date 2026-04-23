
## 2024-04-23 - `isSymmetric` S3 dispatch failure with time-series objects

**Learning:** `base::isSymmetric()` has no applicable method for `xts`/`zoo` classes, causing a silent crash during matrix structural checks, even when the underlying data is a valid matrix. Using `is.matrix()` validation allows time-series objects to pass, but the downstream S3 dispatch of `isSymmetric()` will fail on those same objects.

**Action:** When validating symmetry or performing core matrix checks on `x`, coerce using `as.matrix(x)` for the check (e.g., `isSymmetric(as.matrix(x))`) to bypass S3 dispatch errors, while preserving the original `x` object and its attributes (class, index, custom metadata) untouched for return payload integrity.
