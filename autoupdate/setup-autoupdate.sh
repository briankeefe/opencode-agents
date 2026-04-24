#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
UPDATE_SCRIPT="$REPO_DIR/update.sh"
PLIST_LABEL="com.opencode-agents.autoupdate"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_LABEL.plist"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macOS only. For Linux, add this cron entry manually:"
  echo "  0 9 * * * $UPDATE_SCRIPT >> $REPO_DIR/autoupdate/update.log 2>&1"
  exit 0
fi

cat > "$PLIST_PATH" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$PLIST_LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$UPDATE_SCRIPT</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>$REPO_DIR/autoupdate/update.log</string>
  <key>StandardErrorPath</key>
  <string>$REPO_DIR/autoupdate/update.log</string>
</dict>
</plist>
PLIST

launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo "Auto-update installed. Runs daily at 9am."
echo "Plist: $PLIST_PATH"
echo "Log:   $REPO_DIR/autoupdate/update.log"
