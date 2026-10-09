---
name: defuddle-reader
description: Convert web pages into focused Markdown before parsing.
version: 0.1.0
author: User, Hermes Agent
license: MIT
platforms: [windows, linux, macos]
metadata:
  hermes:
    tags: [defuddle, web, markdown, extraction]
    related_skills: [blocked-page-recovery, grounded-citations]
---

# Defuddle reader

Use Defuddle to remove navigation and boilerplate from HTML and produce reader-style Markdown. It is a preprocessing step, not a source-verification system.

## When to Use

- A page contains substantial navigation, ads, or repeated boilerplate.
- A local HTML file or URL needs compact Markdown extraction.

## How to Run

```text
terminal(command="defuddle parse <url-or-file> --markdown")
terminal(command="defuddle parse <url-or-file> --markdown --frontmatter --output article.md")
```

## Procedure

1. Fetch or identify the source URL and preserve it in output frontmatter.
2. Run Defuddle with Markdown output.
3. Inspect the extracted content for missing tables, code, or sections.
4. Cite the original source URL and independently verify claims that matter.

## Pitfalls

- Defuddle can omit content or misidentify the main article.
- A clean extraction is not evidence that the source is accurate.
- Bot walls and JavaScript-only pages may require browser recovery.

## Verification

Check that the output is non-empty Markdown, has the expected title or source metadata, and contains the required sections from the original page.
