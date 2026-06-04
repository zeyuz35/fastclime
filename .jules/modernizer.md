## 2026-06-04 - Robust Iterators using seq_len
**Learning:** Using `1:n` in R for loops can lead to unexpected behaviors or errors when `n` evaluates to 0, producing a `1 0` sequence instead of an empty iterator.
**Action:** Always prefer `seq_len(n)` or `seq_along(x)` over `1:n` to ensure iteration strictly skips loop bodies on zero-length boundary conditions, avoiding off-by-one or unexpected length evaluation issues.
