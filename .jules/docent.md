## 2024-05-24 - Document `fastlp` and `paralp` with roxygen2

**Learning:** Migrated `.Rd` files to roxygen2 blocks within the functions' source files, utilizing LaTeX formulas (`\eqn{}`, `\deqn{}`) and proper formatting to improve clarity and maintainability.

**Action:** Ensure that all converted `.Rd` files are subsequently removed to let `devtools::document()` correctly construct the manual pages. Use `\eqn{}` for inline equations and `\deqn{}` for block ones to conform with proper R documentation styles.
