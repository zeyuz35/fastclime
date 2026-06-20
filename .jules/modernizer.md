## 2026-06-20 - Update `1:n` sequences to `seq_len(n)` and `seq()`
**Learning:** Legacy `1:n` iterators in R can result in descending sequences (e.g., `1:0`) when `n` is `0`, leading to unexpected loop executions or subsetting errors. In matrix subsetting, dropping a dimension can happen if `drop = FALSE` isn't used.
**Action:** Always replace `1:n` loops/subsets with `seq_len(n)` which safely handles zero-length inputs, and `a:b` with `seq(a, b)`. Include `drop = FALSE` in matrix subsets as needed.
