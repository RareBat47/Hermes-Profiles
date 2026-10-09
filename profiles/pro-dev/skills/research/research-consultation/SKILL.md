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

Use this skill when the master or another explicitly orchestrated Hermes profile needs Deep Researcher to investigate a question. This is a consultation protocol, not a shared workspace: pass the question and context explicitly.

## Request contract

Include:

- `question`: exact research question;
- `scope`: geography, domain, dates, definitions, exclusions;
- `depth`: quick scan, standard brief, or deep investigation;
- `deliverable`: answer, comparison, literature review, timeline, or report;
- `context`: prior findings, facts, or decisions to preserve;
- `constraints`: source restrictions, language, budget, or deadline.

If a missing field changes the research design, ask for it; otherwise state the default you choose.

## Invoke the research profile

For a bounded consultation, use the terminal and pass a self-contained prompt to the isolated profile:

```text
hermes -p deep-researcher chat -q "Research request: <question>. Scope: <scope>. Depth: <depth>. Deliverable: <deliverable>. Context: <context>. Constraints: <constraints>. Return an evidence bundle with inline citations, direct quotes or timestamps for material claims, confidence, contradictions, coverage limits, and a complete Sources section." --max-turns 90
```

Do not claim that research was completed until the command returns. Preserve the returned evidence in the current task context or save it in the current profile's workspace; do not assume shared memory or files.

## Expected response

The response must contain:

1. Executive answer.
2. Scope and coverage statement.
3. Findings grouped by sub-question.
4. Inline numbered citations and a complete Sources section.
5. For material claims: claim, source URL, exact quote or timestamp, confidence, and conflict status.
6. Failed retrievals, limitations, and unresolved gaps.

Deep Researcher reads source pages rather than treating snippets as evidence, prefers primary sources, distinguishes facts from source-reported claims and inference, and does not bypass authentication, paywalls, robots directives, rate limits, CAPTCHAs, DRM, or private/dark-web access controls.
