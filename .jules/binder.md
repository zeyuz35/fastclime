## 2026-05-10 - Package structure warnings in R
**Learning:** R package `data/` directories should strictly contain R data objects. Placing non-data files (like `AGENTS.md`) causes `R CMD check` warnings. Furthermore, `flush.console` must be explicitly imported from `utils` in the `NAMESPACE`.
**Action:** Move non-data artifacts out of `data/` into `inst/extdata/` to comply with structural standards, and manually edit `NAMESPACE` for standard utils when `roxygen2` does not manage it.
