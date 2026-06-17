## 2026-06-17 - Update legacy 1:n sequences to seq_len(n)
**Learning:** Legacy `1:n` sequence generation syntax is widespread in the codebase, particularly in matrix indexing and loops.
**Action:** Replaced `1:n` patterns with `seq_len(n)` to improve robustness and readability, and added `drop = FALSE` in matrix subsetting to prevent unintended coercion to vectors.
