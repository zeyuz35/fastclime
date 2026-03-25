## 2025-03-17 - Manual Garbage Collection Slowdown
**Learning:** Placing explicit `gc()` calls inside loops or functions severely degrades performance in R by pausing execution constantly (e.g. from 0.6s to 80s for loop tests).
**Action:** Rely on R's automatic memory management instead of calling `gc()` explicitly, and routinely remove them from math/loop-heavy functions.

## 2025-03-17 - Avoid redundant solve() matrix inversions
**Learning:** In mathematical computations, executing multiple `solve()` operations can cause significant bottlenecks (e.g., 5.7s to 5.0s on 1000x1000 arrays). Computing `solve(cov2cor(solve(omega)))` can be simplified algorithmically since `cov2cor(S)` implies `D^(-1/2) S D^(-1/2)`. Thus its inverse is `D^(1/2) S^(-1) D^(1/2) = t(t(omega * D_sqrt) * D_sqrt)`.
**Action:** Avoid redundant `solve()` inversions. Instead of performing a matrix inversion twice, leverage algebraic simplifications to calculate vector-matrix multiplication.
