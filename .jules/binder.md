## 2026-03-23 - Explicit Namespacing and Dependency Shift

**Learning:** Moving dependencies from `Depends` to `Imports` alters whether packages are attached to the global search path or merely loaded, reducing namespace collisions but shifting the deterministic random number generator (RNG) outputs following `set.seed()`. Explicitly using `pkg::func()` prevents namespace pollution.

**Action:** Always prefer `Imports` over `Depends` to minimize global environment pollution, use explicit `::` for external functions, and prepare for potential test value shifts dependent on RNG sequences when transitioning between the two.
