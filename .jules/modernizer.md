## 2026-06-07 - Safe Iteration Modernization
**Learning:** Fragile `1:n` loop structures are common in legacy R code but fail unexpectedly if the limit evaluates to 0.
**Action:** Always replace them with `seq_len()` or `seq_along()` for safe and robust sequence generation.
