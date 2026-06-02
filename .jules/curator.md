## 2026-06-02 - Matrix subsetting dimensions preservation

**Learning:** In R, subsetting a matrix (e.g., `mat[, cols]`) automatically coerces the result into a vector if it reduces to a single column, silently stripping metadata like names and breaking downstream code that relies on the object being a matrix.
**Action:** Always explicitly use `drop = FALSE` (e.g., `mat[, cols, drop = FALSE]`) when subsetting a matrix to preserve matrix structure and metadata unless a vector is explicitly desired.
