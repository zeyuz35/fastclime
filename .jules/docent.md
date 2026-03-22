## 2024-03-22 - Missing S3 Export for plot.sim
**Learning:** Found an `R CMD check` warning about missing S3 method documentation tag for `plot.sim` which caused issues when updating `.Rd` files with `roxygen2`. Added the proper `#' @method plot sim` and `#' @export` tags.
**Action:** Always ensure that undocumented S3 methods added to the package have proper `roxygen2` tags so `R CMD check` passes cleanly without warnings about unexported methods.
