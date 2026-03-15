## 2024-05-24 - `isSymmetric` method dispatch failure and `.C` dimension dropping

**Learning:** Base `isSymmetric()` drops or throws errors when called directly on time-series objects (`zoo`, `xts`) because they lack a defined method. In addition, passing objects natively through `.C` interfaces explicitly strips attributes like `colnames()`.

**Action:** Before performing base operations like `isSymmetric()` or `.C()` matrix processing, explicitly coerce inputs using `as.matrix()` (and `unname()` for `isSymmetric` to bypass dimnames mismatch issues). Then, explicitly cache metadata like `colnames()` and re-attach them to the output object to preserve data integrity and prevent downstream errors in functions that expect these attributes.
