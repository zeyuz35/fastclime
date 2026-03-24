## 2024-03-24 - explicit namespacing changes RNG sequence
**Learning:** In R packages, shifting dependencies from `Depends` to `Imports` alters whether packages are attached to the global search path or merely loaded. This structural change can alter the R session's initialization sequence and subtly shift deterministic random number generator (RNG) outputs following `set.seed()`.
**Action:** When performing such hygiene migrations, expect hardcoded test values relying on RNG to fail and update them to reflect the new deterministic sequence.
