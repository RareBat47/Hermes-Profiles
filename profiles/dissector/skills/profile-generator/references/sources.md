# Source Catalog for Profile Generation

Curated 2026-09-18. Verified patterns, not links-only: each entry lists what to
steal for a new profile.

## Official Hermes (authoritative)

- **Docs — Profiles**: https://hermes-agent.nousresearch.com/docs/user-guide/profiles
  - A profile = separate Hermes home: own config.yaml, .env, SOUL.md, memories,
    sessions, skills, cron, state.db. Identity files that make a dir a profile:
    config.yaml, .env, SOUL.md, profile.yaml, auth.json, state.db.
  - `hermes profile create <name> [--description …]` — description is the kanban
    routing key. `--clone-from SRC`, `--clone` (config+SOUL+skills+curated memory),
    `--clone-all`, `--no-skills`.
  - Profile becomes its own command: `<name> chat`, `<name> setup`, …
  - `hermes -p <name> …` targets it explicitly; `hermes profile use <name>` sticky.
  - Two agent processes must NEVER share one profile home (memory write compounding).

- **Docs — Profile Distributions**: https://hermes-agent.nousresearch.com/docs/user-guide/profile-distributions
  - distribution.yaml manifest keys: name, version, description, hermes_requires,
    author, license, env_requires[{name, description, required, default}],
    distribution_owned[] (replaces default-owned list).
  - Default distribution-owned: SOUL.md, config.yaml (preserved on update unless
    --force-config), mcp.json, skills/, cron/, distribution.yaml.
  - NEVER shipped (installer strips; author .gitignore must too): auth.json, .env,
    memories/, sessions/, state.db*, logs/, workspace/, plans/, home/, *_cache/,
    local/, checkpoints/, backups/, .hermes_history, gateway.pid, processes.json.
  - Update: `hermes profile update <name>` re-clones, replaces distribution-owned,
    preserves user data. `hermes profile info <name>` shows origin.
  - Local-directory install during dev: `hermes profile install ./path/`.

## Community profile distributions (mine these)

- **teknium1/hermes-starter-profile** — github.com/teknium1/hermes-starter-profile
  - Minimal focused distribution. `.no-bundled-skills` marker to skip skill seeding.
  - config.yaml pattern: `agent.disabled_toolsets: [bfl, code_execution,
    computer_use, terminal, memory, …]` + `platform_toolsets: {cli: [clarify,
    image_gen, search, tts, vision], telegram: […], …}` — same focused set per surface.
  - `agent.max_turns: 20` to cap runaway loops on a light profile.
  - SOUL.md is behavior-focused (how to help, research rules, plain-language teaching).

- **JamesFincher/hermes-agents** — github.com/JamesFincher/hermes-agents
  - Multi-agent repo: `agents/<name>/` each a full distribution (one agent per PR,
    playbook-driven). Ships HONEST-LIMITS.md honesty doc per agent.
  - research-bot config.yaml patterns worth copying:
    - delegation: max_concurrent_children, max_iterations, max_spawn_depth,
      child_timeout_seconds; aux/compression models pinned cheap; compression
      threshold 0.55, tail_mode lean, protect_last_n 12.
    - tool_output caps (max_bytes 40000 / max_lines 1500).
    - env_requires documents EVERY optional integration (self-hosted search,
      MCP keys, CDP) as `required: false` with interpolation notes — never
      commits values.
  - SOUL.md pattern: Identity (evidence discipline) → Method → Style → Avoid →
    Defaults. Explicit anti-hallucination: "Every non-obvious claim needs a source
    someone else can open and check." "Two sources that copy the same press
    release are one source."

## Persona libraries (role content to adapt into SOUL.md)

- **TravisLeeeeee/awesome-openclaw-personas** — 214 personas, 34 categories
  (engineering, devops 50, testing 40, security 26, finance 51, marketing 121,
  game-dev 96, academic 66, legal 36, …).
  - File contract per persona: SOUL.md (Core Truths as bolded rules + Vibe +
    Memory discipline), AGENTS.md (numbered Process + Boundaries), SKILL.md
    (capabilities + output templates), README.md. Map to Hermes: SOUL.md ←
    their SOUL + AGENTS (merge), profile-local skill ← their SKILL.md.
  - Example worth copying (engineering/debugger): evidence-before-hypothesis
    rules, reproduce-first, boundary-checking (null/off-by-one/timezone),
    "never guess — prove or disprove".
