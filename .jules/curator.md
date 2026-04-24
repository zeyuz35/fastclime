
## 2026-04-24 - S3 Dispatch and Attribute Loss on Time-Series

**Learning:** Base functions like `isSymmetric()` lack applicable methods for time-series objects (`ts`, `xts`, `zoo`) and will crash. Coercing to a matrix bypasses the crash, but if the symmetry check also relies on `dimnames`, objects like `xts` might fail exact symmetry because they assign time indices as rownames. Additionally, returning the intermediate matrix silently drops the input's class and attributes.

**Action:** Always coerce to a bare matrix (`as.matrix(x)`) and strip dimnames (`unname()`) for pure mathematical checks like symmetry. Then, explicitly restore the original object (`x`) with its attributes to the output variable if the data has not been modified.
