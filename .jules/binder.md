## 2026-05-15 - Missing Utils Import
**Learning:** Functions like `flush.console()` are in the `utils` package, but are often used implicitly. `R CMD check` requires them to be imported in the `NAMESPACE` or namespaced explicitly via `utils::flush.console()`.
**Action:** When a base R package function (like `utils::flush.console()`) is used implicitly, namespace it explicitly to avoid NOTE messages during `R CMD check`.
