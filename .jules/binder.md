## 2026-06-20 - R CMD check NOTEs for flush.console()
**Learning:** `R CMD check` fails with a NOTE (which fails CI on strict settings) when base R functions like `flush.console` are used without explicit namespace `utils::flush.console()`.
**Action:** Always explicitly namespace base R utility functions like `utils::flush.console()` to ensure package hygiene and pass `R CMD check` cleanly.
