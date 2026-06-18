
## 2026-06-18 - Safe sequence generation and subsetting
**Learning:** Using `1:n` creates unsafe sequences when `n` could be 0, leading to unexpected ranges (e.g., `1:0`). Also, matrix column subsetting `M[, seq_len(n)]` drops matrix dimension implicitly if `n=1`.
**Action:** Always prefer `seq_len(n)` or `seq(a, b)` over `1:n` for robust iterations. When subsetting matrix columns programmatically with sequences, append `drop = FALSE` (e.g., `M[, seq_len(n), drop = FALSE]`) to guarantee consistent dimensions.
