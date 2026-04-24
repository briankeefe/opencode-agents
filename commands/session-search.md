---
description: Search recent OpenCode sessions directly from the local session database
agent: foreman
---

Search local OpenCode session history for:

`$ARGUMENTS`

Workflow:
- Do not delegate.
- Query `~/.local/share/opencode/opencode.db` directly with targeted `sqlite3` queries.
- Start with the last 7 days unless I specify another range.
- Prefer titles, counts, token/cost aggregates, task-call patterns, and representative samples over raw transcript dumps.
- Use at most 6 SQL queries before summarizing unless I explicitly ask for deeper analysis.
- Include exact session IDs when they help continue the investigation.
