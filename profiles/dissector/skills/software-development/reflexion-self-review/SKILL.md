---
name: reflexion-self-review
description: Self-review deliverables against acceptance criteria.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [self-review, verification, acceptance-criteria]
    related_skills: [systematic-debugging, test-driven-development]
---

# Reflexion and self-review

Apply a final independent critique before declaring work complete. Check the requested behavior, changed artifacts, evidence, scope, and known failure modes. If a criterion fails, modify the artifact and repeat verification rather than reporting completion.

## When to Use

- Any build, coding, configuration, or artifact task with acceptance criteria.
- Before handing work to a user or a downstream reviewer.

## Procedure

1. Write the acceptance criteria as a checklist.
2. Map each criterion to a concrete file, behavior, or command result.
3. Inspect the final artifact cold, without relying on the implementation summary.
4. Run the focused verification and relevant regression checks.
5. Record defects and fix them one at a time.
6. Repeat the review until every criterion has evidence or state the exact blocker.

## Pitfalls

- A passing unit test does not prove all acceptance criteria.
- Agent summaries are claims, not evidence.
- Do not hide unresolved failures behind a positive summary.

## Verification

Completion requires every criterion to have a concrete evidence reference and no unreported test or build failure.
