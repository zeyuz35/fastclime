## 2025-05-15 - Move Dependencies to Imports

**Learning:** Shifting dependencies from Depends to Imports alters whether packages are attached to the global search path. This structural change requires explicit namespacing to prevent unintended method dispatch. We should manually maintain `NAMESPACE` when not using roxygen2 to export them, and removing global `import()` stops the auto-loading of packages.

**Action:** Moved `igraph`, `MASS`, and `Matrix` to Imports and explicitly namespaced `igraph::`, `MASS::`, and `Matrix::` functions across all R source files.