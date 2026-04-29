# src/ — C Source Code

## Critical: Use Custom Memory Macros

All C code MUST use macros from `memory.h` — do not use standard `malloc`/`free`:

```c
#include "memory.h"

FC_MALLOC(ptr, size, type);
FC_CALLOC(ptr, size, type);
FC_REALLOC(ptr, size, type);
FC_FREE(ptr);  // Sets ptr = NULL after free
```

## Memory Leak Pattern

When allocating inside loops, free before next iteration:
```c
for (lambda_idx = 0; lambda_idx < nlambda; lambda_idx++) {
    FC_CALLOC(output_vec, d, double);
    // ... use output_vec ...
    FC_FREE(output_vec);  // Must free each iteration
}
```

## Files

- `dantzig.c` — Dantzig selector solver
- `fastlp.c` — generic LP solver
- `paralp.c` — parametric LP solver
- `lu.c`, `linalg.c`, `parametric.c`, `tree.c`, `heap.c` — support routines
- `memory.h` — memory macros (FC_MALLOC, FC_CALLOC, FC_REALLOC, FC_FREE)
- `*.h` — headers, do not edit compiled `.o`/`.so` files

## Build

```bash
R CMD INSTALL .  # Rebuilds everything
```

## Cross-Platform

x86 vs ARM can diverge ~20% on individual solutions — expected behavior.
