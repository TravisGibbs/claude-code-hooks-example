#!/bin/bash
#
# Discord notification hook for Claude Code
# Sends a notification when Claude finishes responding
#
# Setup:
# 1. Replace YOUR_WEBHOOK_URL with your Discord webhook URL
# 2. chmod +x discord-notify.sh
# 3. Add to ~/.claude/settings.json (see README)

# Your Discord webhook URL (Server Settings > Integrations > Webhooks)
DISCORD_WEBHOOK_URL="YOUR_WEBHOOK_URL"

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
SUMMARY=$(echo "$LAST_MSG" | grep -v '^$' | grep -v '^```' | grep -v '^<' | grep -v '^|' | head -1 | head -c 200)

if [ -z "$SUMMARY" ] || [ "$SUMMARY" = "null" ]; then
  SUMMARY="Task completed"
fi

# Escape special characters for JSON
SUMMARY=$(printf '%s' "$SUMMARY" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')

# Send to Discord
curl -s -X POST "$DISCORD_WEBHOOK_URL" \
  -H "Content-type: application/json" \
  --data-raw "{\"embeds\": [{\"title\": \"Claude Code\", \"description\": \"${SUMMARY}\", \"color\": 5814783}]}" > /dev/null 2>&1

exit 0
