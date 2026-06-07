## 2026-06-07 - Integer overflow in matrix dimension allocations
**Vulnerability:** Found potential integer overflows in `src/fastlp.c`, `src/paralp.c`, `src/dantzig.c`, and `src/parametric.c`. When multiplying matrix dimensions `m * n` to calculate total allocation sizes or element accesses, an integer overflow can occur if the product exceeds `INT_MAX`, leading to memory corruption or out-of-bounds access.
**Learning:** Matrix dimensions `m` and `n` originating from R are signed 32-bit integers. Multiplying them directly as `int` risks overflow.
**Prevention:** Explicitly cast operands to `long long` when computing `m * n` or enforce upper bounds on input matrix dimensions in C before allocating memory.
