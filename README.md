<!-- ─────────────────────────────────  BANNER  ───────────────────────────────── -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:6366F1,50:A855F7,100:EC4899&height=200&section=header&text=claude-music&fontSize=70&fontColor=ffffff&animation=fadeIn&fontAlignY=40&desc=because%20I%20kept%20asking%20Claude%20to%20play%20music%20and%20it%20couldn%27t&descAlignY=65&descSize=16" alt="claude-music banner" />
</p>

<!-- ─────────────────────────────────  TYPING SVG  ─────────────────────────── -->
<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=22&duration=2400&pause=700&color=A855F7&center=true&vCenter=true&width=620&lines=%2Fmusic+claude;%2Fmusic+pause;%2Fmusic+up;%2Fmusic+down;%2Fmusic+%E2%9D%A4+ar+rahman;%2Fmusic+%E2%80%94+just+vibes." alt="typing animation showing /music commands" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-000?style=for-the-badge&logo=apple&logoColor=white" alt="macOS"/>
  <img src="https://img.shields.io/badge/Claude%20Code-plugin-D97757?style=for-the-badge&logo=anthropic&logoColor=white" alt="Claude Code plugin"/>
  <img src="https://img.shields.io/badge/Apple%20Music-FA243C?style=for-the-badge&logo=applemusic&logoColor=white" alt="Apple Music"/>
  <img src="https://img.shields.io/badge/license-MIT-6366F1?style=for-the-badge" alt="MIT"/>
</p>

---

## why does this exist

Look. I love Claude. I work with Claude all day. But every time the queue ran out and I asked —

> **me:** _hey play some music_
> **claude:** _I cannot directly play music — but here are 5 ways you could do it yourself..._

— I died a little inside. I don't want a tutorial. I want a song.

So I made `/music`. Now Claude *can* play music. And pause it. And bump the volume. And open its own live coding stream on YouTube while we both work.

Yes, it's mostly AppleScript duct-taped to a slash command. No, I don't care. **It works.** ✨

---

## the cheat sheet

```text
/music                ▶  resume Apple Music (or pick a Daily Mix if queue is empty — Siri-style)
/music pause          ⏸  pause
/music skip           ⏭  next track
/music back           ⏮  previous track
/music now            ♪  what am I listening to
/music vol 50         🔊  set volume to 50
/music up             🔊  +10 volume
/music down           🔉  −10 volume
/music random         🎲  surprise me
/music claude         📺  open the Claude live coding stream
/music <playlist>     📃  play a playlist by name (case-insensitive)
/music <anything>     🔍  ...or search Apple Music if no playlist matches
```

Yes that last one is "play any playlist OR search if it doesn't exist". `/music focus`, `/music chill`, `/music roadtrip` — if you have a playlist by that name, it plays. If not, it searches.

---

## the magic moment

When you've been heads-down for an hour and the silence creeps in:

```text
$ /music
▶ Marete Hodenu (Unplugged) — Vasishta N. Simha
```

It just… picks something. Daily Mix. Heavy Rotation. Whatever Apple thinks you'll like. Same thing Siri does, except you didn't have to take your hands off the keyboard.

When the homie sends you a YouTube link:

```text
$ /music claude
📺 Opening Claude live stream — https://youtu.be/AUQKjgKQF7w
```

When you need volume right now:

```text
$ /music up
🔊 Volume 90%.
```

---

## install

### 1. Clone and symlink (fastest, no marketplace needed)

```bash
git clone https://github.com/prajwalgajakesari/claude-music ~/repos/claude-music
ln -s ~/repos/claude-music/commands/music.md ~/.claude/commands/music.md
```

That's it. Open Claude Code, type `/music`, you're listening to something.

### 2. As a Claude Code plugin (when the marketplace is wired up)

```text
/plugin marketplace add prajwalgajakesari/claude-music
/plugin install claude-music
```

---

## optional: now-playing in your status bar

A tiny script ships with the plugin that prints the current track. Drop it into Claude Code's status line and you get this:

```text
⬆ /gsd:update │ Claude │ my-project │ ♪ Heat Waves — Glass Animals
```

Edit `~/.claude/settings.json`:

```jsonc
{
  "statusLine": {
    "type": "command",
    "command": "bash \"$HOME/repos/claude-music/statusline/now-playing.sh\""
  }
}
```

Already have a status line? Compose them. There's a wrapper script (`statusline/now-playing.sh`) that's safe to call standalone and emits nothing when nothing's playing — easy to glue onto whatever you already have running.

---

## what doesn't work (and why it's not my fault)

I tested every command. Some things Apple has quietly broken in modern Music.app:

- **Shuffle toggle** — `set shuffle enabled` is a silent no-op since macOS 12-ish. Hit `⌘+S` in the Music app instead. Not shipped.
- **Heart / favorite a track** — the `loved` and `favorited` AppleScript properties either error out or refuse to accept `true`. Not shipped.
- **Auto-playing a streaming search result** — AppleScript can't click an Apple Music search result. So `/music <unknown song>` opens a search and you tap play. Not great, not the plugin's fault.

I'd rather ship 9 things that work than 11 things where 2 lie.

---

## roadmap

- [ ] **Spotify** support — same UX, second backend (`/music spotify play …`)
- [ ] **YouTube Music** support
- [ ] **Linux** via `playerctl` (MPRIS), **Windows** via PowerShell SMTC
- [ ] **`/music match <vibe>`** — describe a mood ("brooding cyberpunk", "chai on a rainy morning") → small LLM call → Apple Music search → plays. The "Claude" in claude-music actually doing something Claude-y.
- [ ] **Hooks** — auto-pause when Claude finishes a long task, auto-play "focus" when `/gsd:execute-phase` starts
- [ ] **Pomodoro mode** — `/music pomo` plays for 25, pauses for 5

PRs warmly welcomed. Especially Linux/Windows/Spotify.

---

## under the hood

It's three files. That's it.

```text
claude-music/
├── .claude-plugin/plugin.json     ← plugin manifest
├── commands/music.md              ← the slash command (routes args)
└── statusline/now-playing.sh      ← optional now-playing script
```

The command is a markdown file with a frontmatter block and routing instructions. Claude reads it, runs the matching `osascript` snippet, replies in one line. No daemon, no API keys, no telemetry, no backend. macOS already has all the music-controlling primitives — they were just missing a friendly slash command.

---

<!-- ─────────────────────────────────  FOOTER  ─────────────────────────────── -->

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:EC4899,50:A855F7,100:6366F1&height=120&section=footer" alt="footer wave"/>
</p>

<p align="center">
  built by <a href="https://github.com/prajwalgajakesari">@prajwalgajakesari</a> · while procrastinating on a motorcycle app · MIT
</p>

<p align="center">
  <sub>if this saved you 6 seconds today, ⭐ the repo. that's the deal.</sub>
</p>
