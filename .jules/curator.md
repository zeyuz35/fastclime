## 2025-04-02 - xts isSymmetric Dispatch Failure

**Learning:** `isSymmetric()` has no applicable method for `xts`/`zoo` objects in base R, leading to a dispatch failure ("no applicable method for 'isSymmetric' applied to an object of class c('xts', 'zoo')"). Furthermore, even when coerced to a matrix, strict `dimnames` comparison within `isSymmetric.matrix` can cause false negatives for symmetric matrices with different row and column names.

**Action:** Explicitly coerce time-series objects to matrices and strip names using `isSymmetric(unname(as.matrix(unclass(x))))` before checking for numerical symmetry to prevent method dispatch crashes and false negatives.
