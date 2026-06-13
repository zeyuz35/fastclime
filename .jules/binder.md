## 2026-06-13 - Explicit Namespacing for Better Package Hygiene
**Learning:** Global imports from large packages (like `Matrix`, `igraph`, `MASS`) can pollute the namespace and cause masking issues or unexpected behavior.
**Action:** Instead of globally importing `Matrix`, `igraph`, and `MASS` in `DESCRIPTION` (`Depends`) and `NAMESPACE`, move them to `Imports` and use explicit namespaces (e.g., `Matrix::Matrix()`, `MASS::mvrnorm()`) directly in the code to reduce dependency footprint and clarify function origins.
