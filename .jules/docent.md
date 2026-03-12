## 2024-03-12 - Explicit Exports Required for S3 Methods in roxygen2

**Learning:** `roxygen2` requires S3 methods (like `plot` and `print`) to have an explicit `#' @export` or `#' @exportS3Method` tag in the source code in order to be recognized and avoid warnings during documentation generation, even if they are already exported in a manually maintained `NAMESPACE` file.

**Action:** Always add `#' @export` tags above S3 methods when migrating or maintaining code that uses `roxygen2` to generate or check documentation, to prevent `roxygen2` from complaining about missing tags.
