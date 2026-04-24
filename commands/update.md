---
description: Pull latest opencode-agents and re-link any new files
---

Run this exact command and show the output:

```bash
REPO=$(dirname "$(dirname "$(readlink ~/.config/opencode/commands/update.md)")")") && cd "$REPO" && ./update.sh
```
