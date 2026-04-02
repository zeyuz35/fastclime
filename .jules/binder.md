## 2025-04-02 - RNG shifts from Depends to Imports

**Learning:** Shifting dependencies (like igraph and MASS) from Depends to Imports alters the R session's initialization sequence, which can subtly shift deterministic random number generator (RNG) outputs following set.seed().

**Action:** When performing such hygiene migrations, expect hardcoded test values relying on RNG to fail and explicitly update them to reflect the new deterministic sequence using tools like dput().
