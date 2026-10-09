# GitHub Backup-Recovery Storage Surfaces

Use this matrix to avoid stopping at repositories.

| Surface | Discovery | What can hold a backup | Common limitation |
|---|---|---|---|
| Owned repositories | `user/repos?affiliation=owner` | Source trees, Git history, submodules, LFS | Empty repositories have no tree; default clone may omit refs |
| Accessible repositories | `user/repos?affiliation=owner,collaborator,organization_member` | Shared/private project copies and forks | Access is not ownership; inspect `fork` and `parent` |
| Branches/tags/history | `/repos/{owner}/{repo}/branches`, `/tags`, Git refs | Deleted current-tree files, old migration commits | Current clone alone can miss unreachable or unreferenced data |
| Git LFS | `.gitattributes`, `git lfs ls-files`, `.git/lfs/objects` | Large DBs, Chroma stores, archives | A pointer is not the payload; verify object size/content |
| Releases/assets | `/repos/{owner}/{repo}/releases` | ZIPs, installers, backups | Releases may be absent even when source exists |
| Actions artifacts | `/repos/{owner}/{repo}/actions/artifacts` | Build bundles, test exports, backup archives | Artifact retention/permissions can hide expired items |
| Gists | `/gists` | Setup scripts, prompts, config snippets | Usually small; inspect private gists through authenticated API |
| Packages | `/user/packages?package_type=...` | Container images, npm/PyPI-like packages, tarballs | Requires `read:packages`; package registry may use separate APIs |
| Codespaces | `/user/codespaces` | Persistent dev environments and attached repos | Requires `codespace`; not every account has admin rights |
| Projects | `/user/projects` or current project APIs | Issue/task metadata, links, planning notes | API availability and project type differ |
| Organizations | `/user/orgs`, then org repos/packages | Team-owned copies and backups | Membership does not grant every repository or package scope |
| Pages/deployments | repo Pages/deployments endpoints | Published artifacts/configuration | Usually not a full backup; use as a lead only |
| External storage links | Search README/issues/Actions metadata | Drive/Dropbox/Azure/S3 backup URLs | Requires separate provider access; do not claim contents without retrieval |

## Account-audit commands

On Windows Git Bash, prefer an absolute `gh` path if needed:

```bash
GH='/c/Program Files/GitHub CLI/gh.exe'
"$GH" auth status
"$GH" api user
"$GH" api 'user/repos?affiliation=owner&per_page=100' --paginate
"$GH" api 'gists?per_page=100' --paginate
"$GH" api 'user/orgs?per_page=100' --paginate
```

For each repository, save:

```bash
"$GH" api "repos/OWNER/REPO"
"$GH" api "repos/OWNER/REPO/branches?per_page=100"
"$GH" api "repos/OWNER/REPO/tags?per_page=100"
"$GH" api "repos/OWNER/REPO/releases?per_page=100"
"$GH" api "repos/OWNER/REPO/actions/artifacts?per_page=100"
"$GH" api "repos/OWNER/REPO/actions/workflows?per_page=100"
```

## Scope gate

The baseline account token may cover `repo`, `workflow`, `gist`, and `read:org` but not Packages or Codespaces. If an endpoint returns 403, save the response and report the missing scope. After user approval, run:

```bash
"$GH" auth refresh -h github.com --scopes read:packages,codespace
"$GH" auth status
```

Only then re-query those surfaces. A 403 is not evidence that the surface is empty.

## Clone and large-object checklist

1. Create a dedicated audit directory outside all live Hermes homes.
2. Clone each repository into a unique destination with `--no-single-branch`.
3. Fetch tags and prune remote refs.
4. Check clone success and avoid touching active Git processes.
5. Run `git lfs ls-files`; inspect `.gitattributes` and `.git/lfs/objects`.
6. Enumerate current files and historical objects:

```bash
git rev-list --objects --all > objects.txt
git cat-file --batch-check='%(objectname) %(objecttype) %(objectsize)' < objects.txt
```

7. Flag blobs at or above 50 MiB and all archive/database/state paths.
8. Compare the working tree with the repository's migration manifest or restore documentation.
9. Verify large objects by measured size and hash before restoration.
10. Preserve a read-only audit copy and never import into a live Hermes profile during discovery.

## Restoration decision rules

- A source-only repo is not a profile backup.
- A migration package containing Hermes memories, skills, sanitized config, state snapshots, sessions, project trees, and MCP launchers is usually reconstructable, but not a byte-for-byte restore.
- LFS databases can be project-critical; verify payloads before declaring the backup complete.
- Credentials are always re-authenticated; sanitized absence is a positive safety property, not a missing-file bug.
- State/session database import requires version and integrity checks; preserve the target database and use supported Hermes import paths when available.
