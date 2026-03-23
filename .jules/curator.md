## 2024-05-24 - Strict method dispatch of isSymmetric

**Learning:** `isSymmetric()` strictly rejects `xts`/`zoo` objects in R, resulting in method dispatch failures. Furthermore, matrix calculations and `.C()` calls can silently drop custom attributes or column names.

**Action:** Explicitly extract the numeric matrix using `as.matrix(unname(x))` for symmetry checks and inner calculations to prevent failures. Cache `colnames()` prior to processing, re-attach them to the newly constructed matrices returned by `.C()`, and guarantee the original intact `x` object is returned in `result$data`.
