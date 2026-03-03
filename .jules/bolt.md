## 2024-05-18 - Optimizing array allocation inside simplex loops
**Learning:**
I investigated moving memory allocation (`CALLOC`) out of the parametric solver loop in `src/dantzig.c` and `src/parametric.c`. By replacing `CALLOC` inside the loop with `memset` on an array allocated outside the loop, we eliminate the overhead of thousands of heap allocations and deallocations while preventing memory leaks from early returns.

**Action:**
When iterating simplex methods where a temporary buffer must be reset each loop step (e.g., `output_vec`), prefer allocating the buffer once before the loop and using `memset` to zero it out rather than re-allocating inside the loop. This follows the codebase's preferred architectural pattern for memory management.
