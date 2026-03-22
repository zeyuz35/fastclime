## 2024-03-22 - Missing Input Validation Leading to C Extension Crashes
**Vulnerability:** Core functions (fastclime, dantzig, fastlp, paralp) did not validate inputs for NULL, NA, or non-numeric types before passing them to C extensions via .C(), leading to fatal R session crashes.
**Learning:** R does not natively type-check or validate inputs before .C() calls, meaning invalid memory accesses or non-finite values can cause silent failures or abort the entire R process.
**Prevention:** Always use explicit stopifnot(!is.null(x), length(x) > 0, is.numeric(as.matrix(x)), !anyNA(as.matrix(x))) to sanitize inputs before any foreign function calls in R.
