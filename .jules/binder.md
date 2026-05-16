## 2026-05-16 - Resolving package hygiene issues
**Learning:** `R CMD check` requires strict file organization. Non-R data files like `AGENTS.md` in `data/` or `src/` cause WARNINGs. Functions from `utils` like `flush.console` cause NOTEs for missing visible global definitions if not namespaced and imported.
**Action:** 1. Relocated `data/AGENTS.md` and `src/AGENTS.md` to `inst/extdata/`. 2. Replaced `flush.console()` with `utils::flush.console()` in R wrapper scripts and added `importFrom("utils", "flush.console")` to NAMESPACE. 3. Removed extraneous `build/vignette.rds`.
