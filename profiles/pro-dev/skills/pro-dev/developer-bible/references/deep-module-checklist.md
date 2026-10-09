# Deep Module Checklist (Ousterhout Doctrine)

A deep module provides powerful functionality through a simple, cohesive interface. A shallow module has an interface that is complex relative to the functionality it provides.

## 1. Interface Simplicity
- Does the interface expose only what callers need to achieve their goal?
- Are internal implementation details, data structures, and helper types hidden?
- Can a caller use the module correctly with fewer than 3 concepts in their head?

## 2. Cohesion
- Does every function in the module directly serve the module's core purpose?
- If functionality changes, is only this module touched?
- Are orthogonal concerns cleanly separated?

## 3. Information Hiding
- Are configuration parameters minimized to only what callers must specify?
- Are internal state transitions invisible to the outside?
- Is error handling localized instead of bubbling raw internal exceptions?

## 4. Anti-Shallow Rules
- BANNED: Pass-through classes that merely wrap another class without transforming semantics.
- BANNED: 10-line files created solely to satisfy arbitrary file-length linters.
- RULE: If 200 lines across 5 files can be written as 50 cohesive lines in 1 file, collapse it immediately.
