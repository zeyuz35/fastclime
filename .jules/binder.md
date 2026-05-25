## 2026-05-25 - Relocate non-R data file to inst/extdata
**Learning:** Placing non-R data files (such as Markdown journals like `AGENTS.md`) in the top-level root directory, `data/`, or `src/` directory triggers an `R CMD check` WARNING ('Please use e.g. inst/extdata for non-R data files').
**Action:** Relocate such files to the canonical `inst/extdata/` directory to resolve structural hygiene issues.
