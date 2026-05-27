## 2026-05-27 - Explicit Namespacing for base utils functions

**Learning:** `R CMD check` flags missing global variable or function definitions for base tools like `flush.console` if they are not explicitly namespaced or imported.
**Action:** Always import missing base functions like `utils::flush.console` in the `NAMESPACE` file if they are used without explicit package namespacing.
