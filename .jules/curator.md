## 2024-05-18 - Fix Metadata Loss during C Interface Calls

**Learning:** When passing matrices into `.C()` and retrieving outputs, matrix attributes like `colnames` and `rownames` are silently stripped.

**Action:** Always capture `colnames()` and `rownames()` before the `.C()` call and explicitly re-apply them to the output matrices/lists after returning to R to prevent silent metadata loss.
