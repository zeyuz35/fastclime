## 2026-05-22 - Preserving Metadata in C-Wrapper Reconstructed Matrices
**Learning:** In R, when matrices or arrays are rebuilt from C-wrapper lists/returns (via `.C()`), row and column names (metadata) are systematically dropped because `.C()` returns a list of primitive vectors.
**Action:** Always capture `colnames()` and `rownames()` from the input matrices in the R layer before passing data to the `.C()` call, and manually repopulate them onto the output matrices/lists after returning from the C layer to prevent silent metadata loss.
