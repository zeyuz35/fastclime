## 2024-03-21 - Fix S3 method documentation

**Learning:** When using roxygen2 to document S3 methods in manually maintained NAMESPACE packages, adding `#' @export` or `#' @exportS3Method` can generate an incomplete or conflicting `.Rd` file which causes `R CMD check` warnings or errors. Using `#' @method generic class` explicitly (e.g. `#' @method print sim`) resolves the documentation structure.

**Action:** Add explicit `#' @method print sim` and `#' @method plot sim` tags above the S3 method functions for the `sim` class, along with basic title and param documentation. Delete any old generated files first before re-running `devtools::document()`.
