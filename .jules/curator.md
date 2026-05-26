## 2026-05-26 - Preserve Metadata Across C Wrappers in fastclime

**Learning:** When rebuilding matrices/arrays from C wrappers using `.C()`, core metadata such as `colnames()` and `rownames()` is systematically dropped. This is seen in paths like `fastclime()` and `dantzig()`. Furthermore, selector functions (like `fastclime.selector()`) that rebuild results based on these outputs also fail to retain these attributes.
**Action:** Always capture `colnames()` and `rownames()` before passing data to the C layer, and explicitly repopulate them onto the relevant output structures (`lambdamtx`, `icovlist`, `BETA0`, `icov`, `adaj`) before returning.
