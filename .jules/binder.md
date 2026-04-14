## 2024-04-14 - Dependency reduction

**Learning:** Moving base packages like MASS, Matrix, igraph from Depends to Imports helps minimize environment clutter, especially since standard package functions like S3 method dispatches (e.g., plot.igraph) don't require the package to be Attached, merely loaded (which Imports satisfies).

**Action:** Identify and shift bulky dependencies from `Depends` to `Imports` in the DESCRIPTION file, verifying functionality through tests.
