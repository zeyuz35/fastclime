## 2026-06-17 - Explicit namespacing for base R utilities
**Learning:** R CMD check issues NOTEs for missing global function definitions of base utilities like `flush.console`.
**Action:** Apply explicit namespaces (e.g., `utils::flush.console()`) in the codebase instead of adding them to the NAMESPACE file to avoid global namespace pollution.
