#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_CONFIG="${OPENCODE_CONFIG:-$HOME/.config/opencode}"

echo "Installing opencode-agents → $OPENCODE_CONFIG"
echo ""

mkdir -p "$OPENCODE_CONFIG/agents" "$OPENCODE_CONFIG/commands"

link_file() {
  local src="$1"
  local dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ]; then
    echo "  backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -s "$src" "$dst"
  echo "  linked: $(basename "$dst")"
}

echo "Agents:"
for f in "$SCRIPT_DIR/agents/"*.md; do
  link_file "$f" "$OPENCODE_CONFIG/agents/$(basename "$f")"
done

echo ""
echo "Commands:"
for f in "$SCRIPT_DIR/commands/"*.md; do
  link_file "$f" "$OPENCODE_CONFIG/commands/$(basename "$f")"
done

echo ""
echo "AGENTS.md:"
link_file "$SCRIPT_DIR/AGENTS.md" "$OPENCODE_CONFIG/AGENTS.md"

# Merge agent colors into opencode.json if jq is available
OPENCODE_JSON="$OPENCODE_CONFIG/opencode.json"
if command -v jq &>/dev/null && [ -f "$OPENCODE_JSON" ]; then
  echo ""
  echo "Merging agent colors into opencode.json..."
  COLORS="$SCRIPT_DIR/config/agent-colors.json"
  TMP=$(mktemp)
  jq -s '.[0] * .[1]' "$OPENCODE_JSON" "$COLORS" > "$TMP"
  mv "$TMP" "$OPENCODE_JSON"
  echo "  merged agent colors"
elif [ ! -f "$OPENCODE_JSON" ]; then
  echo ""
  echo "NOTE: No opencode.json found at $OPENCODE_JSON"
  echo "      See config/agent-colors.json to add agent colors manually."
else
  echo ""
  echo "NOTE: jq not found — skipping agent color merge."
  echo "      Install jq or manually merge config/agent-colors.json into opencode.json."
fi

echo ""
echo "Done. Run './autoupdate/setup-autoupdate.sh' to enable daily auto-updates."
