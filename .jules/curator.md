## 2024-05-04 - isSymmetric S3 Dispatch Fails on Time-Series Attributes

**Learning:** S3 dispatch for `isSymmetric()` fails natively on time-series objects like `zoo` and `xts`. Even after stripping the time-series class via `as.matrix()`, `zoo` matrices retain a row-level `index` attribute that prevents `isSymmetric()` from succeeding (it expects symmetric `dimnames` but `zoo` forces non-symmetric row attributes).

**Action:** When evaluating matrix symmetry on time-series or highly attributed matrices, use `isSymmetric(unname(as.matrix(x)))` to safely check the numeric matrix structure while bypassing both S3 dispatch errors and metadata dimension mismatches. Never overwrite the original object `x` with this stripped matrix to preserve the metadata for subsequent outputs.
