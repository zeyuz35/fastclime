## 2024-05-24 - explicit namespace for external dependencies

**Learning:** It's important to use explicit namespaces for functions from external packages (like `Matrix::Matrix()`, `MASS::mvrnorm()`, `igraph::graph.adjacency()`, `igraph::layout.fruchterman.reingold()`) rather than relying on them being attached via `import()` in `NAMESPACE` or `Depends` in `DESCRIPTION`. This minimizes the global namespace footprint.

**Action:** Replace unqualified external function calls with explicitly namespaced ones (`pkg::func()`), and update `NAMESPACE` to not use global `import()`.
