## 2026-06-16 - Replacing 1:n Loops with seq_len(n)
**Learning:** Hardcoded `1:n` ranges are unsafe when `n=0`. If wrapped in `c()`, it adds a redundant vector coercion step. In matrix subscripting, using `1:n` safely often necessitates `drop = FALSE` to preserve matrix bounds for a single element.
**Action:** Consistently replace `1:n` iterators and indices with `seq_len(n)`. Remove unnecessary `c()` wrappers around it, and remember to include `drop = FALSE` when accessing matrices with these iterators.
