## 2026-06-11 - Explicit Namespacing and Data File Relocation
**Learning:** `R CMD check` fails when dataset directories contain non-data files (like `AGENTS.md`) and when base R utilities (like `flush.console()`) are not explicitly namespaced, polluting the global namespace.
**Action:** Always move non-data files to `inst/extdata` and namespace `flush.console()` calls directly in the codebase using `utils::flush.console()` instead of modifying the `NAMESPACE` file.
