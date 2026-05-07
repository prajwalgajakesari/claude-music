#!/bin/bash
# claude-music status line — shows current Apple Music track
#
# Usage in ~/.claude/settings.json:
#   "statusLine": {
#     "type": "command",
#     "command": "~/repos/claude-music/statusline/now-playing.sh"
#   }
#
# Outputs nothing if Music isn't running or nothing is loaded — keeps the
# status line clean when you're not listening to anything.

# Bail early if the Music app isn't running (avoids launching it).
if ! pgrep -x "Music" >/dev/null 2>&1; then
  exit 0
fi

# Cache the result for 2s so we don't hammer osascript on every status refresh.
CACHE="${TMPDIR:-/tmp}/claude-music-statusline.cache"
if [ -f "$CACHE" ]; then
  age=$(( $(date +%s) - $(stat -f %m "$CACHE" 2>/dev/null || echo 0) ))
  if [ "$age" -lt 2 ]; then
    cat "$CACHE"
    exit 0
  fi
fi

# Read player state + current track. Single osascript call to keep it fast.
result=$(osascript <<'OSA' 2>/dev/null
tell application "Music"
  try
    if player state is playing then
      return "♪ " & (name of current track) & " — " & (artist of current track)
    else if player state is paused then
      return "⏸ " & (name of current track) & " — " & (artist of current track)
    else
      return ""
    end if
  on error
    return ""
  end try
end tell
OSA
)

# Truncate long lines so we don't wreck the status bar.
if [ ${#result} -gt 60 ]; then
  result="${result:0:57}…"
fi

echo "$result" | tee "$CACHE"
