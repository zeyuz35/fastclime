
## 2025-04-18 - Fix undefined global functions

**Learning:** `R CMD check` fails on `flush.console` being an undefined global function. It doesn't find it directly because there is no importFrom utils directive.
**Action:** Always add explicit inline namespacing to R internal utils functions such as `utils::flush.console()` within the `.R` source files instead of relying on `NAMESPACE` imports to fix undefined globals like `flush.console` warnings.
