## 2026-05-05 - Fix Data Directory Package Hygiene

**Learning:** `R CMD check` fails with a WARNING when non-R data files like Markdown journals (e.g., `AGENTS.md`) are placed in the `data/` directory.

**Action:** Moved `AGENTS.md` to `inst/extdata/` to resolve the package hygiene issue and clear the warning.
