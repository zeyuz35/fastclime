
## 2025-04-21 - Fix namespace and directory structure hygiene issues

**Learning:** Unresolved references to `flush.console` in the source code caused an R CMD check NOTE regarding missing namespacing, while non-data files (such as `AGENTS.md`) located in the `data/` directory caused an R CMD check WARNING.

**Action:** Consistently namespace standard base R functions (`utils::flush.console()`) in the codebase instead of modifying the manually generated NAMESPACE file. Additionally, relocate non-R data files out of the `data/` directory into `inst/extdata/` to resolve structural warnings.
