## 2024-06-05 - Modernize loop iterators with seq_len()
**Learning:** Legacy syntax `1:n` or `1:length(x)` in R can cause silent bugs when `n` or `length(x)` evaluates to 0, since `1:0` returns `c(1, 0)`. The codebase contains numerous `for` loops and `lapply`/`mclapply` sequences using this pattern (e.g., `1:s`, `1:d`, `1:g`, `1:bigN`).
**Action:** Replace all instances of `1:variable` loop iterators with the robust, modern `seq_len(variable)` to improve type safety and ensure proper handling of empty length inputs across the package.
