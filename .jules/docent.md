## 2026-05-16 - Math equations and Line wrapping
**Learning:** Using `\eqn{}` for math equations improves professional presentation of documentation, and when combined with breaking sentences into multiple lines, ensures maintainability.
**Action:** Always check the documentation files (`man/*.Rd`) for raw ASCII equations inside `\code{}` or text, and convert them to proper LaTeX syntax `\eqn{}` while keeping line lengths reasonable and one sentence per line.
