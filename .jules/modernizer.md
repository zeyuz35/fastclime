
## 2026-06-12 - Replacing legacy `1:n` loops with `seq_len()`
**Learning:** Legacy `1:n` loops across the codebase (e.g., `1:s`, `1:bigN`, `1:g`, `1:d`, `1:validn`, `1:maxnlambda`) can cause unexpected behavior if `n` is `0`, leading to backward sequences like `1:0`.
**Action:** Replace `1:n` sequences with `seq_len(n)` for safer and more robust iterator generation, especially in `for` loops, `lapply()`, and `parallel::mclapply()` functions.
