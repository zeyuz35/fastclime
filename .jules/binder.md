## 2026-06-15 - Explicitly namespace flush.console()
**Learning:** Resolving "no visible global function definition" for `flush.console` in `R CMD check` using `utils::flush.console()` is cleaner than using `importFrom` in NAMESPACE, preventing global namespace pollution.
**Action:** Explicitly namespace base utility calls (like `utils::flush.console()`) to maintain package hygiene.
