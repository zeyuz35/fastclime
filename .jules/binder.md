## 2026-05-13 - Structural Hygiene
**Learning:** Placing non-R data files in the `data/` directory triggers an `R CMD check` WARNING. Furthermore, using `utils::flush.console` in the code without explicit namespace declaration triggers a NOTE.
**Action:** Relocate non-R data files (e.g. `AGENTS.md`) to `inst/extdata/` to comply with standard CRAN rules and add the missing import directive in `NAMESPACE`.
