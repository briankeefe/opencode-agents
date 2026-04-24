# opencode-agents

Custom agents, commands, and global instructions for [OpenCode](https://opencode.ai).

## What's included

### Agents
| Agent | Model | Role |
|-------|-------|------|
| `foreman` | opus-4-6 | Smart orchestrator — classifies tasks, delegates to the right agent, avoids churn |
| `builder-lite` | sonnet-4-6 | Narrow executor — builds only what was asked, no planning overhead |
| `search-lite` | sonnet-4-6 | Read-only file hunter — glob, grep, read, stop |
| `review-lite` | sonnet-4-6 | Read-only reviewer — findings only, no fixes |
| `docs-lite` | sonnet-4-6 | External docs via Context7/webfetch only |

### Commands
| Command | Description |
|---------|-------------|
| `/ticket` | Lean ticket workflow — classify, plan, execute, minimal delegation |
| `/review-pr` | Single-pass PR review via review-lite |
| `/investigate` | Bounded codebase investigation via search-lite |
| `/db-task` | DB/data tasks — SQL out, no code lifecycle |
| `/session-search` | Search past OpenCode sessions via sqlite3 |
| `/caveman` | Switch response compression level (lite/full/ultra) |
| `/normal-mode` | Turn off caveman mode |
| `/cheatsheet` | Print agent/command quick reference |
### Global instructions (`AGENTS.md`)
Caveman mode — terse, fragment-OK responses by default. Configurable per session.

---

## Install

```bash
git clone git@github.com:brianfakename/opencode-agents.git ~/.config/opencode-agents
cd ~/.config/opencode-agents
./install.sh
```

`install.sh` symlinks `agents/` and `commands/` into `~/.config/opencode/` and merges agent colors into `opencode.json` (requires `jq`).

Because these are **symlinks**, any `git pull` in this repo immediately updates your live config — no reinstall needed.

### Merging agent colors manually (if jq is missing)

Add the contents of `config/agent-colors.json` into the `"agent"` key of your `~/.config/opencode/opencode.json`.

---

## Auto-update

Install a daily launchd job (macOS) that runs `git pull` at 9am:

```bash
./autoupdate/setup-autoupdate.sh
```

For Linux, add a crontab entry:

```
0 9 * * * /path/to/opencode-agents/update.sh >> /path/to/opencode-agents/autoupdate/update.log 2>&1
```

---

## Manual update

```bash
cd ~/.config/opencode-agents
./update.sh
```

---

## Provider setup

Agents default to Anthropic models. To switch providers (e.g., OpenAI):

```bash
./configure.sh openai
```

This rewrites the `model:` lines in agent frontmatter and merges provider config into `opencode.json`.

Available providers: `anthropic`, `openai`

Example configs are in `config/providers/`. Copy one and fill in your API key:

```bash
# Anthropic (default)
./configure.sh anthropic

# OpenAI
./configure.sh openai
```

You can also edit `config/providers/*.json` to add custom base URLs, proxies, etc.

### Model mapping

| Role | Anthropic | OpenAI |
|------|-----------|--------|
| Primary (foreman) | `anthropic/claude-opus-4-6` | `openai/o3` |
| Worker (builder, search, review, docs) | `anthropic/claude-sonnet-4-6` | `openai/gpt-4.1` |

To customize, edit the model map at the top of `configure.sh`.

---

## Machine-specific config

The following are **not** in this repo because they differ per machine:

- `provider` API keys (set in `config/providers/*.json` — gitignored)
- `plugin` paths (absolute paths to local plugins)
- `model` / `small_model` defaults in opencode.json (set via `configure.sh`)

Keep those in your local `~/.config/opencode/opencode.json` alongside the synced agent colors.
