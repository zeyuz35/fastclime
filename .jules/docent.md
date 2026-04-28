## 2026-04-09 - Convert ASCII math to LaTeX in documentation

**Learning:** When converting ASCII math equations to LaTeX syntax (`\eqn{}`) in `.Rd` files, standard strings like `"maximize obj*x, subject to: mat*x<=rhs, x>=0"` need their mathematical operators explicitly escaped and wrapped. Additionally, formatting limits (80 chars per line and one sentence per line) must still be respected by splitting the LaTeX chunks and sentence structures across newlines within the `\details` or `\note` blocks.

**Action:** Before running `devtools::document()` or manually writing `.Rd` changes, ensure mathematically rich sentences are broken into multiple lines to prevent >80 character warnings, particularly when converting to the more verbose `\eqn{...}` syntax.
