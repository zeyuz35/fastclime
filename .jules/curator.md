## 2024-03-25 - isSymmetric method dispatch failure on xts/zoo

**Learning:** `isSymmetric()` lacks applicable methods for `xts` and `zoo` objects, causing hard crashes when checking if an input is a covariance matrix. Furthermore, `isSymmetric()` strictly compares `dimnames`, so pure numeric checks may yield false negatives if `dimnames` are asymmetric.
**Action:** Explicitly coerce to an unnamed matrix using `isSymmetric(unname(as.matrix(x)))` before evaluating symmetry to prevent method dispatch failures and false negatives.
