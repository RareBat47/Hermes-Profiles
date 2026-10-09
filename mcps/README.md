# Hermes Agent MCP (Model Context Protocol) Integration Guide

Hermes Agent features a native MCP client that automatically discovers, connects to, and injects external MCP tools directly into every conversation. MCP tools appear alongside standard agent built-in tools (`terminal`, `read_file`, `browser_exec`, etc.).

---

## 1. Prerequisites

To run MCP servers with Hermes Agent:

1. **Python MCP SDK:**
   ```bash
   python -c "import pm; pm.sync_venv(['mcp'], explicit=True)"
   ```
   Or via pip in your Hermes virtual environment:
   ```bash
   pip install mcp
   ```

2. **Node.js (v18+) & npx:** Required for JavaScript/TypeScript-based MCP servers (e.g., GitHub, Filesystem, Puppeteer).
3. **uv / uvx:** Required for fast Python-based MCP servers (e.g., Fetch, SQLite).
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

---

## 2. How MCP Configuration Works

In each profile's `config.yaml`, add an `mcp_servers` section. When Hermes starts, it spins up each configured server, retrieves its tool signatures, prefixes them with `mcp_{server_name}_{tool_name}`, and registers them in the agent's active toolset.

```yaml
mcp_servers:
  <server_name>:
    command: "<binary>"        # e.g., npx, uvx, node, python
    args: ["arg1", "arg2"]     # Subprocess arguments
    env:                       # Extra environment variables (filtered by default for security)
      API_KEY: "..."
    timeout: 60                # Per-call timeout in seconds
    connect_timeout: 30        # Startup connection timeout
```

---

## 3. Recommended MCP Server Catalog

### A. Filesystem MCP (`@modelcontextprotocol/server-filesystem`)
Allows the profile to safely read, write, and index directories outside the root session.
```yaml
mcp_servers:
  filesystem:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-filesystem", "./workspace"]
    timeout: 60
```

### B. GitHub MCP (`@modelcontextprotocol/server-github`)
Directly create issues, fetch pull request diffs, list branches, and search repositories.
```yaml
mcp_servers:
  github:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "${GITHUB_TOKEN}"
    timeout: 60
```

### C. Brave Search MCP (`@modelcontextprotocol/server-brave-search`)
Adds high-capacity web search for deep research investigations.
```yaml
mcp_servers:
  brave_search:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-brave-search"]
    env:
      BRAVE_API_KEY: "${BRAVE_API_KEY}"
    timeout: 60
```

### D. Fetch MCP (`mcp-server-fetch`)
Converts HTML and web pages into clean, LLM-ready markdown.
```yaml
mcp_servers:
  fetch:
    command: "uvx"
    args: ["mcp-server-fetch"]
    timeout: 90
```

### E. SQLite MCP (`mcp-server-sqlite`)
Inspect, query, and test local SQLite databases during software reverse engineering or development.
```yaml
mcp_servers:
  sqlite:
    command: "uvx"
    args: ["mcp-server-sqlite", "--db-path", "./workspace/target.db"]
    timeout: 60
```

### F. Puppeteer MCP (`@modelcontextprotocol/server-puppeteer`)
Headless browser automation for deep screenshotting and client-rendered SPA extraction.
```yaml
mcp_servers:
  puppeteer:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-puppeteer"]
    timeout: 120
```

---

## 4. Troubleshooting MCP Connections

- **Server startup failure:** Verify that `npx` or `uvx` is executable directly in your terminal.
- **Environment isolation:** Hermes filters environment variables passed to MCP subprocesses for security. Always declare required API keys explicitly under the server's `env:` block or define them in your `.env`.
- **Tool name conflicts:** Tools are automatically scoped with `mcp_{server_name}_{tool_name}`. For example, `github`'s `search_repositories` becomes `mcp_github_search_repositories`.
