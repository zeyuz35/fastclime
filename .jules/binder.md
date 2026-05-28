## 2026-05-28 - Fixing data structure and NAMESPACE
**Learning:** R packages require data files inside `data/` to be standard R data formats (like .rda). Non-R data, such as .md files, must be placed in `inst/extdata/`. In addition, using functions like `flush.console()` without an explicit namespace import creates a global function definition NOTE during R CMD check.
**Action:** Relocate non-R data out of `data/` to `inst/extdata/`, and explicitly import required functions like `flush.console` in the `NAMESPACE`.
