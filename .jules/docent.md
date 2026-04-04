## 2025-04-04 - S3 Method Documentation Requires Specific Tags

**Learning:** When using roxygen2 to document S3 methods, you must use both `#' @method generic class` and `#' @export`. Relying on manual creation of `Rd` files or older roxygen variants without these tags can cause warnings during document generation or check phases. Additionally, the `DESCRIPTION` file must specify `Encoding: UTF-8` to prevent non-ASCII character warnings during `devtools::document()`.

**Action:** Always include `@method generic class` and `@export` tags above S3 methods and verify `Encoding: UTF-8` is present in `DESCRIPTION` when making documentation updates involving roxygen.
