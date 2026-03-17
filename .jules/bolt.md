## 2025-03-17 - Manual Garbage Collection Slowdown
**Learning:** Placing explicit `gc()` calls inside loops or functions severely degrades performance in R by pausing execution constantly (e.g. from 0.6s to 80s for loop tests).
**Action:** Rely on R's automatic memory management instead of calling `gc()` explicitly, and routinely remove them from math/loop-heavy functions.
