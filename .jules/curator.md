## 2024-05-24 - Preserving time-series compatibility and matrix dimnames in C extensions

**Learning:** Base R's `isSymmetric()` drops or throws errors on time-series objects like `zoo` and `xts` due to method dispatch failures, and strictly requires identical `dimnames`. Flat array structures returned from `.C()` entirely strip `dimnames` and time-series classes, breaking downstream integrity.

**Action:** Explicitly extract the numeric data via `unname(as.matrix())` prior to `isSymmetric()` to ensure mathematical evaluation without false negatives or dispatch errors. Always cache the original attributes (like `colnames`) before the `.C()` call and explicitly re-attach them to the newly instantiated matrices returned to R.
