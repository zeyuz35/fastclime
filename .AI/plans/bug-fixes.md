# Bug Fix Plan

## Overview

Comprehensive bug fixing based on parallel oracle analysis across C memory safety, R code, numerical precision, and test coverage.

**Verification Protocol**: All C code changes MUST be verified against CVXR ground truth in `scratch/CLIME_CVXR.R`.

---

## Phase 1: Critical Memory Safety (Immediate)

### 1.1 Uninitialized `link[-1]` — `src/linalg.c:171`

**Problem**: In `Nt_times_y`, first iteration accesses `link[-1]` which may be uninitialized.

**Fix**:
```c
// Before loop that accesses link[jj] where jj starts at -1
link[0] = n;  // Initialize head of linked list
```

**Status**: OPEN

---

### 1.2 Uninitialized `link[-1]` — `src/lu.c:977-983`

**Problem**: In `Gauss_Eta`, `link[ii]` where `ii=-1` is written before initialization.

**Fix**:
```c
ii = -1;
// Initialize link[0] before loop
link[0] = -1;
for (k=0; k<ndx_B; k++) {
    i = idx_B[k];
    a[i] = dx_B[k];
    tag[i] = currtag;
    link[ii] = i;   // Now link[0] exists
    ii = i;
}
```

**Status**: OPEN

---

## Phase 2: High Severity — REALLOC Failures

### 2.1 REALLOC leak (Bt[row2]) — `src/lu.c:431`

**Problem**: If `realloc()` fails, original pointer is lost and dereferenced.

**Fix**:
```c
VALIND *tmp = (VALIND *)realloc(Bt[row2], (deg+1) * sizeof(VALIND));
if (tmp == NULL) {
    // Handle error - Bt[row2] unchanged
} else {
    Bt[row2] = tmp;
    Bt[row2][deg].i = col2;
}
```

**Status**: OPEN

---

### 2.2 REALLOC leak (B[col2]) — `src/lu.c:452`

**Problem**: Same pattern as 2.1.

**Fix**: Same as 2.1 for `B[col2]`.

**Status**: OPEN

---

### 2.3 REALLOC leak (E/iE) — `src/lu.c:695-696`

**Problem**: Two consecutive REALLOCs without NULL check.

**Fix**:
```c
double *tmp_E = (double *)realloc(E, MAX(E_NZ, enz+ny) * sizeof(double));
if (tmp_E == NULL) {
    // Handle error
} else {
    E = tmp_E;
}
int *tmp_iE = (int *)realloc(iE, MAX(E_NZ, enz+ny) * sizeof(int));
if (tmp_iE == NULL) {
    // Handle error
} else {
    iE = tmp_iE;
}
```

**Status**: OPEN

---

## Phase 3: Critical — Division by Zero

### 3.1 Division by zero in dantzig.c — `src/dantzig.c:306-312`

**Problem**: `dx_B[k]` or `dy_N[k]` could be zero in pivot ratio test.

**Fix**:
```c
for (k=0; k<ndx_B; k++) if (idx_B[k] == col_out) break;
if (k < ndx_B && fabs(dx_B[k]) > DBL_MIN) {
    t    = x_B[col_out]/dx_B[k];
    tbar = xbar_B[col_out]/dx_B[k];
}
// Similar guard for dy_N[k]
```

**Status**: OPEN

---

### 3.2 Division by zero in fastlp.c — `src/fastlp.c:363-369`

**Problem**: Same pattern as dantzig.

**Fix**: Add same guards.

**Status**: OPEN

---

### 3.3 Division by zero in paralp.c — `src/paralp.c:372-378`

**Problem**: Same pattern.

**Fix**: Add same guards.

**Status**: OPEN

---

### 3.4 Division by zero in parametric.c — `src/parametric.c:370-376`

**Problem**: Same pattern.

**Fix**: Add same guards.

**Status**: OPEN

---

### 3.5 Division by zero in LU solve — `src/lu.c:662,779,914`

**Problem**: `diagU[i]` could be zero when rank < m.

**Fix**:
```c
// At bsolve (line 662), btsolve (line 779), dbsolve (line 914)
if (fabs(diagU[i]) < DBL_MIN) {
    beta = 0.0;  // or appropriate value for rank-deficient case
} else {
    beta = y[i]/diagU[i];
}
```

**Status**: OPEN

---

## Phase 4: R Code Bugs

### 4.1 Float equality `mat!=0` — `R/fastlp.R:95`, `R/paralp.R:101`

**Problem**: Using exact equality for floating-point comparison.

**Fix**:
```r
# Change:
if (mat[i*n+j] != 0) {
# To:
if (abs(mat[i*n+j]) > .Machine$double.eps^0.5) {
```

**Status**: OPEN

---

### 4.2 Magic number 1e-5 — `R/fastclime.selector.R:19`

**Problem**: Hardcoded tolerance with no explanation.

**Fix**: Either document why 1e-5 is appropriate or make it a parameter.

**Status**: OPEN

---

### 4.3 Magic number 1e-5 — `R/fastclime.R:132`

**Problem**: Same issue.

**Fix**: Same as 4.2.

**Status**: OPEN

---

## Phase 5: Test Coverage

### 5.1 dantzig.selector() has NO tests — Critical

**Fix**: Add comprehensive test covering basic functionality and error paths.

### 5.2 NA/Inf validation not tested — High

**Fix**: Add error path tests for all main functions.

### 5.3 Weak diagonal tolerance (0.2) — Medium

**Fix**: Tighten to 0.05 or 0.1 after verification.

---

## Execution Order

1. Fix uninitialized memory (1.1, 1.2) — critical safety
2. Fix REALLOC leaks (2.1, 2.2, 2.3) — memory safety
3. Fix division by zero (3.1-3.5) — numerical stability
4. Fix R code bugs (4.1-4.3)
5. Add test coverage (5.1-5.3)

---

## Verification After Each Fix

1. Run `devtools::test()`
2. Compare fastclime output against CVXR ground truth
3. Frobenius relative error < 0.1, correlation > 0.95

---

## Status: IN PROGRESS