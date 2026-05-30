## 2026-05-30 - Standardized Exclamation Points in Output/Errors
**Learning:** Replaced informal/excessive exclamation marks in user-facing output messages and errors (e.g., `Done!`, `Dimensions do not match!`) with professional periods across the source code and corresponding test assertions.
**Action:** When updating informal output strings, always grep the `tests/` directory to update exact string matches in `expect_warning()` or `expect_error()` to prevent test failures.
