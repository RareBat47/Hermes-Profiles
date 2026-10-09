# The Confusion & Ambiguity Protocol

Models hallucinate when they encounter unstated requirements or ambiguous contracts and guess silently.

## The Protocol Rules
1. **The Stop Condition:** If an API contract, database schema, or requirement has more than one plausible interpretation, STOP immediately.
2. **Surface Trade-offs:** State the 2-3 interpretations clearly with pros and cons.
3. **Make a Concrete Recommendation:** Put the recommended option first.
4. **Wait for Clarification:** Do not generate code based on a gamble.
