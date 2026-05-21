## 2026-05-21 - Explicit namespacing and file hygiene
**Learning:** `flush.console()` from the `utils` package was used without explicit namespacing, which triggered a NOTE during `R CMD check`. `AGENTS.md` was also incorrectly placed in the `data/` directory, triggering a WARNING.
**Action:** Always verify namespacing of standard library functions like `flush.console` using `utils::flush.console()`. Place non-R data files like `AGENTS.md` in `inst/extdata/` to avoid `R CMD check` warnings.
