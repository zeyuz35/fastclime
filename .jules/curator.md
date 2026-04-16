## 2024-05-15 - [fastclime() class destruction for time-series]

**Learning:** `fastclime()` fails for time-series objects like `zoo` and `xts` because it calls `isSymmetric()` on them, which does not have an applicable method for these classes. Furthermore, simply applying `as.matrix()` inside the function destroys the original object attributes and class in the return value `result$data`, dropping the original time indices.

**Action:** Capture the original data into `orig_x <- x` before coercing the input to a matrix with `x <- as.matrix(x)` for inputs inheriting from `"ts"`, `"xts"`, `"zoo"`, or `"mts"`. Then, return the preserved `orig_x` in `result$data` instead of the coerced matrix to guarantee data and attribute preservation for downstream methods.
