## 2024-05-24 - Missing global functions

**Learning:** Unqualified calls to base/recommended functions like `sd()` and `image()` result in "no visible binding for global variable" WARNINGs in `R CMD check`.
**Action:** Use explicit namespacing (e.g., `stats::sd`, `graphics::image`) for standard functions instead of adding them to the `NAMESPACE` file.
