## 2024-05-24 - [isSymmetric fails on xts/zoo time-series objects]
**Learning:** In R, base functions like `isSymmetric()` lack applicable methods for time-series objects like `zoo` or `xts`. When checking symmetry on these objects, it causes a fatal error.
**Action:** Calculate symmetry using a localized coercion (e.g., `isSymmetric(as.matrix(x))`) rather than globally reassigning the variable. This avoids the error while keeping the original object and its time-series attributes intact.
