<!-- ─────────────────────────────────  BANNER  ───────────────────────────────── -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:6366F1,50:A855F7,100:EC4899&height=200&section=header&text=claude-music&fontSize=70&fontColor=ffffff&animation=fadeIn&fontAlignY=40&desc=because%20I%20kept%20asking%20Claude%20to%20play%20music%20and%20it%20couldn%27t&descAlignY=65&descSize=16" alt="claude-music banner" />
</p>

<!-- ─────────────────────────────────  TYPING SVG  ─────────────────────────── -->
<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=600&size=22&duration=2400&pause=700&color=A855F7&center=true&vCenter=true&width=620&lines=%2Fmusic+claude+%E2%86%92+Claude+FM;%2Fmusic+lofi;%2Fmusic+pause;%2Fmusic+up;%2Fmusic+%E2%9D%A4+queen;%2Fmusic+%E2%80%94+just+vibes." alt="typing animation showing /music commands" />
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

So I made `/music`. Now Claude *can* play music. And pause it. And bump the volume. And tune into **Claude FM** — a 24/7 Claude live coding stream — so you and Claude can rock out to the same beat while you work.

Yes, it's mostly AppleScript duct-taped to a slash command. No, I don't care. **It works.** ✨

---

## 🎙️ Claude FM

`/music claude` opens **Claude FM** — a live YouTube stream that plays in your browser while you and Claude grind together. It's the only command in here that's pointed at Claude specifically, and it ships pre-configured. Type the command, vibe with the agent.

```text
$ /music claude
📺 Claude FM → https://www.youtube.com/watch?v=AUQKjgKQF7w
```

Don't like the default stream? Point `/music claude` (or any other shortcut) to whatever you want — see [**Configure your own streams**](#-configure-your-own-streams) below.

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
/music claude         🎙️  open Claude FM
/music lofi           📺  open Lofi Girl 24/7
/music coding         📺  open synthwave / coding radio
/music jazz           📺  open jazz radio
/music <playlist>     📃  play a playlist by name (case-insensitive)
/music <anything>     🔍  ...or search Apple Music if no playlist matches
```

That last line: `/music focus`, `/music chill`, `/music roadtrip` — if you have a playlist by that name in Apple Music, it plays. If not, it searches.

---

## the magic moment

When you've been heads-down for an hour and the silence creeps in:

```text
$ /music
▶ Bohemian Rhapsody — Queen
```

It just… picks something. Daily Mix. Heavy Rotation. Whatever Apple thinks you'll like. Same thing Siri does, except you didn't have to take your hands off the keyboard.

When you want Claude on the same wavelength:

```text
$ /music claude
🎙️ Claude FM → https://youtu.be/AUQKjgKQF7w
```

When you need volume *right now*:

```text
$ /music up
🔊 Volume 90%.
```

When inspiration hits:

```text
$ /music queen
🔍 Searching Apple Music for "queen"... hit play if it doesn't auto-start.
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

## 🎛️ configure your own streams

Out of the box you get `/music claude`, `/music lofi`, `/music coding`, `/music jazz`. To override any of them or add your own, drop a config file at `~/.config/claude-music/streams.conf`:

```ini
# ~/.config/claude-music/streams.conf

# repoint Claude FM to a different stream
claude=https://www.youtube.com/watch?v=YOUR_STREAM_ID

# add as many as you want
study=https://www.youtube.com/watch?v=bP9gMpl1gyQ
rain=https://www.youtube.com/watch?v=mPZkdNFkNps
synthwave=https://www.youtube.com/watch?v=MVPTGNGiI-4
```

Now `/music study`, `/music rain`, `/music synthwave` all just work. There's an example file at `config/streams.conf.example` you can copy.

User config wins; built-in defaults fill in anything you don't override; **anything not matched as a stream falls through to playlist-or-search** so you don't lose any other commands.

---

## optional: now-playing in your status bar

A tiny script ships with the plugin that prints the current track. Drop it into Claude Code's status line and you get this:

```text
~/projects/landing-page │ ♪ Bohemian Rhapsody — Queen
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

Already running another status line? The script is safe to call standalone, emits nothing when nothing's playing, and is easy to chain with whatever you already have.

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
- [ ] **Hooks** — auto-pause when Claude finishes a long task, auto-play "focus" when an `/execute` slash command starts
- [ ] **Pomodoro mode** — `/music pomo` plays for 25, pauses for 5

PRs warmly welcomed. Especially Linux/Windows/Spotify.

---

## under the hood

It's four files. That's it.

```text
claude-music/
├── .claude-plugin/plugin.json     ← plugin manifest
├── commands/music.md              ← the slash command (routes args)
├── config/streams.conf.example    ← copy to ~/.config/claude-music/streams.conf
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
