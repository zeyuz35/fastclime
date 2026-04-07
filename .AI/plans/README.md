# Plans

## Active

### 1. CVXR-Based Verification (NEW)
- **Priority**: Critical
- **Description**: Establish CVXR as ground truth for all C implementation changes
- **Workflow**: Compare fastclime output against CLIME_CVXR before/after any C modification
- **Tolerances**: Frobenius relative error < 0.1, correlation > 0.95

### 2. Cross-Platform Consistency
- **Priority**: Low
- **Description**: Investigate ways to reduce x86 vs ARM divergence in parametric simplex solver
- **Notes**: May require deterministic pivot tiebreaking

### 3. Bug Fixes (see `.AI/plans/bug-fixes.md`)
- **Priority**: Critical/High
- **Description**: Comprehensive bug fixing based on parallel oracle analysis
- **Bugs**: 20+ bugs identified across C memory safety, R code, numerical precision, tests

## Completed

### 1. Memory Leak Fix
- **Completed**: 2026-04-07
- **Description**: Fixed `free(): invalid pointer` in dantzig.c
- **Files**: `src/dantzig.c`

### 2. CLIME_CVXR Verification (2026-04-07)
- **Completed**: 2026-04-07
- **Description**: Verified CLIME_CVXR works with CVXR 1.8.1, fixed API changes
- **Fixes**: Variable(rows=n) → Variable(n), added symmetrization, default solver SCS
- **Files**: `scratch/CLIME_CVXR.R`
