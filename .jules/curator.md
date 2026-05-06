## 2024-05-06 - fastclime time-series isSymmetric class integrity

**Learning:** Base R `isSymmetric()` has no applicable method for time-series objects like `ts`, `xts`, or `zoo`. Evaluating it directly crashes, preventing time-series classes from being properly passed downstream despite matrix-backing.

**Action:** Before checking symmetry or building constraint matrices on potential time-series data inputs, always safely coerce them first using `as.matrix(x)` to safely evaluate `isSymmetric()` and compute `cov()` without stripping metadata from the unmodified, original object returned to the user.
