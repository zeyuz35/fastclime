## 2026-05-06 - Explicit Dependency Imports

**Learning:** Sourcing packages entirely using `Depends:` makes functions available universally without being transparently mapped in the source code. Replacing `Depends:` with `Imports:` forces functions to explicitly call packages via namespace (`igraph::`, `MASS::`, `Matrix::`), making code clearer and ensuring that dependencies only load when required. Adding basic graphics/stat functionality like `cov2cor` or `image` also needs explicitly adding them to `NAMESPACE`.

**Action:** When auditing dependencies, explicitly use `pkg::func` notation for `igraph`, `MASS`, and `Matrix` functions in `.R` source files instead of relying on `Depends`. And remember to use `utils::flush.console()` over `flush.console()`.
