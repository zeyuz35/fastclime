## 2026-04-11 - isSymmetric() Failures on Time-Series Classes

**Learning:** `isSymmetric()` strictly tests `dimnames` equality which creates false negatives for time-series covariance objects where rownames exist but colnames don't. More critically, it lacks applicable methods for classes like `xts` and `zoo`, causing a direct method dispatch failure (crash) if called on these objects.

**Action:** When testing matrix symmetry strictly for pure numeric values (ignoring metadata and classes), use `isSymmetric(unname(as.matrix(unclass(x))))`. This explicitly strips attributes, drops dimension names, and converts safely to a numeric matrix before evaluating symmetry.
