## 2026-03-20 - S3 Method Roxygen Documentation Fix

**Learning:** Using `@exportS3Method` in roxygen2 generated invalid `\usage` blocks in Rd files for S3 methods, causing `R CMD check` warnings.
**Action:** Use `@method generic class` (e.g., `@method print sim`) in roxygen2 to explicitly define S3 methods.
