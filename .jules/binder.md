## 2026-06-08 - Explicit namespaces for external calls and clean imports

**Learning:** When moving external dependencies from `Depends` to `Imports` in the `DESCRIPTION` file to minimize namespace pollution, the `import()` calls for the external packages should be removed from `NAMESPACE`. Furthermore, any function calls to those external packages must be properly namespaced (e.g. `MASS::mvrnorm`, `igraph::graph_from_adjacency_matrix`, `Matrix::Matrix`) in the source code to avoid function definition missing errors (`could not find function`).

**Action:** Whenever optimizing imports to reduce dependency bloat, explicitly namespace calls to the moved packages across the entire codebase to prevent execution or test failures.
