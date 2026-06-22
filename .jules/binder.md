## 2026-06-22 - Explicit namespacing for base R utilities
**Learning:** When resolving `R CMD check` NOTEs about "no visible global function definition" for base R utilities like `flush.console()`, it's better to explicitly namespace them in the codebase (`utils::flush.console()`) rather than adding them to the `NAMESPACE` file.
**Action:** Always prefer explicit namespacing over `NAMESPACE` pollution when dealing with utilities that have a well-defined home package.
