## 2026-05-24 - Resolve no visible global function definition NOTE

**Learning:** `flush.console` is a standard utils function but can cause a "no visible global function definition" NOTE in `R CMD check` if not namespaced explicitly as `utils::flush.console()`.
**Action:** When using `flush.console` in R packages, namespace it directly in the source code using `utils::flush.console()` to resolve the NOTE.
