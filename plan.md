1. Modify `src/dantzig.c` to move the `CALLOC` of `output_vec` outside the main loop to improve performance (avoids repeated heap allocation/deallocation overhead) and fix potential memory leaks on early exit (e.g. `break` before `FREE`). Use `memset` to zero it out at the start of each iteration.
2. Modify `src/parametric.c` to move the `CALLOC` of `output_vec` outside the main loop similarly, replacing the inside-loop allocation with `memset`, and add `FREE(output_vec)` at the end of the function `solver2`.
3. Add `#include <string.h>` to both files.
4. Run `R CMD check .` to verify changes (after installing dependencies).
5. Document the performance learning in `.jules/bolt.md`.
6. Complete pre commit steps to make sure proper testing, verifications, reviews and reflections are done.
7. Submit the PR with descriptive title and description.
