# Research Component Shortlist

Use this reference only after the profile boundary is approved or when the user
explicitly asks for ecosystem research. It is a selection aid, not a mandate to
install a full stack. Lead with the profile proposal; keep this appendix secondary
so repository breadth does not obscure the requested role.

## Selection order

1. Define the missing capability: workflow, retrieval, browser traversal, video,
   scholarly sources, verification, archives, or storage.
2. Prefer a small number of components with clear interfaces and compatible
   licenses over a complete platform assembled from many repositories.
3. Read the official README and inspect current GitHub metadata before adopting:
   maintenance, archived/renamed status, license, runtime, API/MCP surface, and
   credential requirements.
4. Test the chosen component in isolation before wiring it into a Hermes profile.
5. Keep optional branches disabled until a research task needs them.

## Useful candidate categories

| Capability | Candidates to evaluate | Selection note |
|---|---|---|
| Research workflow | Stanford STORM; GPT Researcher; MiroFlow/MiroThinker; Tongyi DeepResearch | Reuse their decomposition, multi-perspective research, and synthesis patterns; do not assume the entire application belongs inside Hermes. |
| Search and extraction | SearXNG; Firecrawl; Crawl4AI; Vane; Browser Use | Choose one primary search/extraction path and one browser fallback; search results are discovery, not evidence. |
| YouTube/video | YTT; yt-dlp; faster-whisper or Whisper; a maintained YouTube MCP server | Prefer captions first, retain timestamps, and use transcription only when captions are unavailable. |
| Scholarly retrieval | PaperQA2; scientific-agent-skills; scholar-megasearch; arXiv/OpenAlex/Semantic Scholar/PubMed APIs | Use API-first discovery and open full text where possible; preserve DOI, version, and source provenance. |
| Evidence verification | Loki/OpenFactVerification; CiteFact; SourceCheck; IBM FactReasoner | Use as a claim-quality gate, not as proof that a source is true; report unsupported or conflicting claims. |
| Archives | Browsertrix Crawler; pywb; Common Crawl tools; Wayback/Common Crawl utilities | Use for historical or missing pages; label archived snapshots with their date and never present them as live data. |
| Knowledge storage | GraphRAG; LightRAG; RAGFlow | Add only when the user needs a reusable corpus or multi-session knowledge base; do not add storage to a one-off report by default. |
| Evaluation | BrowserGym; ST-WebAgentBench; AgentOccam | Use to measure browser traversal and safety; benchmarks are not production readiness. |

## Current-state cautions

- Check status at selection time: projects can be archived, renamed, experimental,
  or replaced while search results continue to show old names.
- Keep GitHub stars as a discovery signal only; they do not establish factual
  quality, maintenance, security, or compatibility with Hermes.
- Treat “deep web” as deeper retrieval of the public web, not a license to bypass
  authentication, paywalls, robots controls, or restricted networks.
- Avoid installing multiple overlapping workflow frameworks. Hermes can provide
  orchestration; external repos should fill a concrete retrieval, parsing,
  evidence, or domain-source gap.
