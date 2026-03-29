## 2024-05-24 - Fix integer multiplication overflow in memory allocation macros
**Vulnerability:** Integer multiplication overflow in dynamic memory allocations (`MALLOC`, `CALLOC`, `REALLOC`).
**Learning:** Extreme length vectors in R (up to 2^31-1) can cause integer wrapping when multiplied by `sizeof(type)`, resulting in dangerously undersized buffer allocations and subsequent heap buffer overflows in C extensions.
**Prevention:** Always verify integer capacities against `_safe_len > ((size_t)-1) / sizeof(type)` prior to dynamically allocating buffers.
