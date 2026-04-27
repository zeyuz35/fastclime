## 2024-05-19 - Fixed flush.console missing in NAMESPACE
**Learning:** Found an `R CMD check` NOTE "no visible global function definition for 'flush.console'".
**Action:** Always import required base/utils functions like `flush.console` explicitly from their respective packages in `NAMESPACE`.

## 2024-05-19 - Removed AGENTS.md from src and data
**Learning:** Found non-standard files `AGENTS.md` in `src` and `data` directories, which triggered WARNINGs in `R CMD check` because these folders have strict content requirements in R packages.
**Action:** Relocate or remove non-R data files from `src` and `data` to resolve `R CMD check` structural hygiene issues.
