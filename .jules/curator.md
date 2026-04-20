
## 2024-04-20 - isSymmetric fails on time-series objects

**Learning:** Base R function `isSymmetric()` lacks applicable methods for time-series objects like `zoo` or `xts` and will throw an error rather than checking the underlying numeric matrix. Simply unclassing is insufficient as it drops the matrix structure.

**Action:** When checking symmetry for these inputs, safely coerce them first using `as.matrix(x)` before calling `isSymmetric()`, preserving the original object containing its attributes for downstream output.
