## 2026-05-23 - Relocate Non-R Data Files to inst/extdata
**Learning:** `R CMD check` requires that non-R data files (such as Markdown files like `AGENTS.md`) should not be placed in the `data/` directory, which is strictly for `.rda`, `.rda`, etc. Placing them there will cause a WARNING.
**Action:** When creating or handling non-R data files like `AGENTS.md` in R packages, always place them in `inst/extdata/` (or the top-level directory if required by conventions, but ensure it avoids warnings) to maintain package hygiene.
