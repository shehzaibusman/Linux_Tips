# figcount.sh

A full-screen figlet countdown timer for the terminal. Each second a large ASCII art number slams, flashes, or fades onto the screen — counting down to a custom final message. Automatically transitions colors from cyan → yellow → red as the countdown gets critical.

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell: Bash](https://img.shields.io/badge/shell-bash-green.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

---

## Features

- Three display styles: `slam`, `flash`, and `fade`
- Auto color transition: cyan → yellow → red as countdown gets low
- Fully centered — adapts to any terminal size
- Custom final message when countdown hits zero
- Optional beep each second
- Saves and restores your terminal screen on exit
- Clean exit on `Ctrl+C` — original terminal content always restored

---

## Requirements

- `bash` 3.2 or newer (macOS default; Linux distros ship 4.x+)
- `figlet` — generates the ASCII art numbers

### Installing figlet

```bash
# macOS
brew install figlet

# Ubuntu / Debian
sudo apt install figlet

# CentOS / RHEL
sudo yum install figlet
```

---

## Installation

### System-wide (recommended)

```bash
sudo cp figcount.sh /usr/local/bin/figcount
sudo chmod +x /usr/local/bin/figcount
```

### Per-user (no sudo required)

```bash
mkdir -p ~/bin
cp figcount.sh ~/bin/figcount
chmod +x ~/bin/figcount
```

Add `~/bin` to your PATH if not already (add to `~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/bin:$PATH"
source ~/.zshrc
```

---

## Usage

```bash
figcount [options]
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-n N` | Start countdown from N seconds | `10` |
| `-s STYLE` | Display style: `slam` `flash` `fade` | `slam` |
| `-c COLOR` | Text color (used in `fade` and `slam` styles) | `cyan` |
| `-b` | Bold text | off |
| `-f FONT` | Any figlet font name | `colossal` |
| `-z SIZE` | Size preset: `small medium large huge` | — |
| `-m MESSAGE` | Message to display when countdown hits zero | `GO!` |
| `-p` | Beep each second (if terminal supports it) | off |

### Available Colors

`red` `green` `yellow` `blue` `magenta` `cyan` `white`

### Size Presets (`-z`)

| Preset | Figlet Font |
|--------|-------------|
| `small` | small |
| `medium` | standard |
| `large` | big |
| `huge` | banner3 |

---

## Display Styles

### `slam` (default)
Each number slides down from the top of the screen and lands in the center. Color transitions automatically: cyan for high numbers, yellow in the middle, red for the final seconds.

```bash
figcount -s slam -n 10
```

### `flash`
The number flashes in rapidly cycling colors each second — high energy, hard to ignore.

```bash
figcount -s flash -n 10
```

### `fade`
Clean and minimal. The number appears centered with a smooth color transition as time runs low.

```bash
figcount -s fade -n 10
```

---

## Examples

```bash
# Default — 10 second slam countdown
figcount

# 5 second countdown with custom final message
figcount -n 5 -m "LAUNCH!"

# Flash style with beep and bold
figcount -s flash -n 10 -m "BOOM!" -p -b

# 30 second fade, huge font
figcount -z huge -s fade -n 30 -m "DONE"

# Banner font, red, slam style
figcount -f banner3 -s slam -c red -n 3 -m "NOW!"

# Long meeting countdown — 5 minutes
figcount -n 300 -s fade -m "TIME'S UP"
```

---

## Resource Usage

`figcount` is intentionally lightweight:

- **CPU**: Near zero — calls `figlet` once per second then sleeps
- **Memory**: ~2-5MB (bash process only; figlet spawns and exits instantly)
- **SSH**: Minimal network impact — only one full redraw per second

The terminal emulator (iTerm2, Terminal.app, etc.) does most of the rendering work. On slow SSH connections, `slam` style may appear choppy — use `fade` instead for smoother rendering over latency.

---

## Tips

- `Ctrl+C` exits cleanly at any time — your original terminal screen is always restored
- `-z huge` with short words like `LAUNCH` or `GO` fills the terminal dramatically
- Combine `-p` (beep) with `flash` style for maximum impact
- For long countdowns (meetings, cooking timers), `fade` is easier on the eyes
- The final message supports spaces: `-m "BLAST OFF"`

---

## Compatibility

| Platform | Tested |
|----------|--------|
| macOS (bash 3.2, zsh) | ✅ |
| Ubuntu 20.04 / 22.04 / 24.04 | ✅ |
| CentOS 7 / 8 | ✅ |
| Rocky Linux / RHEL | ✅ |

---

## Related

- [marquee.sh](../marquee/) — single-line terminal marquee scroller
- [figquee.sh](../figquee/) — multi-line figlet marquee scroller

---

## License

MIT — free to use, modify, and distribute.
