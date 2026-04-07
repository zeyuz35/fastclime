# Fastclime C Code Re-Implementation Plan

## 1. Goal Description
The objective is to re-implement the messy and obsolete C codebase serving the `fastclime` package. The rewritten core will serve as a **drop-in replacement** to the existing R wrappers, retaining the exact function signatures while achieving Thread Safety, Readability (no function over 200 lines, clear variables), Best C Coding Standards (modern macro usage, structured memory), and no spaghetti GOTOs.

## User Review Required
> [!IMPORTANT]
> - Do you approve of introducing a new `solver_core.c` file to unify the logic previously repeated inside `fastlp.c`, `paralp.c`, and `dantzig.c`? 
> - By adopting standard C pointer return allocation styling (`ptr = FC_CALLOC(n, size)`), we will touch over 200 lines in the source. Please confirm this strict macro replacement approach is acceptable.

## 2. Core Architectural Changes

### 2.1 State Management (Thread Safety)
Currently, `fastclime`'s C code heavily relies on static global variables (e.g. `root` in `tree.c`, `rank` and `L` in `lu.c`, `status` in `paralp.c`). We will define typed context/state `structs` that encapsulate state and pass pointers to these states throughout computation paths.

### 2.2 Shared Core vs Monolith
Currently, `fastlp.c` (`solver20`), `paralp.c` (`solver21`), and `dantzig.c` contain completely duplicated monolithic `for`/`while` loops that each stretch between 300-400 lines of code. We will consolidate shared mathematical operations into small, <100-line helpers inside a central unit.

### 2.3 Lexical Readability and Coding Standards
- Change unstructured variable names like `x_B`, `dx_B` to mathematically clear but approachable variables like `primal_B`, `primal_dx`, `dual_N`, `dual_dy`.
- Remove `MALLOC(ptr, size, type)` macros that arbitrarily hide the assignment logic. Use `ptr = FC_CALLOC(size, sizeof(type));` which adheres to better standard C auditing practices while retaining fail-fast error behavior.
- Re-architect loops holding `goto again;` into clear deterministic `while()` loops with boolean break flags.

## 3. Proposed Changes

### 3.1 Mapping of Old Codebase to Proposed Refactor

| Old File / Component | New File / Component | Changes & Description |
|---|---|---|
| `fastlp.c` `fastlp()` | `fastlp.c` `fastlp()` | Maintains R signature. Function `solver20()` removed. Driver loop uses `solver_core.c`. |
| `paralp.c` `paralp()` | `paralp.c` `paralp()` | Maintains R signature. Function `solver21()` removed. Driver loop uses `solver_core.c`. |
| `dantzig.c` `dantzig()` | `dantzig.c` `dantzig()` | Maintains R signature. Monolithic loop split into smaller stepping functions. |
| `parametric.c` `parametric()` | `parametric.c` `parametric()` | Maintains R signature. Loop modified to manage parallel memory contexts instead of racing globals. |
| **None (Duplicated)** | [NEW] `solver_core.c` | Contains `fc_ratio_test()`, `fc_compute_direction()`, `fc_update_basis()`. Removes code repetition across `fastlp/dantzig/paralp`. |
| `lu.c` / `lu.h` | `lu.c` / `lu.h` | Static globals removed. State transferred into `fc_lu_context_t`. `lufac()` logic split into `fc_lu_init()`, `fc_lu_factor_step()`. |
| `linalg.c` / `linalg.h` | `linalg.c` / `linalg.h` | `static int *tag` and `currtag` removed. Matrix multipliers now take a `fc_sparse_workspace_t*` pointer. |
| `tree.c` / `tree.h` | `tree.c` / `tree.h` | Removed `static TNODE *root`. Functions updated to take `TNODE **root_ptr`. |
| `heap.c` / `heap.h` | `heap.c` / `heap.h` | Signature adjustments for struct state passing. |
| `myalloc.h`, `macros.h` | `memory.h`, `config.h` | Replacing assignment macros with standard-compliant fail-fast pointer-return macros. |

## 4. Specific Refactoring Steps

### 4.1 Global Memory Context Tracker
Rather than tracking 20 loose array pointers and risking memory leaks on early exit conditions, each driver creates a primary solver context containing its required structures under unified lifecycle management (`fc_init_solver` and `fc_free_solver`).

```c
typedef struct {
    double *primal_B;       // Formerly x_B
    double *dual_N;         // Formerly y_N
    double *primal_dx;      // Formerly dx_B
    // ...
} fc_solver_state_t;
```

### 4.2 Restructuring `lu.c` `lufac()`
Replace the massive `lufac()` code block containing `goto again;` and `goto end;` with a structural context layout guaranteeing no function exceeds 200 lines:
```c
fc_lu_context_t* fc_lu_factorize(int m, fc_sparse_matrix_t* A, int* basics) {
    fc_lu_context_t* ctx = fc_lu_init(m, A);
    while (ctx->rank < m) {
        if (!fc_lu_step_elimination(ctx)) {
            break; 
        }
    }
    return fc_lu_finalize(ctx);
}
```

## 5. Verification Plan

### Automated Tests
- Running `devtools::test(filter = "cvxr")` against Vanilla ground truth tests to ensure no regressions in outputs across different matrix geometries.
- Recompiling (`R CMD INSTALL .`) safely via Clang and GCC to measure any warning noise changes (zero warning goal).

### Manual Verification
- Testing Valgrind checks on `dantzig.c` invocations directly from R wrappers to prove memory links via early exits have been completely mitigated.
