# fastclime

A rewrite of the original `fastclime` package with a focus on thread and memory safety. 
The original `fastclime` package relied on many custom memory macros and pointer operations which made it extremely error prone. 

This rewrite acts as a drop-in replacement with improved safety guarantees, with the core routines being rewritten. 
It additionally provides two additional CLIME variants. 

```r
remotes::install_github("zeyuz35/fastclime@dev")
```

## Cross-Platform Note

Due to the nature of the parametric simplex algorithm — which makes discrete pivot decisions at each iteration — different CPU architectures (x86 vs ARM) can produce up to ~20% divergence in any individual solution along the regularization path. 
This is expected behavior: both solutions are mathematically valid CLIME estimates, they simply converge along different valid trajectories.
