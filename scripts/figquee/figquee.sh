#!/usr/bin/env bash
# figquee.sh — Scrolling figlet marquee for the terminal
# Compatible: macOS (bash 3.2+), Ubuntu, CentOS/RHEL
#
# Requires: figlet
#   macOS:  brew install figlet
#   Ubuntu: sudo apt install figlet
#   CentOS: sudo yum install figlet
#
# Usage: figquee.sh [options] "Your text here"
#
# Options:
#   -s SPEED    Scroll speed in milliseconds (default: 50)
#   -c COLOR    Text color: red|green|yellow|blue|magenta|cyan|white (default: cyan)
#   -b          Bold text
#   -f FONT     Figlet font (default: big)
#   -z SIZE     Size preset: small|medium|large|huge (overrides -f with a preset font)
#   -l LOOPS    Number of loops, 0 = infinite (default: 0)
#   -t SECONDS  Stop after this many seconds (default: 0 = infinite)
#   -p PADDING  Spaces of padding on each side (default: 8)
#   -F          List available figlet fonts and exit

# ── Defaults ──────────────────────────────────────────────────────────────────
SPEED=50
COLOR="cyan"
BOLD=false
FONT="big"
SIZE=""
LOOPS=0
TIMEOUT=0
PADDING=8

# ── Color lookup (bash 3.2 compatible) ───────────────────────────────────────
color_code() {
  local bold=""
  $BOLD && bold="1;"
  local code
  case "$COLOR" in
    red)     code=31 ;;
    green)   code=32 ;;
    yellow)  code=33 ;;
    blue)    code=34 ;;
    magenta) code=35 ;;
    cyan)    code=36 ;;
    white)   code=37 ;;
    *)
      echo "Invalid color '$COLOR'. Choose: red green yellow blue magenta cyan white" >&2
      exit 1
      ;;
  esac
  printf "\e[%s%sm" "$bold" "$code"
}

RESET="\e[0m"
CLEAR_LINE="\e[2K\r"

# ── Argument parsing ──────────────────────────────────────────────────────────
while getopts ":s:c:bf:z:l:t:p:F" opt; do
  case $opt in
    s) SPEED=$OPTARG ;;
    c) COLOR=$OPTARG ;;
    b) BOLD=true ;;
    f) FONT=$OPTARG ;;
    z) SIZE=$OPTARG ;;
    l) LOOPS=$OPTARG ;;
    t) TIMEOUT=$OPTARG ;;
    p) PADDING=$OPTARG ;;
    F) figlet --list-fonts 2>/dev/null || figlet -I2 2>/dev/null; exit 0 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    *) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

TEXT="${1:-Hello World}"

# ── Size presets (map -z to a figlet font) ───────────────────────────────────
if [[ -n "$SIZE" ]]; then
  case "$SIZE" in
    small)  FONT="small" ;;
    medium) FONT="standard" ;;
    large)  FONT="big" ;;
    huge)   FONT="banner3" ;;
    *)
      echo "Invalid size '$SIZE'. Choose: small medium large huge" >&2
      exit 1
      ;;
  esac
fi

# ── Dependency checks ─────────────────────────────────────────────────────────
if ! command -v figlet &>/dev/null; then
  echo "Error: 'figlet' is required but not installed." >&2
  echo "  macOS:  brew install figlet" >&2
  echo "  Ubuntu: sudo apt install figlet" >&2
  echo "  CentOS: sudo yum install figlet" >&2
  exit 1
fi

if ! command -v bc &>/dev/null; then
  echo "Error: 'bc' is required but not installed." >&2
  exit 1
fi

# ── Generate figlet output ────────────────────────────────────────────────────
FIGLET_OUT=$(figlet -f "$FONT" "$TEXT" 2>/dev/null)
if [[ $? -ne 0 || -z "$FIGLET_OUT" ]]; then
  echo "Error: figlet failed. Check that font '$FONT' is installed." >&2
  exit 1
fi

# Split into lines array (bash 3.2 compatible)
IFS=$'\n' read -rd '' -a LINES <<< "$FIGLET_OUT" || true

# Remove trailing blank lines
while [[ ${#LINES[@]} -gt 0 && -z "${LINES[${#LINES[@]}-1]}" ]]; do
  unset 'LINES[${#LINES[@]}-1]'
done

NUM_LINES=${#LINES[@]}

if [[ $NUM_LINES -eq 0 ]]; then
  echo "Error: figlet produced no output." >&2
  exit 1
fi

# ── Pad each line to equal width, then add side padding ──────────────────────
PAD=$(printf '%*s' "$PADDING" '')

# Find max line length
MAX_LEN=0
for line in "${LINES[@]}"; do
  [[ ${#line} -gt $MAX_LEN ]] && MAX_LEN=${#line}
done

# Pad all lines to same width + side padding
PADDED=()
for line in "${LINES[@]}"; do
  # Right-pad line to MAX_LEN, then add side padding
  printf -v padded "%-${MAX_LEN}s" "$line"
  PADDED+=("${PAD}${padded}${PAD}")
done

SCROLL_LEN=${#PADDED[0]}

# ── Cleanup on exit ───────────────────────────────────────────────────────────
cleanup() {
  tput cnorm
  printf "${RESET}\n"
  exit 0
}
trap cleanup INT TERM EXIT

# ── Optional timer ────────────────────────────────────────────────────────────
if [[ $TIMEOUT -gt 0 ]]; then
  ( sleep "$TIMEOUT" && kill -TERM $$ ) &
  TIMER_PID=$!
fi

tput civis  # hide cursor

# ── Main loop ─────────────────────────────────────────────────────────────────
COL=$(tput cols)
DELAY=$(echo "scale=4; $SPEED / 1000" | bc)
COLOR_ESC=$(color_code)

# Print blank lines to reserve space for all figlet rows
for (( i=0; i<NUM_LINES; i++ )); do
  echo ""
done

loop_count=0
while true; do
  for (( i=0; i<SCROLL_LEN; i++ )); do
    # Move cursor up to the first figlet line
    tput cuu "$NUM_LINES"

    # Print each line of the figlet, sliced at scroll position
    for (( row=0; row<NUM_LINES; row++ )); do
      line="${PADDED[$row]}"
      len=${#line}

      slice=""
      for (( j=0; j<COL; j++ )); do
        pos=$(( (i+j) % len ))
        slice+="${line:$pos:1}"
      done

      printf "${CLEAR_LINE}${COLOR_ESC}%s${RESET}\n" "$slice"
    done

    sleep "$DELAY"
  done

  (( loop_count++ ))
  if [[ $LOOPS -gt 0 && $loop_count -ge $LOOPS ]]; then
    break
  fi
done

[[ -n "${TIMER_PID:-}" ]] && kill "$TIMER_PID" 2>/dev/null
