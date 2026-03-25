## 2024-05-19 - Removed unnecessary Depends in fastclime

**Learning:** Packages in `Depends` attach libraries to the R search path and alter the global environment compared to `Imports`. If functions from external dependencies are simply called using explicit namespaces (e.g., `Matrix::Matrix()`), the dependency can be safely moved to `Imports`. However, changing from `Depends` to `Imports` can subtly shift how R initializes its session, leading to changes in deterministic random number generator (RNG) outputs following `set.seed()`.

**Action:** Whenever converting `Depends` to `Imports`, explicitly check if tests use hardcoded values based on `set.seed()`. If so, those tests might fail because the RNG sequence shifted. Always use explicit namespacing like `pkg::function()` and remember to update the test suite's hardcoded values as needed. Also, remember to export those imported functions correctly using `importFrom` in the `NAMESPACE` file.
