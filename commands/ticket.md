---
description: Run lean ticket workflow with short planning and minimal delegation
agent: foreman
---

Handle this ticket or scoped implementation request:

`$ARGUMENTS`

Workflow:
- Classify first: implementation, investigation-only, db-or-data-only, docs-only, or writing.
- If this is db-or-data-only, do not enter a code lifecycle. Return the exact next action or query/process only.
- If this is implementation, make a short 3-6 bullet plan, then execute with at most:
  - one `search-lite` call if file discovery is needed
  - one `builder-lite` call for implementation
  - one `review-lite` call only if risk is high or the user explicitly wants review
- Do not use separate plan validation, scope validation, or rereview passes.
- Keep task prompts under 1200 chars.
- Finish with a short result summary and any blocker.
