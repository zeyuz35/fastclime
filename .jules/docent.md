## 2026-05-14 - Exclamation Point Removal in Messages
**Learning:** Modifying explicit warning or error message strings in R packages (like removing exclamation points) requires simultaneously updating the corresponding `expect_warning()` or `expect_error()` assertions in the `tests/` directory that match the exact string to prevent test failures.
**Action:** Always run `grep -r "string"` in `tests/` when modifying messages to ensure assertions are updated.
