## 2024-11-05 - Shifting Dependencies Alters RNG Sequences
**Learning:** Shifting dependencies from Depends to Imports alters whether packages are attached to the global search path or merely loaded, which shifts the R session's initialization sequence and RNG outputs.
**Action:** Always verify test assertions and expect hardcoded values dependent on RNG to change when moving dependencies.
