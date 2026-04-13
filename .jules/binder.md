## 2024-05-18 - Explicit Namespacing and Dependency Reduction

**Learning:** S3 method dispatch works correctly even if the package is moved from Depends to Imports, without needing explicit namespacing. However, function calls like `MASS::mvrnorm()` and `igraph::graph_from_adjacency_matrix()` require explicit namespacing when their respective packages are moved to Imports. `utils::flush.console()` avoids R CMD check NOTE on undefined global functions.

**Action:** Move packages from `Depends` to `Imports` and use explicit namespacing (`pkg::func()`) for all imported function calls. Retain S3 methods without explicit namespacing. Resolve missing globals like `flush.console` by using explicit namespaces rather than global imports in `NAMESPACE`.