- **shiro-0x/hersona** — 346 composable character attributes (personality/
  speech/archetype/visual/hobby) with per-attribute intensity; MIT+CC0; ships
  as a Hermes skill. Use only when the user wants tone/voice tuning.

- **spotware/ctrader-skills** — official vendor skills for cTrader CLI and MCP;
  includes Python standard-library helpers for pip math, position sizing,
  conversion chains, tiered margin, and units encoding. Adapt profile-locally;
  observe its proprietary license and build-stamped references.

- **alexmihalache/cursor_domain_agent** — experimental cTrader orchestrator and
  agent scaffolding. Reusable patterns: register/build/run harness, deterministic
  artifacts, DuckDB result persistence, experiment audit trail, data-window and
  leakage gates, OOS/walk-forward validation, and methods registry. Do not copy
  its Cursor-specific hooks blindly into Hermes; adapt the research gates and
  artifact contract.

## cTrader platform setup (Windows) — verified on this machine

- **CLI install path:** `winget install --id Spotware.cTrader.CLI --exact
  --accept-package-agreements --accept-source-agreements --silent`. Lands at
  `C:\Users\<user>\AppData\Local\Programs\cTrader CLI\ctrader-cli.exe`; the
  `Programs\cTrader CLI` directory is added to the user `PATH`. CLI binary
  is `ctrader-cli.exe` (no `.bat` shim). `ctrader-cli.exe --version` reports
  its own build stamp; treat that as the authority, not docs.
- **Verified CLI read-only surface (5.9.0.38):** `periods`, `create`,
  `build <project-path>`, `metadata <algo-file>`, `backtest <algo-file>
  <symbol> <period> <from> <to> [params]`. Authenticated backtest flows
  require the user to have signed in via cTrader Desktop at least once;
  no credential lives in `config.yaml` or `.env`.
- **Local MCP endpoint:** `http://127.0.0.1:9876/mcp/`. Only listens while
  cTrader Desktop is running **and** its in-app MCP toggle is on. cTrader
  Desktop itself is a separate user process; if the user "has cTrader
  installed and logged in" but the port is closed, the process is simply
  not running in the current session — start it from the Start menu / tray.
  Do not assume readiness from a successful `tasklist cTrader.exe` probe on
  a stale PID; verify the TCP port too.
- **Profile MCP config (verified):** `mcp.json` /
  `hermes -p <name> mcp add <name> http://127.0.0.1:9876/mcp/ …` — the
  profile-side `mcp list` will report `✓ enabled` even when the endpoint
  is closed. Always probe the port before claiming the runtime is
  connected.
- **Cron jobs that gate on an external runtime:** scripts must live under
  the profile's own `scripts/` directory (not `~/.hermes/scripts/`). The
  `hermes cron create` form for a heartbeat is
  `hermes -p <name> cron create 'every 3m' --name … --script X.py
  --no-agent --deliver local --failure-deliver local`. The `--no-agent`
  watchdog pattern (script stdout IS the delivery) is the right fit for
  readiness checks — the agent only wakes up if the script emits
  non-empty output.
- **Gateway:** cron jobs are inert until `hermes gateway install` is run.
  `hermes cron create` prints the warning and the install command — treat
  that warning as a required follow-up step, not a hint.

## This machine's fleet (local ground truth)

- Profiles: default (master/orchestrator), architect-worker, code-runner,
  qa-devops — all z-ai/glm-5.3 via custom provider https://api.xkiro.com/v1,
  api_key ${HERMES_CUSTOM_API_XKIRO_COM_API_KEY}.
- Distinctness pattern in every worker SOUL.md: "You are <Role>. Follow the
  shared Hermes operating discipline. Own <non-overlapping domain list>. …
  Keep all profile skills, sessions, memory, and project artifacts in this
  profile's own directories; do not communicate with other profiles unless the
  master explicitly orchestrates it."
- profile.yaml per worker: description (routing), description_auto: false.
- config.yaml per worker: terminal.cwd → its own profile-local workspace.
- Worker skills mirror the HOME profile's full set (user requirement: all home
  skills are must-have in every profile). Roles separate by SOUL ownership +
  description + toolsets, never by pruning skills. When a custom skill is added
  to the home profile, copy it into every existing profile too — no drift.
  (Pruning remains an option only for deliberately focused profiles like the
  teknium starter, and only when the user asks.)
