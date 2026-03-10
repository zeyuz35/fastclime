## 2024-05-24 - Method Dispatch Failures on isSymmetric for Time-Series Classes

**Learning:** Base `isSymmetric()` drops or throws errors for time-series class objects (`xts`, `zoo`) because there's no applicable method and S3 dispatch fails. Also, implicit coercion via `%*%` strips time-series attributes like `index` and specific classes (`xts`, `zoo`, `ts`) when they pass into matrix multiplication.

**Action:** Before checking for symmetry, explicitly coerce inputs to numeric matrices using `as.matrix()` and remove names (`unname()`) to prevent strict `dimnames` mismatches. In solver functions like `dantzig`, perform coercion on inputs while ensuring `drop = FALSE` on returned `BETA0` slices to prevent column vector collapse and dimension loss, maintaining numeric matrices that downstream tools expect.
