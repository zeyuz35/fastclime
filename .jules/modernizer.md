## 2024-04-26 - Optimized covariance calculation with `crossprod`

**Learning:** Base R operations like `t(X) %*% X` inside covariance calculations (`(t(X) %*% X) / bigT`) are needlessly slower than `crossprod(X)`. Using `crossprod(X)` significantly improves matrix multiplication efficiency while producing identical mathematical results, and when clearly commented, preserves the readability of the legacy pattern. Additionally, resolving missing NAMESPACE imports (like `flush.console` in C-called paths) and misplaced files in `data/` fixes CRAN checks.

**Action:** When finding `t(X) %*% X`, replace it with `crossprod(X)` and add an explanatory comment to document the equivalent `%*%` logic, ensuring no precision or result loss. Add missing required imports from base packages to NAMESPACE. Relocate improperly placed markdown files from `data/` to `inst/extdata/` to resolve `R CMD check` WARNINGS.
