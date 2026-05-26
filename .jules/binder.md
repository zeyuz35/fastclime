## 2026-05-26 - Move non-R data files to inst/extdata
**Learning:** R package structure requires non-R data files (like Markdown journals `AGENTS.md`) to be placed in `inst/extdata/` instead of `data/` to avoid `R CMD check` warnings.
**Action:** Always verify `data/` directory contents and use `git mv` to relocate non-R data files to `inst/extdata/`.
