## 2026-05-31 - seq_len() in loop iterators
**Learning:** Using `1:n` or `1:length(x)` in R loops can cause unexpected behavior when `n` is 0 (as `1:0` evaluates to `c(1, 0)`).
**Action:** Always replace `1:n` loop structures with the more robust `seq_len(n)` or `seq_along(x)` iterator pattern.
