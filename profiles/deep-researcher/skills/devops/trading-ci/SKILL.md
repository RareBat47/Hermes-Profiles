---
name: trading-ci
description: Validate trading repositories with CI and secret guards.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [github-actions, ci, semver, secrets, trading]
    related_skills: [csharp-ctrader, pinescript, reflexion-self-review]
---

# Trading CI

Create repository-local validation for Python and .NET trading code, document strategy changes, and prevent credentials or generated trading binaries from entering Git.

## Procedure

1. Inspect the repository's existing CI and language layout.
2. Add or update `.github/workflows/validate.yml` with Python venv setup, Ruff, pytest, and .NET restore/build steps that apply to the repository.
3. Add `.env`, `*.algo`, `*.bin`, `obj/`, `bin/`, and local account configuration patterns to `.gitignore` without deleting existing rules.
4. Require `vMAJOR.MINOR.PATCH` tags for released strategy changes.
5. Keep a strategy-folder `README.md` changelog covering risk, indicators, and execution changes.
6. Run local equivalents and inspect the workflow YAML.

## Pitfalls

- Do not add workflow steps for languages the repository does not contain without documenting why.
- CI secrets belong in GitHub Secrets or environment variables, never YAML literals.
- SemVer tags do not guarantee strategy safety or profitability.

## Verification

Run YAML parsing or action linting where available, run local test/build commands, and scan tracked files for credential patterns and forbidden artifacts.
