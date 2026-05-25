## 2026-05-25 - Matrix Dimension Loss on Subset

**Learning:** In R, subsetting a matrix with a single column (e.g., `mat[, 1:1]`) automatically coerces it to a vector, silently dropping dimensional attributes.

**Action:** Always use `drop = FALSE` (e.g., `mat[, cols, drop = FALSE]`) to preserve matrix structure and metadata during subset operations.
