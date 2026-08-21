#!/usr/bin/env bash
# marquee.sh — Scrolling marquee text for the terminal
# Compatible: macOS (bash 3.2+), Ubuntu, CentOS/RHEL
#
# Usage: ./marquee.sh [options] "Your text here"
#
# Options:
#   -s SPEED    Scroll speed in milliseconds (default: 80)
#   -c COLOR    Text color: red|green|yellow|blue|magenta|cyan|white (default: cyan)
#   -b          Bold text
#   -l LOOPS    Number of loops, 0 = infinite (default: 0)
#   -p PADDING  Spaces of padding on each side (default: 10)
#   -t SECONDS  Stop after this many seconds (default: 0 = infinite)

# ── Defaults ─────────────────────────────────────────────────────────────────
SPEED=80
COLOR="cyan"
BOLD=false
LOOPS=0
PADDING=10
TIMEOUT=0

# ── Color lookup (bash 3.2 compatible — no associative arrays) ────────────────
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
CLEAR_LINE="\r\e[K"

# ── Argument parsing ──────────────────────────────────────────────────────────
while getopts ":s:c:bl:p:t:" opt; do
  case $opt in
    s) SPEED=$OPTARG ;;
    c) COLOR=$OPTARG ;;
    b) BOLD=true ;;
    l) LOOPS=$OPTARG ;;
    p) PADDING=$OPTARG ;;
    t) TIMEOUT=$OPTARG ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    *) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

TEXT="${1:-  *** MARQUEE ***  Bash scrolling text  ***  }"

# ── Validate bc is available ──────────────────────────────────────────────────
if ! command -v bc &>/dev/null; then
  echo "Error: 'bc' is required but not installed. Run: sudo apt install bc  OR  brew install bc" >&2
  exit 1
fi

# ── Build the scroll string ───────────────────────────────────────────────────
PAD=$(printf '%*s' "$PADDING" '')
SCROLL_TEXT="${PAD}${TEXT}${PAD}"
LEN=${#SCROLL_TEXT}

# ── Cleanup on exit ───────────────────────────────────────────────────────────
cleanup() {
  tput cnorm
  printf "${RESET}\n"
  exit 0
}
trap cleanup INT TERM EXIT

# ── Optional timer: send SIGTERM to self after TIMEOUT seconds ────────────────
if [[ $TIMEOUT -gt 0 ]]; then
  ( sleep "$TIMEOUT" && kill -TERM $$ ) &
  TIMER_PID=$!
fi

tput civis  # hide cursor

# ── Main loop ─────────────────────────────────────────────────────────────────
COL=$(tput cols)
DELAY=$(echo "scale=4; $SPEED / 1000" | bc)
COLOR_ESC=$(color_code)

loop_count=0
while true; do
  for (( i=0; i<LEN; i++ )); do
    slice=""
    for (( j=0; j<COL; j++ )); do
      slice+="${SCROLL_TEXT:$(( (i+j) % LEN )):1}"
    done
    printf "${CLEAR_LINE}${COLOR_ESC}%s${RESET}" "$slice"
    sleep "$DELAY"
  done

  (( loop_count++ ))
  if [[ $LOOPS -gt 0 && $loop_count -ge $LOOPS ]]; then
    break
  fi
done

# Kill timer subshell if still running (e.g. -l exited first)
[[ -n "${TIMER_PID:-}" ]] && kill "$TIMER_PID" 2>/dev/null

printf "${CLEAR_LINE}"
