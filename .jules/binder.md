## 2026-06-19 - Namespace explicitisation and R CMD check warnings
**Learning:** Base R functions like `flush.console` can cause `R CMD check` NOTEs if not explicitly namespaced via `utils::flush.console()` or if imported poorly. Additionally, build artifacts like `build/vignette.rds` or non-data files like `AGENTS.md` in `data/` will trigger build WARNINGs.
**Action:** Ensure explicit namespacing via `utils::flush.console()`, move non-data files to `inst/extdata/` and ignore development subdirectories correctly in `.Rbuildignore`.
