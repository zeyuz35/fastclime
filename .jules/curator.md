## 2026-05-28 - Curator Initialized\n**Learning:** Started as Curator to fix metadata/attributes issues.\n**Action:** Always capture and restore dimnames and attributes when using .C() or matrix subsetting.
## 2026-05-28 - Preserve matrix metadata and prevent 1D coercion in subsetting
**Learning:** Subsetting with drop = FALSE is needed when validn could be 1 and C level functions lose dimnames.
**Action:** Use drop = FALSE and manually set dimnames for matrices after .C() calls.
