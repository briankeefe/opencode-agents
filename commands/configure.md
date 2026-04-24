---
description: Switch provider and models (anthropic, openai, or custom)
agent: foreman
---

Switch the opencode-agents provider configuration.

Requested provider: `$ARGUMENTS`

Workflow:
- Find the opencode-agents repo by resolving the symlink of this command file: `readlink ~/.config/opencode/commands/configure.md` and get its parent directory's parent.
- If no provider was specified, list available providers by listing `config/providers/*.json` in the repo dir and show usage.
- If a provider was given, run `./configure.sh <provider>` from the repo dir.
- Show what changed: provider name, primary model, worker model.
- If it fails, show the error.
