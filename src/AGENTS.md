# src/ — C Source Code

## Critical: Use Custom Memory Macros

All C code MUST use macros from `myalloc.h` — do not use standard `malloc`/`free`:

```c
#include "myalloc.h"

MALLOC(ptr, size, type);
CALLOC(ptr, size, type);
REALLOC(ptr, size, type);
FREE(ptr);  // Sets ptr = NULL after free
```

## Memory Leak Pattern

When allocating inside loops, free before next iteration:
```c
for (lambda_idx = 0; lambda_idx < nlambda; lambda_idx++) {
    CALLOC(output_vec, d, double);
    // ... use output_vec ...
    FREE(output_vec);  // Must free each iteration
}
```

## Files

- `dantzig.c` — Dantzig selector solver
- `fastlp.c` — generic LP solver
- `paralp.c` — parametric LP solver
- `lu.c`, `linalg.c`, `parametric.c`, `tree.c`, `heap.c` — support routines
- `myalloc.h` — memory macros (MALLOC, CALLOC, REALLOC, FREE)
- `*.h` — headers, do not edit compiled `.o`/`.so` files

## Build

```bash
R CMD INSTALL .  # Rebuilds everything
```

## Cross-Platform

x86 vs ARM can diverge ~20% on individual solutions — expected behavior.
