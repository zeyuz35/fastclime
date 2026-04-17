
## 2024-05-24 - [isSymmetric fails on zoo/xts objects]

**Learning:** Base R's `isSymmetric()` lacks applicable S3 methods for time-series objects like `zoo` or `xts`, leading to an error when it tries to check their symmetry directly.

**Action:** Before checking symmetry on potentially time-series inputs, safely coerce them first using `isSymmetric(unclass(x))` or `isSymmetric(as.matrix(x))` to avoid crashing.
