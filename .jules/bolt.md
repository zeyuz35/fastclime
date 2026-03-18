## 2025-03-17 - Manual Garbage Collection Slowdown
**Learning:** Placing explicit `gc()` calls inside loops or functions severely degrades performance in R by pausing execution constantly (e.g. from 0.6s to 80s for loop tests).
**Action:** Rely on R's automatic memory management instead of calling `gc()` explicitly, and routinely remove them from math/loop-heavy functions.

## 2025-03-18 - Avoid Redundant Matrix Inversions
**Learning:** In computing precision/covariance matrices, `solve()` is an O(N^3) operation. Doing `omega = solve(cov2cor(solve(omega)))` needlessly computes the inverse twice. By mathematical properties, `sigma = D^{-1/2} sigma_full D^{-1/2}` means its inverse is simply `D^{1/2} omega D^{1/2}`, achievable via fast vector-matrix scaling without inversion.
**Action:** Always look for analytical ways to apply scaling properties instead of calling `solve()` iteratively when computing standardized precision matrices.
