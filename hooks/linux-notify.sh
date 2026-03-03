#!/bin/bash
#
# Linux desktop notification hook for Claude Code
# Shows a system notification when Claude finishes responding
#
# Requirements: notify-send (usually pre-installed, or: apt install libnotify-bin)
#
# Setup:
# 1. chmod +x linux-notify.sh
# 2. Add to ~/.claude/settings.json (see README)

# Read input from Claude Code
INPUT=$(cat)

# Check if we're already in a hook continuation
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

# Get last assistant message
LAST_MSG=$(echo "$INPUT" | jq -r '.last_assistant_message // .transcript // empty' 2>/dev/null)

if [ -z "$LAST_MSG" ] || [ "$LAST_MSG" = "null" ]; then
  exit 0
fi

# Extract first meaningful line as summary
SUMMARY=$(echo "$LAST_MSG" | grep -v '^$' | grep -v '^```' | grep -v '^<' | grep -v '^|' | head -1 | head -c 100)

if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
  SUMMARY="Task completed"
fi

# Show Linux notification
notify-send "Claude Code" "$SUMMARY"

exit 0
