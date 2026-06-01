## 2026-06-01 - Preserve dimensional attributes during matrix subsetting
**Learning:** In R, subsetting a matrix with `[ , cols]` will silently drop the dimensional attributes if it results in a single column, changing the class to numeric vector. This breaks downstream functions that expect a matrix input.
**Action:** Always use `drop = FALSE` when subsetting matrix dimensions that must remain a matrix, such as `BETA0[, 1:validn, drop = FALSE]` in `dantzig()`.
