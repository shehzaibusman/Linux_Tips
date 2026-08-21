# figquee.sh

A terminal marquee scroller for [figlet](http://www.figlet.org/) ASCII art text. Unlike piping figlet directly into `marquee.sh`, `figquee.sh` keeps all lines of the ASCII art in sync — scrolling as one cohesive block across your terminal.

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell: Bash](https://img.shields.io/badge/shell-bash-green.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

---

## Requirements

- `bash` 3.2 or newer (macOS default; Linux distros ship 4.x+)
- `figlet` — generates the ASCII art text
- `bc` — for floating-point scroll delay

### Installing dependencies

```bash
# macOS
brew install figlet

# Ubuntu / Debian
sudo apt install figlet bc

# CentOS / RHEL
sudo yum install figlet bc
```

---

## Installation

### System-wide (recommended)

```bash
sudo cp figquee.sh /usr/local/bin/figquee
sudo chmod +x /usr/local/bin/figquee
```

### Per-user (no sudo required)

```bash
mkdir -p ~/bin
cp figquee.sh ~/bin/figquee
chmod +x ~/bin/figquee
```

Add `~/bin` to your PATH if not already (add to `~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/bin:$PATH"
source ~/.zshrc
```

---

## Usage

```bash
figquee [options] "Your text here"
```

### Options

| Flag | Description | Default |
|------|-------------|---------|
| `-s SPEED` | Scroll speed in milliseconds per step | `50` |
| `-c COLOR` | Text color (see below) | `cyan` |
| `-b` | Bold text | off |
| `-z SIZE` | Size preset: `small medium large huge` | — |
| `-f FONT` | Any figlet font name | `big` |
| `-l N` | Stop after N full loops (0 = infinite) | `0` |
| `-t N` | Stop after N seconds (0 = infinite) | `0` |
| `-p N` | Padding spaces added on each side | `8` |
| `-F` | List all available figlet fonts and exit | — |

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

## Examples

```bash
# Basic usage
figquee "Hello World"

# Small size, stop after 10 seconds
figquee -z small -t 10 "Hello World"

# Huge bold green, loop 3 times
figquee -z huge -c green -b -l 3 "ONLINE"

# Specific font with yellow color
figquee -f colossal -c yellow "Hello World"

# Fast cyberpunk style, timed
figquee -f cyberlarge -c magenta -s 30 -t 20 "Hello World"

# Slow and dramatic
figquee -f banner3 -s 120 -c red "WARNING"

# List all available fonts
figquee -F
```

---

## Popular Fonts

Preview any font quickly with:
```bash
figlet -f <fontname> "Hello"
```

**Big & Bold** — best for banners
```
banner, banner3, block, colossal
```

**Clean & Readable** — best for most uses
```
big (default), standard, small, mini
```

**Techy / Hacker style**
```
cyberlarge, cybermedium, digital, morse, binary
```

**3D / Decorative**
```
3-d, 3d-ascii, alligator, alligator2
```

**Slim / Minimal**
```
thin, term, ascii_new_roman
```

Preview several at once:
```bash
for font in big standard banner block colossal cyberlarge digital small thin; do
  echo "--- $font ---"
  figlet -f $font "Hello"
done
```

---

## Tips

- Press `Ctrl+C` or let `-t`/`-l` stop it — the last frame stays on screen and your prompt appears below.
- Lower `-s` = faster scroll. Try `-s 30` for a fast ticker or `-s 150` for a slow crawl.
- `-z huge` with a short word like `ONLINE` or `READY` fills the terminal dramatically.
- `-t` and `-l` can be combined; whichever condition hits first stops the script.
- Use `-F` to browse all fonts installed with figlet on your system.

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

- [marquee.sh](../marquee/) — single-line terminal marquee scroller, no figlet required

---

## License

MIT — free to use, modify, and distribute.
