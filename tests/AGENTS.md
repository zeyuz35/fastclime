# tests/ — Test Suite

## Running Tests

```bash
devtools::test()                       # All tests
devtools::test(filter = "cvxr")        # CVXR ground truth tests
devtools::test(filter = "memory")     # Memory regression tests
R CMD check --as-cran .               # Full check
```

## Test Tolerances

| Check | Tolerance |
|-------|-----------|
| Diagonal values | `0.2` |
| Numerical results | `1e-6` |
| Matrix symmetry | `1e-12` |

## Key Fixtures

- `stockdata` — built-in dataset: `dim=c(1258, 452)`, `info` length=1356
- `fastclime.generator()`, `dantzig.generator()` — synthetic data generators

## Test Files

### test-memory.R

Verifies `free(): invalid pointer` regression is fixed. Previously, repeated invocations of fastclime on the same data triggered a memory bug in link pointer cleanup. The test runs fastclime twice on identical data and asserts no crash occurs.

### test-fastclime-core.R

Tests print/plot methods, fastclime.selector functionality, and parametric solver on identity covariance.

### test-cvxr-parity.R

Ground truth tests verifying fastclime C implementation produces results consistent with CVXR reference implementation. See `setup.R` for CVXR functions.

**Tolerances:**
- Frobenius relative error < 0.15
- Correlation > 0.95

## Notes

- Uses testthat edition 3
- CVXR ground truth functions live in `setup.R`
- CV wrapper testing via `scratch/` scripts, not unit tests
