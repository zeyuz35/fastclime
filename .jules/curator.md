## 2024-03-20 - Time-series attribute loss during C integration and symmetric checks

**Learning:** When passing `xts` or `zoo` objects to C extensions via `.C`, the output arrays returned to R lose all `dimnames` and time-series attributes. Furthermore, standard validation methods like `isSymmetric()` throw errors on `xts`/`zoo` classes due to missing generic methods.

**Action:** Use `isSymmetric(unname(as.matrix(x)))` for robust input validation on time-series objects. Always explicitly extract `colnames` from the input object before `.C` calls and reattach them to the resulting output matrices.
