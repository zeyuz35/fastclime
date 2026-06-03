## 2024-03-23 - Avoid repeated allocation in loop
**Learning:** `dantzig.c` contains a main loop (PSM in the solver). Currently, it allocates memory (`output_vec`) inside the loop and frees it at the end of each iteration. Instead of repeated `CALLOC` and `FREE`, memory can be allocated once outside the loop and cleared using `memset` at the beginning of each iteration. This is faster and prevents potential fragmentation or repeated alloc/free overhead.
**Action:** When an array needs to be fresh/zeroed for each iteration of a core algorithm loop, allocate it outside the loop and use `memset` instead of `CALLOC`/`FREE` inside the loop.
## 2024-05-20 - Fast Element-wise Matrix Symmetrization
**Learning:** In R, replacing matrix elements via direct boolean index assignment (`mat[idx] <- other[idx]`) is significantly faster and more memory-efficient than creating boolean masks and multiplying them across the whole matrix (`mat * (mask) + other * (!mask)`). The latter calculates values for the entire dimensions repeatedly and allocates large intermediate matrices.
**Action:** When symmetrizing or combining matrices based on element-wise conditions, use logical indexing (e.g., `idx <- abs(icov) > abs(t_icov); icov[idx] <- t_icov[idx]`) instead of arithmetic mask multiplication.
## 2026-06-03 - Optimize t(X) %*% X to crossprod(X)
**Learning:** In R, the `t(X) %*% X` operation is inefficient due to the explicit allocation of the transposed matrix. Always replace it with `crossprod(X)` (and `X %*% t(Y)` with `tcrossprod(X, Y)`) for improved performance and reduced memory overhead.
**Action:** When seeing `t(X) %*% X` or similar, replace it with `crossprod(X)` to avoid explicitly allocating the transposed matrix.
