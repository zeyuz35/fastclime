## 2024-05-24 - Explicit Namespacing and Dependency Management

**Learning:** Global imports of common external packages like `Matrix`, `igraph`, and `MASS` in the `NAMESPACE` file combined with their inclusion in `Depends` can pollute the global environment and violate clean namespace practices, increasing the likelihood of function masking issues and dependency conflicts, particularly for domain-specific functions like `graph.adjacency`.

**Action:** Whenever possible, rely on `Imports` rather than `Depends` in the `DESCRIPTION` file, omit global `import()` statements in the `NAMESPACE` file for external dependencies, and explicitly namespace external function calls in the source code (e.g., `pkg::func()`).
