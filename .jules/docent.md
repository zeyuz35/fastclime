## 2026-06-16 - Explicitly Namespace flush.console()

**Learning:** When using base R utilities like `flush.console()`, calling them directly without namespace prefix (e.g., `utils::flush.console()`) will raise an `R CMD check` warning about "no visible global function definition" because `utils` is not attached by default in a package namespace context, though it's available in standard R sessions. While we could add an `importFrom` directive to `NAMESPACE`, explicitly namespacing these utilities throughout the codebase is preferred to prevent global namespace pollution and strictly follow cleaner package hygiene.

**Action:** Whenever `flush.console()` or similar utility functions are used, explicit namespacing such as `utils::flush.console()` should be adopted to resolve missing definition errors.
