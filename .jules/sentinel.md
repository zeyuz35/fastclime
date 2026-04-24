## 2026-04-09 - Heap Buffer Overflow via Integer Overflow in Memory Allocations
**Vulnerability:** Memory allocation macros (`FC_CALLOC`) accept array dimensions that are calculated using arithmetic operations without prior casting (e.g., `nz + m` and `n + m + 1`).
**Learning:** These arithmetic operations (e.g., multiplication and addition like `nz + m` where `nz = m*n`) can trigger a 32-bit integer overflow before the value is cast to `size_t` inside the macro. This can bypass the size checks inside the macro, causing dangerously undersized memory allocations, leading to heap buffer overflows when the code writes to the expected boundaries.
**Prevention:** Always explicitly cast the first operand to `size_t` before performing arithmetic operations for memory allocation sizes (e.g., `(size_t)nz + m`).

## 2026-04-09 - Heap Buffer Overflow via Integer Overflow in Memory Allocations
**Vulnerability:** Memory allocation macros (`FC_CALLOC`) accept array dimensions that are calculated using arithmetic operations without prior casting (e.g., `nz + m` and `n + m + 1`).
**Learning:** These arithmetic operations (e.g., multiplication and addition like `nz + m` where `nz = m*n`) can trigger a 32-bit integer overflow before the value is cast to `size_t` inside the macro. This can bypass the size checks inside the macro, causing dangerously undersized memory allocations, leading to heap buffer overflows when the code writes to the expected boundaries.
**Prevention:** Always explicitly cast the first operand to `size_t` before performing arithmetic operations for memory allocation sizes (e.g., `(size_t)nz + m`).
