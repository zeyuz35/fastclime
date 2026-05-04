## 2026-05-04 - LaTeX Math and Roxygen Formatting

**Learning:** Mathematical formulas in `.Rd` files must use LaTeX notation via `\eqn{}` or `\deqn{}` instead of raw ASCII text to ensure proper rendering and professional presentation. Also, `\code{}` should be used for variables and arguments.

**Action:** When reviewing documentation, convert inline ASCII math like `length n` to `length \eqn{n}`, matrix dimensions like `m*n` to `\eqn{m \times n}`, and block equations like `"maximize obj*x, subject to: mat*x<=rhs, x>=0"` to `\deqn{\mathrm{maximize}\ obj \times x, \quad \mathrm{subject\ to:}\ mat \times x \le rhs, \quad x \ge 0}`.
