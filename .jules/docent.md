## 2025-04-11 - Fixed missing explicit utils namespace for flush.console()

**Learning:** `flush.console` needs to be explicitly namespaced (`utils::flush.console()`) in package code, otherwise `R CMD check` fails with 'no visible global function definition' NOTE.

**Action:** Prefer explicit `utils::flush.console()` calls locally rather than using the global NAMESPACE directive `importFrom("utils", "flush.console")`.
