## 2024-05-15 - Redundant matrix inversions mathematically optimized
**Learning:** Replaced O(N^3) redundant matrix inversion solve(cov2cor(solve(omega))) with an efficient mathematical equivalent scaling the unscaled precision matrix omega using D_sqrt.
**Action:** Use vector-matrix scaling when reconstructing a precision matrix from a correlation matrix derivation to preserve O(N^2) time complexity.
