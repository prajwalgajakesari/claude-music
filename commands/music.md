---
description: Control Apple Music or play the Claude live coding stream
argument-hint: [play | pause | skip | back | now | up | down | random | claude | lofi | coding | <playlist or search>]
allowed-tools: Bash(osascript:*), Bash(open:*), Bash(python3:*)
---

You are handling the `/music` command. The user's argument is: `$ARGUMENTS`

Pick ONE branch based on the argument, run the matching Bash command(s), and reply with a single short line — no preamble.

---

### Empty, `play`, or `resume`
Resume if there's something in the queue. If the queue is empty (Music just opened, nothing loaded), fall back to a Siri-style default — the user's auto-generated Daily Mix, then other auto-mixes, then a random library track. Single osascript call:
```bash
osascript <<'OSA'
tell application "Music"
  activate
  try
    play
  end try
  delay 0.3
  if player state is not playing then
    set fallbacks to {"Daily Mix 1", "Daily Mix 2", "Daily Mix 3", "Heavy Rotation Mix", "Favourite Songs", "Music"}
    repeat with pname in fallbacks
      try
        play playlist (pname as text)
        exit repeat
      end try
    end repeat
  end if
  if player state is not playing then
    try
      play (some track of library playlist 1)
    end try
  end if
end tell
OSA
```
Then read the current track:
```bash
osascript -e 'tell application "Music" to (get name of current track) & " — " & (get artist of current track)' 2>/dev/null
```
Reply: `▶ <track> — <artist>` (or `▶ Apple Music opened — couldn't find anything to play` if everything failed).

### `pause` or `stop`
```bash
osascript -e 'tell application "Music" to pause'
```
Reply: `⏸ Paused.`

### `skip` or `next`
```bash
osascript -e 'tell application "Music" to next track'
```
Then read current track and reply: `⏭ <track> — <artist>`.

### `back`, `prev`, or `previous`
```bash
osascript -e 'tell application "Music" to previous track'
```
Then read current track and reply: `⏮ <track> — <artist>`.

### `now`, `current`, or `np`
```bash
osascript -e 'tell application "Music" to (get name of current track) & " — " & (get artist of current track)' 2>/dev/null
```
Reply: `♪ <track> — <artist>` (or `Nothing playing.` if it errors).

### `vol <0-100>` (e.g. `vol 50`)
Parse the number from `$ARGUMENTS`:
```bash
osascript -e 'tell application "Music" to set sound volume to <N>'
```
Reply: `🔊 Volume <N>%.`

### `up` (volume +10)
```bash
osascript -e 'tell application "Music" to set sound volume to (sound volume + 10)' -e 'tell application "Music" to get sound volume'
```
Reply: `🔊 Volume <returned>%.`

### `down` (volume -10)
```bash
osascript -e 'tell application "Music" to set sound volume to (sound volume - 10)' -e 'tell application "Music" to get sound volume'
```
Reply: `🔉 Volume <returned>%.`

### `random` or `surprise`
Play a random track from the library:
```bash
osascript -e 'tell application "Music" to play (some track of library playlist 1)' -e 'tell application "Music" to (get name of current track) & " — " & (get artist of current track)'
```
Reply: `🎲 <track> — <artist>`.

### Stream shortcut — `claude` (Claude FM), `lofi`, `coding`, `jazz`, or any user-defined shortcut

Before treating the argument as a playlist or search, check whether it's a configured stream shortcut. Lookup order:

1. User config: `~/.config/claude-music/streams.conf` — lines like `name=url`
2. Built-in defaults: `claude` (Claude FM), `live`, `lofi`, `coding`, `jazz`

Run:
```bash
ARG="$ARGUMENTS"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/claude-music/streams.conf"
URL=""
LABEL="$ARG"

if [ -f "$CONFIG" ]; then
  URL=$(grep -E "^${ARG}=" "$CONFIG" 2>/dev/null | head -1 | cut -d= -f2-)
fi

if [ -z "$URL" ]; then
  case "$ARG" in
    claude|live) URL="https://www.youtube.com/watch?v=AUQKjgKQF7w"; LABEL="Claude FM" ;;
    lofi)        URL="https://www.youtube.com/watch?v=jfKfPfyJRdk"; LABEL="Lofi Girl" ;;
    coding)      URL="https://www.youtube.com/watch?v=4xDzrJKXOOY"; LABEL="synthwave / coding radio" ;;
    jazz)        URL="https://www.youtube.com/watch?v=Dx5qFachd3A"; LABEL="jazz radio" ;;
  esac
fi

if [ -n "$URL" ]; then
  open "$URL"
  printf '📺 %s → %s\n' "$LABEL" "$URL"
fi
```

If `$URL` was non-empty, **stop here** and reply with the printed line (e.g. `📺 Claude FM → https://...`).
If `$URL` was empty, the argument isn't a stream shortcut — fall through to the next branch.

### Anything else — try playlist first, then search

The argument might be a playlist the user has (e.g. `focus`, `chill`, `roadtrip`) OR a search query. Try playlist first; if no playlist matches, fall back to Apple Music search.

Step 1 — try playing a playlist with that name (case-insensitive match works in AppleScript):
```bash
osascript -e 'tell application "Music" to play playlist "'"$ARGUMENTS"'"' 2>&1
```

If that **succeeds** (no `error` in output), read the now-playing track and reply: `📃 <playlist> → <track> — <artist>`.

If it **fails** (output contains `error` or `Can't get playlist`), fall through to search:
```bash
QUERY=$(python3 -c 'import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))' "$ARGUMENTS")
open "music://music.apple.com/search?term=$QUERY"
osascript -e 'tell application "Music" to play' 2>/dev/null
```
Reply: `🔍 No playlist "<arg>" — searching Apple Music. Hit play if it doesn't auto-start.`

---

**Rules:**
- Reply with exactly ONE short line. No summary of what you did beyond that line.
- If a command errors unexpectedly, say so in one line: `⚠ <short reason>`.
- Never explain AppleScript or URL schemes to the user.
