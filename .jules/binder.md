## 2026-06-04 - Explicit Namespacing for utils::flush.console()
**Learning:** Functions like `flush.console()` from base R utilities should be explicitly namespaced to resolve `R CMD check` NOTEs ("no visible global function definition") and maintain good package hygiene without polluting the global namespace.
**Action:** When `R CMD check` highlights missing global function definitions for standard base/utils R functions, prefer explicit `utils::function_name()` namespacing over adding global `importFrom` directives to the `NAMESPACE` file when the usage is limited.
