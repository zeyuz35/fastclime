## 2026-06-22 - Replace 1:n patterns with seq_len(n)
**Learning:** Legacy `1:n` patterns are fragile, especially when `n` evaluates to 0 (creating a reverse sequence `1:0`).
**Action:** Always prefer `seq_len(n)` for safety. Additionally, when substituting sequences inside subsetting (e.g., `matrix[, seq_len(n)]`), add `drop = FALSE` to prevent unexpected vector coercion when `n=1`.
