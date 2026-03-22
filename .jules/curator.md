## 2024-03-22 - Preserving column names and handling time-series objects in `fastclime()`

**Learning:** Base R functions like `isSymmetric()` and implicit coercion via matrix operations `%*%` drop or reject time-series class objects (`zoo`, `xts`). In solver inputs like `fastclime()`, passing a `zoo` or `xts` directly to `isSymmetric()` triggers a generic method dispatch error ("no applicable method for 'isSymmetric' applied to an object of class"). Additionally, `colnames` metadata might be lost when passed to C-level solver logic and returned as unlabelled vectors.

**Action:** Explicitly coerce inputs to unnamed numeric matrices (`unname(as.matrix(x))`) for symmetry checks and calculations to prevent silent failures. Cache attributes like `colnames()` before processing and manually reattach them to output components (`sigmahat`, `lambdamtx`, `icovlist`) while preserving the original unmodified time-series object (`x`) to retain input indices and scaling classes.
