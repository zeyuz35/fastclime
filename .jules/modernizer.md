## 2026-06-19 - Update 1:n iterator pattern to seq_len in matrix subsetting
**Learning:** Using 1:n sequences for matrix subsetting can unexpectedly drop dimensions or crash if n=1. Replacing with seq_len(n) and explicitly specifying drop=FALSE preserves the matrix structure.
**Action:** When updating 1:n sequences in matrices, always add drop=FALSE.
