# Claude Code Hooks Examples

Get notified when Claude Code finishes a task. This repo contains example hooks you can use with [Claude Code](https://claude.ai/code).

## What are Hooks?

Hooks are shell commands that run automatically at specific points in Claude Code's lifecycle. They let you:
- Get Slack/Discord notifications when Claude finishes
- Run linters or tests after code changes
- Block dangerous operations
- And more

## Quick Start: Slack Notifications

### 1. Create a Slack Webhook

1. Go to [Slack API: Incoming Webhooks](https://api.slack.com/messaging/webhooks)
2. Create a new webhook for your workspace
3. Copy the webhook URL

### 2. Install the Hook

```bash
# Create hooks directory
mkdir -p ~/.claude/hooks

# Copy the script
cp hooks/slack-notify.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/slack-notify.sh

# Edit the script and replace YOUR_WEBHOOK_URL with your actual webhook
```

### 3. Configure Claude Code

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/slack-notify.sh"
          }
        ]
      }
    ]
  }
}
```

Or use the interactive menu: type `/hooks` in Claude Code.

## Available Examples

| Hook | Description |
|------|-------------|
| [slack-notify.sh](hooks/slack-notify.sh) | Slack notification when Claude finishes |
| [discord-notify.sh](hooks/discord-notify.sh) | Discord notification when Claude finishes |
| [macos-notify.sh](hooks/macos-notify.sh) | macOS native notification |
| [linux-notify.sh](hooks/linux-notify.sh) | Linux desktop notification |

## Hook Events

| Event | When it fires |
|-------|---------------|
| `Stop` | When Claude finishes responding |
| `PreToolUse` | Before a tool runs (can block it) |
| `PostToolUse` | After a tool completes |
| `Notification` | When Claude sends a notification |
| `SessionStart` | When a session begins |

## How Hooks Work

1. Claude Code sends JSON to your script via stdin
2. Your script processes the input and takes action
3. Exit code 0 = success, exit code 2 = block the action

Example input for a Stop hook:
```json
{
  "session_id": "abc123",
  "cwd": "/path/to/project",
  "stop_hook_active": false,
  "last_assistant_message": "I've completed the task..."
}
```

## Debugging

- Check hook output: Press `Ctrl+O` in Claude Code for verbose mode
- Debug log: Hooks write to `/tmp/claude-hook-debug.log`
- Test manually: `echo '{"test": true}' | ./hooks/slack-notify.sh`

## License

MIT
