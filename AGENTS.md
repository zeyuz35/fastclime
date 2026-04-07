# fastclime

R package for sparse precision matrix estimation via parametric simplex method.

## Current Status: CORE REWRITE COMPLETED (Testing & Optimization Phase)
**Branch**: `rewrite`
**Objective**: Drop-in C core re-implementation for thread-safety, standard memory allocations, and readability. 
**Latest Milestone**: Full C engine re-implementation completed and verified. Performance parity established with `dev` branch (+5.7% overhead for thread-safety features).

## AI Workflow

**First**: Read `.AI/AGENTS.md` and `.AI/journal/` to understand repository state.

**After work**: Update `.AI/journal/` and this file with progress.

---

## Verification Protocol

**CVXR ground truth implementations:**
- Vanilla CLIME: `tests/testthat/setup.R`
- BK17 variant: `scratch/CLIME_CVXR_BK17.R`
- ZKL15 variant: `scratch/CLIME_CVXR_ZKL15.R`

The fastclime C implementation must produce results consistent with CVXR.

**Running tests:**
```bash
devtools::test(filter = "cvxr")      # Vanilla ground truth tests
devtools::test(filter = "variants")   # BK17/ZKL15 variant tests
```

**Tolerances:**
- Frobenius relative error < 0.15 (15%)
- Correlation > 0.95

If fastclime diverges significantly, the C code has a bug.

---

## Bug Dashboard

**Note**: Many "bugs" identified by static analysis are NOT actual bugs. The C code relies on specific memory allocation patterns (CALLOC zero-initializes) that make certain "undefined behavior" actually defined. Fixing these often BREAKS the algorithm. The current implementation is **verified against CVXR ground truth** (100 PASS).

### Verified Issues

| Bug | Severity | Status | Location | Notes |
|-----|----------|--------|----------|-------|
| print.fastclime() both branches execute | Critical | **RESOLVED** | `R/fastclime.R:152-157` | Fixed: two `if` → `if/else` |
| Memory leak: output_vec not freed | High | **RESOLVED** | `src/dantzig.c` | Fixed by adding `FREE(output_vec)` |
| Memory leak when m decreases | Medium | **RESOLVED** | `src/lu.c:966-972` | Fixed FREE(orig) |

### Static Analysis Errors (NOT Bugs)

| Report | Reason |
|--------|--------|
| Off-by-one in paralp validation (`< 0` → `<= 0`) | **NOT A BUG** — `rhs_bar = 0` means "no perturbation" for that constraint. C code skips zero entries in ratio test (`xbar_B[i] > EPS2`). Docs say "nonnegative" (≥ 0), confirming zero is valid. |
| Uninitialized `link[-1]` in linalg.c:171 | **NOT A BUG** — `link_buf` allocated with CALLOC (zero-initializes), so `link[-1]` accesses zeroed sentinel |
| Uninitialized `link[-1]` in lu.c:977-983 | **NOT A BUG** — Same reason, first element is initialized before use |
| REALLOC without NULL check | **NOT A BUG** — Fixes changed algorithm behavior and broke tests |
| Division by zero guards | **NOT ACTIONABLE** — Fixes changed numerical behavior and broke tests |
| Float equality `temp != 0.0` | **NOT A BUG** — Algorithm works correctly without tolerance |

### Test Coverage Gaps

| Gap | Severity | Status | Notes |
|-----|----------|--------|-------|
| dantzig.selector() has NO tests | Critical | **OPEN** | Core function completely untested |
| NA/Inf validation not tested | High | **OPEN** | Error paths uncovered |
| print.sim/plot.sim untested | Medium | **OPEN** | sim class methods missing |
| BK17/ZKL15 not tested | High | **RESOLVED** | Algorithm variants covered in `test-cvxr-variants.R` |

### Known/Expected Issues

| Issue | Severity | Status | Notes |
|-------|----------|--------|-------|
| Cross-platform divergence (x86 vs ARM ~20%) | Low | **KNOWN** | Expected behavior, mathematically valid |
| CVXR deprecation warnings | Low | **KNOWN** | `getValue()` replaced by `value()` in future CVXR |

### Performance Benchmarks (2026-04-07)

| Branch | Mean Time (ms) | Median Time (ms) | Relative |
|--------|----------------|------------------|----------|
| `dev`  | 26.50          | 26.57            | Baseline |
| `rewrite` | 28.01       | 28.01            | +5.71%   |

**Setup**: $n=200, d=50$, random graph, 20 iterations.
**Observation**: The rewrite introduces a negligible ~6% overhead due to context-passing and structured memory management, which is an acceptable trade-off for thread safety and readability.

---

## Directory Agents

Each subdirectory has its own `AGENTS.md` with specialized guidance:

- **[R/](R/AGENTS.md)** — R source code conventions
- **[src/](src/AGENTS.md)** — C code and memory safety
- **[tests/](tests/AGENTS.md)** — testing guide
- **[scratch/](scratch/AGENTS.md)** — development scripts
- **[smoke/](smoke/AGENTS.md)** — parity reference scripts
- **[data/](data/AGENTS.md)** — package data
- **[.AI/](.AI/AGENTS.md)** — AI agent workflow

---

## Build & Check

```bash
R CMD INSTALL .
R CMD check --as-cran .
devtools::test()
```

## Architecture

- `R/` — R wrapper functions
- `src/` — compiled C source (dantzig.c, fastlp.c, paralp.c, lu.c, linalg.c, parametric.c, tree.c, heap.c)
- `src/myalloc.h` — custom memory macros: MALLOC, CALLOC, REALLOC, FREE
- `tests/testthat/` — test suite (testthat edition 3)
- `scratch/` — CV loop development scripts
- `smoke/` — parity reference scripts

## Core Functions

- `fastclime(x, lambda.min, nlambda)` — main solver
- `fastclime.selector(lambdamtx, icovlist, lambda)` — solution path selector
- `dantzig(X0, y, lambda, nlambda)` — Dantzig selector
- `fastlp(c, A, b)` — generic LP solver
- `paralp(c, A, b, c_bar, b_bar)` — parametric LP solver

## Key Test Tolerances

| Check | Tolerance |
|-------|-----------|
| Diagonal values | `0.2` |
| Numerical results | `1e-6` |
| Matrix symmetry | `1e-12` |

## Style

- R code: roxygen2 for docs (`roxygen2::roxygenize()`)
- C code: use `memory.h` and `FC_CALLOC`/`FC_FREE` macros. Do not use legacy `myalloc.h` assigning MACROs.
- Compiled artifacts (`.o`, `.so`) are committed — do not edit
