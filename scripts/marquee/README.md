# marquee.sh

A lightweight, cross-platform terminal marquee scroller written in pure Bash. No dependencies beyond standard Unix tools — works on macOS, Ubuntu, CentOS/RHEL, and most Linux distros out of the box.

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell: Bash](https://img.shields.io/badge/shell-bash-green.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

---

## Features

- Smooth horizontal scrolling text in your terminal
- 7 color options with optional bold
- Time-based exit (`-t`) — no `timeout` command needed
- Loop-count exit (`-l`) — stop after N full passes
- Adjustable scroll speed and padding
- Compatible with bash 3.2+ (macOS default), zsh, Ubuntu, CentOS/RHEL
- Clean exit on `Ctrl+C` — restores cursor automatically

---

## Requirements

- `bash` 3.2 or newer (macOS ships with this; Linux distros ship with 4.x+)
- `bc` — for floating-point sleep delay calculation

### Installing `bc` if missing

```bash
# macOS
brew install bc

# Ubuntu / Debian
sudo apt install bc

# CentOS / RHEL
sudo yum install bc
```

---

## Installation

### macOS / Linux — system-wide (recommended)

```bash
sudo cp marquee.sh /usr/local/bin/marquee
sudo chmod +x /usr/local/bin/marquee
```

Then call it from anywhere as `marquee`.

### Per-user (no sudo required)

```bash
mkdir -p ~/bin
cp marquee.sh ~/bin/marquee
chmod +x ~/bin/marquee
```

Add `~/bin` to your PATH if not already present (add to `~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/bin:$PATH"
```

---

## Usage

```bash
marquee [options] "Your text here"
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-s SPEED` | Scroll speed in milliseconds per step | `80` |
| `-c COLOR` | Text color (see below) | `cyan` |
| `-b` | Bold text | off |
| `-l N` | Stop after N full loops (0 = infinite) | `0` |
| `-p N` | Padding spaces added on each side of text | `10` |
| `-t N` | Stop after N seconds (0 = infinite) | `0` |

### Available Colors

`red` `green` `yellow` `blue` `magenta` `cyan` `white`

---

## Examples

```bash
# Basic usage
marquee "All systems nominal | Uptime 99.9%"

# Stop after 10 seconds
marquee -t 10 "All systems nominal | Uptime 99.9%"

# Bold green, stop after 30 seconds
marquee -t 30 -c green -b "All systems nominal | Uptime 99.9%"

# Fast yellow warning banner
marquee -s 40 -c yellow -b "WARNING: Maintenance window active 22:00–02:00 UTC"

# Slow scroll, loop exactly 5 times then exit
marquee -s 150 -c magenta -l 5 "This message will self-destruct after 5 loops"

# Extra padding, red, timed
marquee -p 20 -c red -t 15 "ALERT: Unauthorized access detected"

# Combine time and loop limits — whichever hits first wins
marquee -t 60 -l 3 -c blue "Scrolling for 60 seconds or 3 loops, whichever comes first"
```

---

## Tips

- Press `Ctrl+C` at any time to exit cleanly — the cursor is always restored.
- `-t` and `-l` can be combined; the first condition to be met stops the script.
- Lower `-s` values = faster scrolling. Try `-s 30` for a fast ticker or `-s 200` for a slow crawl.
- Increase `-p` to add more blank space between loop repetitions so text doesn't run together.

---

## Compatibility

| Platform | Tested |
|----------|--------|
| macOS (bash 3.2, zsh) | ✅ |
| Ubuntu 20.04 / 22.04 / 24.04 | ✅ |
| CentOS 7 / 8 | ✅ |
| Rocky Linux / RHEL | ✅ |
| Debian | ✅ |

---

## License

MIT — free to use, modify, and distribute.
