---
name: outreach-automation
description: Plan consent-aware lead outreach and follow-ups.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [outreach, leads, crm, follow-up]
    related_skills: [composio-cli, reflexion-self-review]
---

# Outreach automation

Build a reviewable pipeline for lead validation, personalized draft generation, follow-up scheduling, and outcome tracking. Keep sending behind explicit approval and respect applicable consent, opt-out, and platform rules.

## Procedure

1. Define the lead source, permitted use, fields, and deduplication key.
2. Validate contact data and record provenance and consent status.
3. Draft messages from verified facts; never invent personalization.
4. Queue drafts for human approval before any outbound send.
5. Schedule follow-ups only for eligible contacts and stop on reply, bounce, or opt-out.
6. Record message IDs, timestamps, status, and failures in the CRM.
7. Review delivery and opt-out metrics without exposing unnecessary personal data.

## Pitfalls

- Do not scrape or contact people where consent or applicable law forbids it.
- Never send automatically from an unverified list.
- Treat CRM data and generated copy as sensitive.

## Verification

Before sending, every record has provenance, eligibility, a valid address, an approved draft, and an auditable stop condition.
