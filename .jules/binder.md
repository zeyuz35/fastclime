## 2026-06-07 - Move AGENTS.md to inst/extdata
**Learning:** R `data/` directory must strictly contain datasets (like `.rda` or `.RData`). Having non-R data files like `AGENTS.md` triggers an `R CMD check` WARNING.
**Action:** Always verify `R CMD check .` results to catch file placement issues, and move non-data files to `inst/extdata`. Also watch out for `build/vignette.rds` cache file warnings.
