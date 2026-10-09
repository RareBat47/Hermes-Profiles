---
name: research-profile-design
description: "Use when designing a Hermes profile for deep web research."
version: 1.0.0
category: autonomous-ai-agents
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [Hermes, Profiles, Research, Web, Citations]
    related_skills: [profile-generator, grounded-citations, hermes-agent]
---

# Research Profile Design

## When to Use

Use when a user wants a separate Hermes profile for deep, multi-source web
research, especially when they mention GitHub research agents, citations,
YouTube, academic sources, crawling, or “the whole internet.”

Design a separate Hermes research profile without turning the request into an
unapproved platform build. The profile is the deliverable; GitHub repositories
are optional implementation references.

## Always-on rules

- Start with the profile boundary: role, outputs, research surfaces, and
  interactive versus scheduled use. Do not begin with a repository catalogue.
- Keep the design proportional. A user asking for a deep-research profile is
  not automatically asking for a new crawler, search engine, vector database,
  or multi-agent platform.
- Use existing Hermes capabilities as the baseline: web search/extraction,
  browser access, citation discipline, YouTube transcription, academic lookup,
  and profile isolation. Add external projects only where a concrete capability
  is missing.
- Treat “deep research” as a workflow: question decomposition, broad source
  discovery, actual page retrieval, source-quality assessment, cross-checking,
  claim-level evidence, synthesis, and explicit gaps/uncertainty.
- Do not promise “the whole internet.” State the practical boundary: broad
  public-web coverage subject to indexing, robots rules, rate limits, paywalls,
  authentication, language coverage, and source availability.
- Do not create, install, configure, or modify a profile until the user has
  approved the proposed profile design. This approval gate applies even when
  the intended change appears to be only a profile and SOUL file.
- If repository research is requested before approval, present it as a shortlist
  supporting the design. Do not let a long list replace the profile proposal.
- State the operation status plainly. If only discovery/design happened, say:
  “No profile has been created or modified; this was a design/research pass.”
- For this user, make the first response direct and legible: one recommended
  profile, its responsibilities, its exclusions, the minimum integrations, and
  the approval question. Put an optional repository appendix after that.
- Preserve profile isolation: a new profile owns its own workspace, sessions,
  memory, skills, configuration, and credentials. Do not copy messaging tokens
  or live state from another profile.

## Procedure

1. **Classify the request.** Decide whether the user wants profile design,
   profile implementation, or a research-platform build. If ambiguous, default
   to profile design and ask only the question that changes the boundary.
2. **Define the role.** Write one sentence describing what the profile owns,
   for example: “Conducts multi-source public-web research and produces
   citation-backed reports.” Define non-ownership explicitly: it does not
   build a general crawler platform, bypass access controls, or claim exhaustive
   internet coverage.
3. **Define the deliverable.** Default to a structured Markdown report with
   executive answer, methodology, findings, source-quality notes, inline
   citations, evidence excerpts for important claims, contradictions,
   confidence, and unanswered questions. Ask if the user needs another format.
4. **Choose the minimum workflow.** Use search → fetch/read → extract evidence
   → cross-check → synthesize → verify citations. Add YouTube and scholarly
   branches when relevant to the question, not as mandatory infrastructure for
   every task.
5. **Run the collision check.** Inspect `hermes profile list`, then each
   existing profile’s description/SOUL and workspace. Ensure the proposed role,
   name, ownership verbs, and workspace do not collide.
6. **Survey external projects only when useful.** Group candidates by role:
   research workflow, search/extraction, browser traversal, video/transcripts,
   scholarly retrieval, evidence verification, archives, and storage. Check the
   repository README, current status, license, integration surface, and
   maintenance before recommending one. Do not recommend installing every
   project in a category.
7. **Present the design before action.** Show the proposed profile name,
   ownership, method, report contract, tool/integration choices, boundaries,
   isolation plan, and verification steps. Ask for explicit approval.
8. **After approval, implement narrowly.** Create the profile with its isolated
   home and role description; write its SOUL from evidence rules; configure only
   the approved integrations; keep secrets in the profile `.env`; mirror the
   required home skill set according to the profile policy.
9. **Verify independently.** Check profile listing, SOUL existence, profile-local
   `terminal.cwd`, model/provider resolution, MCP/process connectivity, and a
   role-matching smoke query. Report installed, missing, unverified, and
   credential-dependent components separately.

## Evidence and repository-review rules

- Prefer official repository pages and READMEs, GitHub API metadata, and official
  Hermes documentation. Treat search snippets as discovery only; read the source
  page before making a capability claim.
- Record candidate URLs as soon as they are retrieved when producing a sourced
  recommendation. Use the grounded-citations ledger rather than hand-typing a
  Sources block.
- Separate “research workflow” from “infrastructure”: STORM, GPT Researcher,
  MiroFlow, or similar can inform the SOP; SearXNG, Firecrawl, Crawl4AI, or
  Browser Use are retrieval options; YouTube and academic tools are source
  branches; claim-verification tools are quality gates. They are not one required
  stack.
- Check repository freshness and license before recommending adoption. A popular
  project may be archived, renamed, experimental, or mismatched to Hermes.
- If an external project is optional, label it optional. If it is not actually
  tested in the current profile, label it unverified rather than ready.

## Common pitfalls

- **Do not lead with a giant GitHub list — it hides the requested profile
  boundary and forces the user to infer the architecture.** Lead with the
  profile proposal; attach a shortlist only as supporting material.
- **Do not interpret “deep web research” as permission to access private,
  restricted, or dark-web systems.** Define it as broad public-web research and
  state the access boundary because crawling depth does not remove authorization
  requirements.
- **Do not make every source integration mandatory.** Branch YouTube, academic,
  archives, and browser-heavy retrieval by task because a permanently enabled
  stack increases setup, latency, failure surface, and maintenance.
- **Do not treat repository stars or search snippets as proof of quality.** Read
  the README, inspect maintenance/license/status, and describe limitations.
- **Do not claim a profile is ready after creation alone.** A profile exists
  only after its role, paths, runtime dependencies, and smoke behavior are
  independently verified.

## References

- `references/repository-shortlist.md` — reusable categories and evaluation
  criteria for selecting open-source research components; extend this file when
  new durable candidates are reviewed.
