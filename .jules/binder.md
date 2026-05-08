## 2026-05-08 - Package File Location Hygiene

**Learning:** Placing non-R data files (such as Markdown journals or documentation) in the `data/` directory triggers an `R CMD check` WARNING ('Files not of a type allowed...').

**Action:** Relocate such files to the canonical `inst/extdata/` directory to maintain proper package structure and avoid CRAN warnings.
