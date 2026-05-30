## 2026-05-30 - Prevent 32-bit Integer Overflow in C-Extensions
**Vulnerability:** C extensions in R using `.C` use legacy 32-bit integers, causing calculations like `d * d` to overflow when `d` is large, resulting in memory corruption.
**Learning:** Matrix subsetting dimensions in R need explicit `as.numeric()` casting before arithmetic if the results might exceed `.Machine$integer.max` before being allocated.
**Prevention:** Always validate size and cast `as.numeric()` for dimension multiplications before matrix allocation or `.C()` calls.
