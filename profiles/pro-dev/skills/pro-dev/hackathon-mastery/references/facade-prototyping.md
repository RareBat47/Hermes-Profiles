# Facade Prototyping (Google Ventures Sprint Doctrine)

Goldilocks quality: make the prototype feel 100% real on the demo path without building 100% of the backend.

## Rules of the Facade
1. **The Happy Path is Sacred:** The exact user flow demonstrated on stage must execute with real code, clean UI transitions, and zero visual glitches.
2. **Mock the Perimeter:** Secondary routes, edge error dialogs, and non-core settings can return deterministic stub data.
3. **No Loading Spinners without Feedback:** If an AI step takes 3 seconds, show an animated progress step ('Analyzing AST...', 'Synthesizing report...'), never a dead freeze.
