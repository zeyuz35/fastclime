## 2026-06-01 - Robust Iteration with seq_len
**Learning:** Legacy iteration and subsetting using the `1:n` pattern is fragile and can lead to silent errors or dimension loss when `n` evaluates to 0 (evaluating as `1 0`).
**Action:** Replace `1:length(x)` and `1:n` structures with `seq_along(x)` and `seq_len(n)` respectively for safe loop boundaries and robust vector subsetting.
