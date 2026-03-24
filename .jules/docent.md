## 2024-03-24 - S3 method documentation

**Learning:** When using roxygen2 to document S3 methods, you must use BOTH `#' @method generic class` (e.g., `#' @method print sim`) AND `#' @export` tags to explicitly and safely define S3 methods. Failing to do so causes `devtools::document()` or `R CMD check` warnings about undocumented methods.

**Action:** Always add both tags explicitly above S3 method definitions.
