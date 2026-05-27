## 2026-05-27 - Replace legacy 1:n loop iterators with seq_len
**Learning:** Fragile loop structures like `1:n` or `1:length(x)` can cause unexpected behavior when the length or number is 0. Replacing them with the more robust `seq_len(n)` or `seq_along(x)` is a highly recommended syntax modernization in R.
**Action:** Hunt for legacy `1:n` or `1:length(x)` loop structures and replace them with `seq_len` or `seq_along` in future modernization efforts.
