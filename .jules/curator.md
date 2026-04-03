## 2024-04-03 - Fix isSymmetric failures on time-series objects
**Learning:** `isSymmetric()` on `xts`/`zoo` objects causes dispatch failures because there are no applicable methods, and it strictly compares `dimnames`.
**Action:** Explicitly coerce inputs to an unnamed matrix using `isSymmetric(unname(as.matrix(unclass(x))))` before checking symmetry, and use a stripped matrix `x_mat <- as.matrix(unclass(x))` for internal operations to preserve original attributes in output.
