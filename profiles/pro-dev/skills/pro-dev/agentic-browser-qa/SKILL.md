---
name: agentic-browser-qa
description: Use when verifying web applications, running live UI flows, and catching regressions in the browser.
---

# Agentic Browser QA (Real Browser Verification)

Unit tests only prove logic in isolation. A web feature is not done until verified in a real browser.

## Browser QA Protocol
1. Launch local web server (Next.js, Vite, FastAPI, Flask).
2. Use Hermes native browser_exec to navigate to target URL.
3. Inspect DOM with page_info() and query selectors.
4. Execute user journey: fill forms, click buttons, trigger API flows.
5. Capture screenshot and check console logs for unhandled errors.
6. Verify responsive layout and visual sanity.
7. Record findings in VERIFICATION.md.
