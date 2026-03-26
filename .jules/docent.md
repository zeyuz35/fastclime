## 2025-03-01 - Incomplete roxygen block leads to R CMD check warnings

**Learning:** Incomplete roxygen blocks, or missing `@export` combined with `@method`, for S3 methods trigger a 'needs @export or @exportS3Method tag' warning from `devtools::document()` and invalid `.Rd` generation causing `R CMD check` warnings. Deleting old `.Rd` files without migrating existing `\author` or `\seealso` blocks causes documentation regression. Also, roxygen blocks should wrap at 80 characters.

**Action:** Always provide complete roxygen blocks (including `@author`, `@seealso`) wrapped at 80 chars for S3 method documentation.
