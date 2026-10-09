---
name: research-consultation
description: Use when another Hermes profile needs evidence-backed web research.
version: 1.0.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [research, evidence, citations, profiles, orchestration]
    related_skills: [grounded-citations, youtube-content, arxiv]
---

# Research Consultation

Use this skill when the master or another explicitly orchestrated Hermes profile asks this profile for research. This is a consultation protocol, not a second shared workspace: the requesting profile must pass the question, scope, time window, audience, depth, constraints, and any context it wants preserved.

## Request contract

A good request includes:

- `question`: the exact research question;
- `scope`: geography, domain, dates, definitions, exclusions;
- `depth`: quick scan, standard brief, or deep investigation;
- `deliverable`: answer, comparison, literature review, timeline, or report;
- `context`: facts, prior findings, or decisions to preserve;
- `constraints`: source restrictions, language, budget, or deadline.

If a missing field changes the research design, ask for it; otherwise choose a reasonable default and state it.

## Response contract

Return an evidence bundle in this order:

1. Short answer or executive finding.
2. Research scope and coverage statement.
3. Findings grouped by sub-question.
4. Inline numbered citations.
5. Evidence ledger for material claims: claim, source URL, exact quote or timestamp, confidence, and conflict status.
6. Limitations, failed retrievals, and unresolved gaps.
7. A complete Sources section.

Read source pages rather than treating search snippets as evidence. Prefer primary sources, separate source-reported claims from verified facts and inference, and disclose when sources are duplicated or contradictory. Never invent URLs, quotations, timestamps, or confidence.

## Cross-profile handoff

The requester should invoke this profile explicitly with `hermes -p deep-researcher chat -q` or use an approved Hermes orchestration route. Do not assume shared memory or filesystem access. If a report is written, return its absolute path and citations; do not silently write into another profile's workspace.
