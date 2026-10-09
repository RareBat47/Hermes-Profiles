# Recovery Matrix

## Backup classification

| Evidence | Classification | Safe action |
|---|---|---|
| `SOUL.md`, profile metadata, skills, memories, project tree, compatible state snapshots | Exact or near-exact profile backup | Rebuild in a new profile; compatibility-check state before import |
| Config intent, memories, skills, restore prompts, project trees, no usable state | Reconstructable profile | Create a fresh profile and merge portable context |
| Project source/data only | Project backup | Build a new specialist profile around the project |
| Prompts/manifests/docs only | Documentation backup | Use as restoration instructions, not runtime state |
| Empty container repository | No backup | Do not treat it as source of truth |

## Large GitHub repository checks

Run these after cloning:

```bash
git -C DEST rev-parse --is-inside-work-tree
git -C DEST log -1 --format='%H%n%P%n%s'
git -C DEST status --short --branch
git -C DEST fetch --all --tags --prune
git -C DEST lfs ls-files
du -sh DEST
```

If checkout fails after LFS transfer, inspect the object database and working tree first. A valid `HEAD`, commit history, hydrated LFS files, and expected package directories can make the clone usable even when the initial checkout was incomplete. Use `git restore --source=HEAD :/` only after checking for local data that must not be overwritten.

## GitHub storage scope

The minimum authenticated inventory is:

```bash
gh auth status
gh api 'user/repos?affiliation=owner&per_page=100&sort=full_name' --paginate
gh api 'gists?per_page=100' --paginate
gh api 'user/orgs?per_page=100' --paginate
gh api 'repos/OWNER/REPO/releases?per_page=100'
gh api 'repos/OWNER/REPO/actions/artifacts?per_page=100'
gh api 'repos/OWNER/REPO/branches?per_page=100'
gh api 'repos/OWNER/REPO/tags?per_page=100'
```

Packages require `read:packages`; Codespaces require the `codespace` scope and repository permissions. A 403 means unverified, not empty.

## Windows MCP recipe

Use a profile-owned wrapper rather than Linux `.sh` launchers:

```python
import os, runpy, sys
from pathlib import Path

root = Path(sys.argv[1]).resolve()
module = sys.argv[2]
sys.argv = [module, *sys.argv[3:]]
os.chdir(root)
sys.path.insert(0, str(root))
runpy.run_module(module, run_name='__main__')
```

Create a fresh profile-owned venv from the project requirements. Pin `mcp<2` when the project imports `mcp.server.fastmcp`; MCP 2.x renamed that API and causes discovery to close immediately. After installation, test every server:

```bash
hermes -p NAME mcp test SERVER
```

Only after successful discovery should the server be enabled for the profile.

## Profile verification

```bash
hermes profile list
hermes profile show NAME
hermes -p NAME config get terminal.cwd
hermes -p NAME mcp list
hermes -p NAME chat -q 'Give a bounded read-only migration status summary.'
```
