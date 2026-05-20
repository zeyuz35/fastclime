## 2024-05-08 - Preserve Matrix Attributes Rebuilt from C
**Learning:** In R, when objects (like matrices or arrays) are rebuilt from C-wrapper lists/returns (e.g., via `.C()`), row and column names (metadata) are systematically dropped. You must manually capture `colnames()` and `rownames()` before the C call and repopulate them onto the output matrices/lists after returning from the C layer to prevent silent metadata loss.
**Action:** When reconstructing matrices from `unlist()` C output, explicitly re-assign `dimnames` using original variable metadata.
