## 2026-05-21 - Preserve Dimension Names in C-Wrapper Rebuilds

**Learning:** When objects (like matrices) are rebuilt from C-wrapper lists or returns (e.g., via `.C()`), row and column names (metadata) are systematically dropped.
**Action:** Always capture `colnames()` and `rownames()` before the C call and explicitly repopulate them onto the output matrices/lists after returning from the C layer to prevent silent metadata loss.
