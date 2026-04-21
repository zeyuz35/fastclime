
## 2025-04-21 - isSymmetric S3 Dispatch Failure for xts/zoo

**Learning:** Base R `isSymmetric()` lacks applicable methods for time-series objects like `zoo` or `xts` and will throw an error even if they are valid numeric matrices.
**Action:** When checking symmetry for these inputs, safely coerce them first using `as.matrix(x)` (e.g., `isSymmetric(as.matrix(x))`) to prevent S3 dispatch failures while preserving the original object's attributes for return values.
