## 2024-05-14 - S3 methods need explicit export tags in roxygen2

**Learning:** S3 methods (`print`, `plot`, etc.) must have an explicit `#' @export` (or `#' @exportS3Method`) tag in the source code to satisfy roxygen2 checks (`devtools::document()`) and avoid warnings like "S3 method `plot.fastclime` needs @export or @exportS3Method tag", even if they are already exported via manual registration in the NAMESPACE file.

**Action:** Always add `#' @export` above S3 methods when using roxygen2 to manage documentation, ensuring clean package checks and proper method registration.
