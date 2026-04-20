
## 2024-04-20 - Package Hygiene: S4 Dispatch Needs

**Learning:** When shifting dependencies from `Depends` to `Imports` and removing global `import()` directives from `NAMESPACE`, S4 dispatch packages like `Matrix` must be handled differently than generic utility packages like `igraph` or `MASS`. Packages heavily reliant on S4 dispatch for basic operators (like `%*%` or `+`) often still require their `import()` directive in `NAMESPACE` to prevent silent mathematical regressions.

**Action:** Before shifting packages out of `Depends`, identify if they use extensive S4 dispatch for common operators. Explicitly namespace standard packages but leave S4-heavy packages in `NAMESPACE` `import()` directives when operators are required.
