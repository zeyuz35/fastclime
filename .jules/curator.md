## 2024-05-16 - Prevent metadata loss during R to C arrays conversion

**Learning:** When passing R objects like matrices to C subroutines via the `.C()` interface, R strips S3 class attributes and dimension names (metadata) when returning and rebuilding the objects from the generic list structure. Similarly, certain checks like `isSymmetric()` lack applicable methods for rich objects like `xts`.

**Action:** Explicitly capture metadata (like `colnames` and `rownames`) before the `.C()` call, and immediately re-assign them to the rebuilt arrays upon returning from the C layer to preserve data integrity and prevent silent attribute loss. For symmetry checks, coercing localized inputs using `isSymmetric(as.matrix(x))` preserves the type consistency of the overall function.
