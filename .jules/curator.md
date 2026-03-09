## 2024-05-24 - `isSymmetric` Attribute Strictness with Time-Series

**Learning:** Base R's `isSymmetric()` strictly tests objects and will return `FALSE` or error out (e.g., `no applicable method` for `zoo`) when handed symmetric covariance matrices wrapped in time-series structures (`ts`, `zoo`, `mts`) because it does not ignore structural attributes or strictly matching `dimnames` via internal `all.equal` calls. This causes functions attempting to conditionally extract the covariance to erroneously recompute `cov()`, destroying the input object's data integrity.

**Action:** Whenever mathematically verifying the symmetry of a time-series payload, strictly decouple the numeric matrix via `unname(as.matrix(x))` before passing it to `isSymmetric()`. To preserve the original attributes, assign the extracted matrix to a distinct processing variable (`SigmaInput <- as.matrix(x)`) and leave the original `x` pristine to be returned in the result package.
