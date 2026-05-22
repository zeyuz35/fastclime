## 2026-05-22 - Replace Informal Language and Exclamation Points
**Learning:** In the `fastclime` package, informal punctuation (like `!`) and informal language (e.g., "don't") were used in warning and error strings across multiple R files (`R/fastclime.R`, `R/dantzig.R`, `R/fastlp.R`, `R/paralp.R`, `R/fastclime.selector.R`).
**Action:** Replaced exclamation points with periods and "don't" with "do not" in all source files, and importantly, updated the corresponding assertions in `tests/testthat/test-methods.R` (`expect_warning`) to match the new string exactly, ensuring test consistency.
