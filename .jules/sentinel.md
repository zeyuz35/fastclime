## 2024-05-18 - C memory allocation safety
**Vulnerability:** Zero-length memory allocations can return `NULL`, erroneously triggering fatal Out Of Memory errors and potential Undefined Behavior if passed to memory functions.
**Learning:** Standard C memory allocators like `malloc(0)` or `calloc(0)` may return `NULL` according to the standard. In an R package where `NULL` is treated as a fatal `error()`, a legitimate 0-length allocation request can crash the interpreter. Evaluating the length parameter twice in macros is a hazard.
**Prevention:** Safe allocation macros must check the length parameter to ensure at least 1 element is requested. Use a local variable `size_t _safe_len = (len)` to avoid double-evaluation hazards in the macros.
