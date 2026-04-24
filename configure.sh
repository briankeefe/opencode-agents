#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_CONFIG="${OPENCODE_CONFIG:-$HOME/.config/opencode}"
OPENCODE_JSON="$OPENCODE_CONFIG/opencode.json"

# Model mapping per provider
declare -A PRIMARY_MODEL
declare -A WORKER_MODEL

PRIMARY_MODEL[anthropic]="anthropic/claude-opus-4-6"
PRIMARY_MODEL[openai]="openai/gpt-5.4"

WORKER_MODEL[anthropic]="anthropic/claude-sonnet-4-6"
WORKER_MODEL[openai]="openai/gpt-5.4-mini"

sed_in_place() {
  local expr="$1"
  local file="$2"
  if sed --version >/dev/null 2>&1; then
    sed -i "$expr" "$file"
  else
    sed -i '' "$expr" "$file"
  fi
}

usage() {
  echo "Usage: ./configure.sh <provider>"
  echo ""
  echo "Providers:"
  for f in "$SCRIPT_DIR/config/providers/"*.json; do
    echo "  $(basename "$f" .json)"
  done
  exit 1
}

PROVIDER="${1:-}"
[ -z "$PROVIDER" ] && usage

PROVIDER_FILE="$SCRIPT_DIR/config/providers/$PROVIDER.json"
if [ ! -f "$PROVIDER_FILE" ]; then
  echo "Error: no provider config at $PROVIDER_FILE"
  usage
fi

PRIMARY="${PRIMARY_MODEL[$PROVIDER]:-}"
WORKER="${WORKER_MODEL[$PROVIDER]:-}"

if [ -z "$PRIMARY" ] || [ -z "$WORKER" ]; then
  echo "Error: no model mapping for provider '$PROVIDER'"
  echo "Add entries to the PRIMARY_MODEL and WORKER_MODEL maps in configure.sh"
  exit 1
fi

echo "Configuring for provider: $PROVIDER"
echo "  Primary model: $PRIMARY"
echo "  Worker model:  $WORKER"
echo ""

# Rewrite model lines in agent frontmatter
echo "Updating agent model references..."
for f in "$SCRIPT_DIR/agents/"*.md; do
  name=$(basename "$f" .md)
  if [ "$name" = "foreman" ]; then
    sed_in_place "s|^model:.*|model: $PRIMARY|" "$f"
  else
    sed_in_place "s|^model:.*|model: $WORKER|" "$f"
  fi
  echo "  $name → $(grep '^model:' "$f")"
done

# Merge provider config into opencode.json
if command -v jq &>/dev/null && [ -f "$OPENCODE_JSON" ]; then
  echo ""
  echo "Merging provider config into opencode.json..."
  TMP=$(mktemp)
  jq -s '.[0] * .[1]' "$OPENCODE_JSON" "$PROVIDER_FILE" > "$TMP"
  mv "$TMP" "$OPENCODE_JSON"
  echo "  done"
elif [ ! -f "$OPENCODE_JSON" ]; then
  echo ""
  echo "NOTE: No opencode.json at $OPENCODE_JSON — copy provider config manually."
else
  echo ""
  echo "NOTE: jq not found — merge provider config into opencode.json manually."
fi

echo ""
echo "Done. Provider set to '$PROVIDER'."
