## 2024-05-24 - Missing S3 Method Export Tags Resulting in R CMD check Warnings

**Learning:** S3 methods (`print.sim`, `plot.sim`) in `fastclime.generator.R` were manually exported in the `NAMESPACE` file but were missing `#' @export` or `#' @exportS3Method` tags in the source files, causing `R CMD check` and `devtools::document()` evaluation errors/warnings regarding missing tags when parsing roxygen blocks.

**Action:** Added the `#' @export` tags to the source file to satisfy roxygen requirements and align with the existing `NAMESPACE` rules.
