# R/ — R Source Code

## Key Functions

- `fastclime()` — main solver, auto-detects data vs covariance matrix by symmetry
- `fastclime.selector()` — selects solution path for given lambda
- `dantzig()`, `dantzig.generator()`, `dantzig.selector()` — Dantzig selector
- `fastlp()`, `paralp()` — LP solvers
- `fastclime.generator()` — synthetic data, supports `graph` param: "random", "band", "cluster", "hub"

## Conventions

- Use roxygen2 for documentation
- Export only via NAMESPACE (roxygen handles this)
- S3 methods: `print.fastclime`, `plot.fastclime`, `print.sim`, `plot.sim`
- Matrix input: `fastclime()` accepts n×d data matrix OR d×d covariance matrix
- `fastclime.selector()` uses `as.matrix()` internally to handle single-row lambdamtx

## Gotchas

- Do not use `pryr` for memory profiling — use `rlang`, `lobstr`, `sloop`
- Set `vis=FALSE` when using generators in tests to suppress plots
- When adding exports: add roxygen `@export` tag → run `roxygen2::roxygenize()`
