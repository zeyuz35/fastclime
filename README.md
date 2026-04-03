# fastclime

Fork of fastclime to fix memory issues. 

## Memory Leak Fix

The fix addresses a memory leak in the `dantzig` solver function in `src/dantzig.c`.
`output_vec` was being allocated via `CALLOC` inside the lambda path iteration loop but was not being freed in previous versions, causing memory usage to grow with the number of lambda steps.
The fix involves explicitly freeing `output_vec` at the end of each iteration.

## Cross-Platform Note

Due to the nature of the parametric simplex algorithm — which makes discrete pivot decisions at each iteration — different CPU architectures (x86 vs ARM) can produce up to ~20% divergence in any individual solution along the regularization path. This is expected behavior: both solutions are mathematically valid CLIME estimates, they simply converge along different valid trajectories.
