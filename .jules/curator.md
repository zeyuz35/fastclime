
## 2025-04-25 - xts dispatch and constraint construction failure
**Learning:** `xts` overrides basic `rbind()` operations such that `rbind(Sigma, -Sigma)` or similar constraint matrices can fail severely due to ambiguity in POSIX time index dispatch logic when one part drops time indices but inherits the class structure, and `isSymmetric()` crashes because `xts`/`zoo` objects don't support base R's array/matrix dispatch correctly without `as.matrix()` stripping.
**Action:** Always capture `attributes(X)` first, and cast time-series data to raw numerical components using `unname(as.matrix(X))` prior to creating internal constraint matrices or symmetry checks to completely prevent S3 failures, and selectively restore `dimnames` just before return.
