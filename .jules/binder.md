## 2026-06-16 - Namespacing flush.console()
**Learning:** `R CMD check` fails with missing visible global function definitions for base R utilities like `flush.console` if they are not namespaced, since they are part of `utils` which isn't explicitly imported or loaded by default globally without `utils::`.
**Action:** Use explicit namespacing (e.g., `utils::flush.console()`) in R functions rather than updating the `NAMESPACE` file for base package functions to keep the namespace clean.
