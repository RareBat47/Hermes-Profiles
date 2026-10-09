---
name: python-execution
 description: Run Python in project-local isolated environments.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [python, venv, testing, dependencies]
    related_skills: [test-driven-development, systematic-debugging]
---

# Python execution

Run project Python through a local `.venv` and repair failures from evidence. Dependency installation is explicit and reviewable; source edits require a failing reproduction first.

## Procedure

1. Detect the project root and existing `.venv`.
2. Create it with `uv venv .venv` when absent.
3. Run scripts and tests with `.venv/Scripts/python.exe` on Windows or `.venv/bin/python` elsewhere.
4. For `ModuleNotFoundError`, identify the import and install the smallest matching package with `uv pip install --python <venv-python> <package>`.
5. For syntax or logic failures, stop automatic repair, capture the traceback, create a failing test or repro, and fix only after root-cause analysis.
6. Rerun the failing command, then the full test suite.

## Quick Reference

```text
terminal(command="uv venv .venv", workdir="<project>")
terminal(command="uv pip install --python .venv/Scripts/python.exe -r requirements.txt", workdir="<project>")
terminal(command=".venv/Scripts/python.exe -m pytest", workdir="<project>")
```

## Pitfalls

- Never blindly install a package based only on a similarly named import.
- Never auto-patch syntax tracebacks without inspecting the file and reproducing the failure.
- Keep secrets out of requirements and source files.

## Verification

The project interpreter path exists, the focused command passes, and the full available test suite passes or its blocker is reported.
