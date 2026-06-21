## 2026-06-21 - Replace 1:n loop patterns with seq_len(n)
**Learning:** Legacy `1:n` iteration patterns can cause sequence bounds errors if `n` becomes 0. Furthermore, wrapping it in `c()` is redundant.
**Action:** Replace `1:n` with `seq_len(n)` for safety. Remove redundant `c()` wrappers around sequence generation. Add `drop = FALSE` in matrix subsetting to prevent unwanted vector coercion when returning 1 row/column.
