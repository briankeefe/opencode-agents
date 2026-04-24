---
description: Pull latest opencode-agents and re-link any new files
---

Update opencode-agents to the latest version.

Workflow:
- Find the opencode-agents repo by resolving the symlink: `readlink ~/.config/opencode/commands/update.md` and get its parent directory's parent.
- Run `./update.sh` from the repo dir.
- Report what changed (new files, updated files) or confirm already up to date.
