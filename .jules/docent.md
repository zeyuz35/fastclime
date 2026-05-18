## 2024-05-18 - Remove informal language (exclamation points) from warnings and errors

**Learning:** When modifying explicit warning or error message strings in R packages (e.g., removing informal language or exclamation points), you must also search the `tests/` directory to update any corresponding `expect_warning()` or `expect_error()` assertions that match the exact string to prevent test failures.

**Action:** Before removing exclamation points from `warning()` or `stop()` strings, I will run a `grep` in `tests/` for the exact string or `expect_warning` / `expect_error` blocks and modify the assertions alongside the source code.
