## 2025-02-14 - S3 Method Export Requirements

**Learning:** `roxygen2` requires S3 methods to be explicitly tagged with `@export` (or `@exportS3Method`) to correctly identify and register them. If a method is listed in the manually-maintained `NAMESPACE` file but lacks a roxygen tag, `devtools::document()` and `R CMD check` will flag it as needing a tag for roxygen translation.

**Action:** Always verify that S3 methods (like `print` and `plot`) have an `@export` tag in the R source code when converting or maintaining Roxygen documentation, even if they are already exported in a pre-existing `NAMESPACE` file.
