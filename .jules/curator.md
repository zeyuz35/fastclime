## 2024-05-18 - Preserving time-series class/attributes in fastclime()

**Learning:** `fastclime()` passes input object directly to `isSymmetric()`, which internally drops or rejects time-series class objects (`zoo`, `xts`, `ts`), resulting in an error "no applicable method for 'isSymmetric' applied to an object of class 'zoo'". Coercing to a numeric matrix via `as.matrix(unclass(x))` resolves the error, but the original object structure including class and attributes is lost in the returned `result$data`.

**Action:** Capture the attributes of the input time-series object before conversion. Coerce input into numeric matrix via `as.matrix(unclass(x))` and `unname()` before passing to base functions like `isSymmetric()`. Restore the captured attributes to the final output to ensure data integrity and to allow users to maintain their time series index properly in the output.
