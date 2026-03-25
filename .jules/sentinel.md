## 2025-02-23 - Missing input validation in C interface functions
**Vulnerability:** Core functions (`fastlp`, `paralp`, `fastclime`, `dantzig`) lacked input validation before sending data to C, leading to silent failures or native crashes (`NA/NaN/Inf in foreign function call`) when given missing, null, or invalid data types.
**Learning:** Functions communicating with C layer must always validate inputs on the R level using `stopifnot()` or similar explicitly checking for `!is.null`, `is.numeric`, and `!anyNA` since `.C` calls are not resilient to unstructured R data.
**Prevention:** Always sanitize inputs directly facing `.C` bindings in R to ensure only well-formed numeric arrays are propagated downstream.
