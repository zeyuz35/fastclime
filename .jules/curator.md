## 2025-04-29 - fastclime strips attributes and crashes on isSymmetric

**Learning:** When passing `xts` or `zoo` objects into basic matrix processing functions that rely on `isSymmetric`, S3 dispatch fails because there is no applicable method for `isSymmetric` on these classes.

**Action:** Extract numeric representation explicitly with `unname(as.matrix(x))` prior to matrix validation/calculations while ensuring the original object (with attributes) is retained for the final returned payload.
