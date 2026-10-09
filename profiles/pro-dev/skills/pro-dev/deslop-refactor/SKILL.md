---
name: deslop-refactor
description: Use when pruning bloated abstractions, eliminating dead code, and cleaning AI-generated slop.
---

# Deslop Refactor: Complexity Pruning

AI models tend to overcomplicate code: adding redundant layers, single-use utility wrappers, and speculative configuration.

## Deslop Checklist
1. **Collapse Shallow Modules:** Merge classes/functions that merely pass arguments through.
2. **Delete Dead Code:** Remove orphaned imports, unused helpers, and obsolete types.
3. **Strip Speculative Flexibility:** Remove unrequested config options, plugin interfaces, and unused generics.
4. **Enforce Deep Interfaces:** Keep interface simple, hide complex implementation logic inside.
5. **Verify No Regression:** Ensure full test suite passes after pruning.
