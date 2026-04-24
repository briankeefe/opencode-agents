---
description: Quick reference for which agent or command to use
---

Print this cheatsheet and nothing else:

\`\`\`
AGENTS (Tab to switch)
  Foreman      Smart orchestrator. Default. Delegates when needed.
  Builder-lite Dumb executor. Just builds what you say. No planning.
  Search-lite  Investigation mode. Find files, symbols, evidence.
  Review-lite  Review mode. Diffs, PRs, branches. Findings only.
  Build        Built-in full-access. Legacy fallback.
  Plan         Built-in read-only. Analysis without changes.

SUBAGENTS (@mention)
  @docs-lite   External docs lookup via Context7/webfetch.

COMMANDS
  /ticket <task>           Lean ticket workflow. Classifies first, minimal delegation.
  /review-pr <pr>          Single-pass PR review via review-lite.
  /investigate <question>  Codebase search via search-lite.
  /db-task <request>       DB/data task. SQL output, no code lifecycle.
  /session-search <query>  Search past session transcripts.

RULES OF THUMB
  Small fix?          → Builder-lite directly
  Need to find code?  → Search-lite or /investigate
  Full ticket?        → Foreman or /ticket
  PR review?          → /review-pr
  DB only?            → /db-task
  Docs question?      → @docs-lite
  Not sure?           → Foreman decides
\`\`\`
