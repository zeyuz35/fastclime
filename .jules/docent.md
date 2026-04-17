## 2026-04-17 - Generated test files during exploration

**Learning:** Running `devtools::test()` can sometimes generate untracked plot files like `tests/testthat/Rplots.pdf` even if no explicit plot test exists (e.g. if a test internally triggers a base R plot).
**Action:** When cleaning up build artifacts, ensure that `tests/testthat/Rplots.pdf` is also explicitly removed along with root-level `Rplots.pdf` to prevent staging it during commit steps.
