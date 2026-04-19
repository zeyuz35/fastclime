## 2024-03-23 - Avoid repeated allocation in loop
**Learning:** `dantzig.c` contains a main loop (PSM in the solver). Currently, it allocates memory (`output_vec`) inside the loop and frees it at the end of each iteration. Instead of repeated `CALLOC` and `FREE`, memory can be allocated once outside the loop and cleared using `memset` at the beginning of each iteration. This is faster and prevents potential fragmentation or repeated alloc/free overhead.
**Action:** When an array needs to be fresh/zeroed for each iteration of a core algorithm loop, allocate it outside the loop and use `memset` instead of `CALLOC`/`FREE` inside the loop.
## 2024-05-20 - Fast Element-wise Matrix Symmetrization
**Learning:** In R, replacing matrix elements via direct boolean index assignment (`mat[idx] <- other[idx]`) is significantly faster and more memory-efficient than creating boolean masks and multiplying them across the whole matrix (`mat * (mask) + other * (!mask)`). The latter calculates values for the entire dimensions repeatedly and allocates large intermediate matrices.
**Action:** When symmetrizing or combining matrices based on element-wise conditions, use logical indexing (e.g., `idx <- abs(icov) > abs(t_icov); icov[idx] <- t_icov[idx]`) instead of arithmetic mask multiplication.

## 2026-04-09 - Vectorized R Path Selector & Matrix Optimizations
**Learning:** In fastclime path selection, calculating length of `which()` inside a for-loop is slow for large lambda grids. Also, in covariance simulation, base `cov()` is slower than manually performing `crossprod(scale())`, and `eigen()` should always explicitly set `symmetric=TRUE, only.values=TRUE` when eigenvectors are not needed.
**Action:** Replace `for` loop `which()` with `colSums()` vectorization and `sapply` matrix extraction. Use `crossprod` for symmetric scaled covariance and explicitly set `only.values=TRUE` on symmetric spectral shifts to avoid redundant matrix operations.
