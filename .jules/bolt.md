## 2025-03-17 - Manual Garbage Collection Slowdown
**Learning:** Placing explicit `gc()` calls inside loops or functions severely degrades performance in R by pausing execution constantly (e.g. from 0.6s to 80s for loop tests).
**Action:** Rely on R's automatic memory management instead of calling `gc()` explicitly, and routinely remove them from math/loop-heavy functions.

## 2025-03-19 - Redundant Matrix Inversion Optimization
**Learning:** In mathematical R computations, doing `sigma = cov2cor(solve(omega))` followed by `omega = solve(sigma)` performs two O(N^3) matrix inversions redundantly.
**Action:** Instead of calling `solve()` twice, cache the initial inverse, derive the diagonal scaling factor `D_sqrt = sqrt(diag(tmp_inv))`, and scale the original precision matrix directly via fast vector-matrix multiplication `t(t(omega * D_sqrt) * D_sqrt)`.
