## 2024-03-18 - Robust symmetry checks for time-series objects in fastclime

**Learning:** Base R's `isSymmetric()` drops or rejects time-series class objects like `ts`, `xts`, and `zoo`. When algorithms branch on numerical symmetry, these errors prevent execution or misclassify matrices.

**Action:** Explicitly coerce inputs to numeric matrices using `as.matrix()` and then wrap in `unname()` before base function calls like `isSymmetric()`, preserving numerical execution paths without losing the object's original attributes, class, or dimnames, which should be returned as part of the output.
