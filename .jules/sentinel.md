## 2024-05-24 - [Zero-Length Allocation Denial-of-Service]
**Vulnerability:** Zero-length requests to memory allocation functions like `malloc(0)` and `calloc(0, ...)` can return `NULL`, leading to a false "Memory allocation failed" error in R via `error()` and crashing the R session (denial-of-service). Furthermore, macro expansion without a local variable can lead to double-evaluation hazards.
**Learning:** `malloc(0)` behavior is implementation-defined, and handling memory allocation within R requires special attention to avoid unwanted `error()` triggers that act like fatal aborts.
**Prevention:** Use a local variable like `_safe_len` to safely evaluate the length parameter exactly once, and ensure at least 1 element is requested by converting 0 to 1 (`_safe_len > 0 ? _safe_len : 1`).
