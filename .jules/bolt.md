## 2025-03-17 - Manual Garbage Collection Slowdown
**Learning:** Placing explicit `gc()` calls inside loops or functions severely degrades performance in R by pausing execution constantly (e.g. from 0.6s to 80s for loop tests).
**Action:** Rely on R's automatic memory management instead of calling `gc()` explicitly, and routinely remove them from math/loop-heavy functions.
## 2025-03-21 - Boolean indexing outperforming mathematical array replacement
**Learning:** In R, replacing matrix elements via direct boolean index assignment (`mat[idx] <- other[idx]`) is significantly faster and more memory-efficient than creating boolean masks and multiplying them across the whole matrix (`mat * (mask) + other * (!mask)`). The latter calculates values for the entire dimensions repeatedly and allocates huge intermediate matrices.
**Action:** Always prefer subset assignment over full matrix arithmetic masking for conditional element replacement in large matrices.
