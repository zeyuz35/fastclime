## 2026-05-17 - LaTeX Conversion in Rd files
**Learning:** When converting ASCII math equations to LaTeX syntax (`\eqn{}`) in R package `.Rd` files, you must ensure mathematically rich sentences are broken into multiple lines to avoid exceeding 80-character limits and breaking one-sentence-per-line rules.
**Action:** Use multiple lines for complex sentences, separating parts containing `\eqn{}` for better readability and avoiding the limit.
