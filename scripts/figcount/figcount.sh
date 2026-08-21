#!/usr/bin/env bash
# figcount.sh — Full-screen figlet countdown timer
# Compatible: macOS (bash 3.2+), Ubuntu, CentOS/RHEL
#
# Requires: figlet
#   macOS:  brew install figlet
#   Ubuntu: sudo apt install figlet
#   CentOS: sudo yum install figlet
#
# Usage: figcount.sh [options]
#
# Options:
#   -n N        Start countdown from N (default: 10)
#   -c COLOR    Text color: red|green|yellow|blue|magenta|cyan|white (default: cyan)
#   -b          Bold text
#   -f FONT     Figlet font (default: colossal)
#   -z SIZE     Size preset: small|medium|large|huge (overrides -f)
#   -m MESSAGE  Message to flash when countdown hits 0 (default: GO!)
#   -s STYLE    Flash style: flash|fade|slam (default: slam)
#   -p          Play a beep each second (if terminal supports it)

# ── Defaults ──────────────────────────────────────────────────────────────────
COUNT=10
COLOR="cyan"
BOLD=false
FONT="colossal"
SIZE=""
MESSAGE="GO!"
STYLE="slam"
BEEP=false

# ── Color lookup ──────────────────────────────────────────────────────────────
color_code() {
  local c="$1"
  local bold=""
  $BOLD && bold="1;"
  local code
  case "$c" in
    red)     code=31 ;;
    green)   code=32 ;;
    yellow)  code=33 ;;
    blue)    code=34 ;;
    magenta) code=35 ;;
    cyan)    code=36 ;;
    white)   code=37 ;;
    *)       code=36 ;;
  esac
  printf "\e[%s%sm" "$bold" "$code"
}

# Color sequence for flash style (cycles through dramatic colors)
flash_color() {
  local n=$1
  local colors=(red yellow green cyan blue magenta white red yellow green)
  local idx=$(( (COUNT - n) % 10 ))
  color_code "${colors[$idx]}"
}

RESET="\e[0m"

# ── Argument parsing ──────────────────────────────────────────────────────────
while getopts ":n:c:bf:z:m:s:p" opt; do
  case $opt in
    n) COUNT=$OPTARG ;;
    c) COLOR=$OPTARG ;;
    b) BOLD=true ;;
    f) FONT=$OPTARG ;;
    z) SIZE=$OPTARG ;;
    m) MESSAGE=$OPTARG ;;
    s) STYLE=$OPTARG ;;
    p) BEEP=true ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    *) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# ── Size presets ──────────────────────────────────────────────────────────────
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

# ── Dependency check ──────────────────────────────────────────────────────────
if ! command -v figlet &>/dev/null; then
  echo "Error: 'figlet' is required but not installed." >&2
  echo "  macOS:  brew install figlet" >&2
  echo "  Ubuntu: sudo apt install figlet" >&2
  echo "  CentOS: sudo yum install figlet" >&2
  exit 1
fi

# ── Terminal dimensions ───────────────────────────────────────────────────────
ROWS=$(tput lines)
COLS=$(tput cols)

# ── Render a string centered on screen ───────────────────────────────────────
render_centered() {
  local text="$1"
  local color_esc="$2"

  local figout
  figout=$(figlet -f "$FONT" -w "$COLS" "$text" 2>/dev/null)

  # Split into lines
  IFS=$'\n' read -rd '' -a lines <<< "$figout" || true

  # Remove trailing blank lines
  while [[ ${#lines[@]} -gt 0 && -z "${lines[${#lines[@]}-1]}" ]]; do
    unset 'lines[${#lines[@]}-1]'
  done

  local num_lines=${#lines[@]}
  local max_w=0
  for line in "${lines[@]}"; do
    [[ ${#line} -gt $max_w ]] && max_w=${#line}
  done

  # Calculate vertical centering
  local top_pad=$(( (ROWS - num_lines) / 2 ))
  local left_pad=$(( (COLS - max_w) / 2 ))
  [[ $left_pad -lt 0 ]] && left_pad=0

  # Clear screen and position
  clear

  # Print top padding
  local i
  for (( i=0; i<top_pad; i++ )); do
    echo ""
  done

  # Print each line centered
  local pad
  printf -v pad '%*s' "$left_pad" ''
  for line in "${lines[@]}"; do
    printf "${color_esc}%s%s${RESET}\n" "$pad" "$line"
  done
}

# ── Flash effect — rapid color cycling ───────────────────────────────────────
do_flash() {
  local text="$1"
  local flash_colors=(red yellow white red yellow white)
  local c
  for c in "${flash_colors[@]}"; do
    render_centered "$text" "$(color_code "$c")"
    sleep 0.08
  done
}

# ── Slam effect — number slams in from top ────────────────────────────────────
do_slam() {
  local text="$1"
  local color_esc="$2"

  local figout
  figout=$(figlet -f "$FONT" -w "$COLS" "$text" 2>/dev/null)

  IFS=$'\n' read -rd '' -a lines <<< "$figout" || true
  while [[ ${#lines[@]} -gt 0 && -z "${lines[${#lines[@]}-1]}" ]]; do
    unset 'lines[${#lines[@]}-1]'
  done

  local num_lines=${#lines[@]}
  local max_w=0
  for line in "${lines[@]}"; do
    [[ ${#line} -gt $max_w ]] && max_w=${#line}
  done

  local final_top=$(( (ROWS - num_lines) / 2 ))
  local left_pad=$(( (COLS - max_w) / 2 ))
  [[ $left_pad -lt 0 ]] && left_pad=0

  local pad
  printf -v pad '%*s' "$left_pad" ''

  # Slam: slide from row 1 down to final position quickly
  local step
  for (( step=1; step<=final_top; step+=3 )); do
    clear
    local i
    for (( i=0; i<step; i++ )); do echo ""; done
    for line in "${lines[@]}"; do
      printf "${color_esc}%s%s${RESET}\n" "$pad" "$line"
    done
    sleep 0.03
  done

  # Land on final position
  render_centered "$text" "$color_esc"
}

# ── Cleanup ───────────────────────────────────────────────────────────────────
cleanup() {
  tput cnorm
  tput rmcup       # restore original screen
  exit 0
}
trap cleanup INT TERM EXIT

# ── Save screen and hide cursor ───────────────────────────────────────────────
tput smcup        # save original screen
tput civis        # hide cursor

# ── Countdown loop ────────────────────────────────────────────────────────────
n=$COUNT
while [[ $n -gt 0 ]]; do
  ROWS=$(tput lines)
  COLS=$(tput cols)

  # Pick color based on style and count
  if [[ "$STYLE" == "flash" ]]; then
    COL_ESC=$(flash_color "$n")
  else
    # Transition: cyan → yellow → red as countdown gets low
    if [[ $n -gt $(( COUNT * 2 / 3 )) ]]; then
      COL_ESC=$(color_code "cyan")
    elif [[ $n -gt $(( COUNT / 3 )) ]]; then
      COL_ESC=$(color_code "yellow")
    else
      COL_ESC=$(color_code "red")
    fi
    $BOLD && COL_ESC="\e[1m${COL_ESC}"
  fi

  case "$STYLE" in
    slam)  do_slam "$n" "$COL_ESC" ;;
    flash) do_flash "$n" ;;
    fade)  render_centered "$n" "$COL_ESC" ;;
    *)     render_centered "$n" "$COL_ESC" ;;
  esac

  $BEEP && printf "\a"

  sleep 1
  (( n-- ))
done

# ── Final message ─────────────────────────────────────────────────────────────
ROWS=$(tput lines)
COLS=$(tput cols)

case "$STYLE" in
  slam)
    do_slam "$MESSAGE" "$(color_code green)"
    ;;
  flash)
    do_flash "$MESSAGE"
    render_centered "$MESSAGE" "$(color_code green)"
    ;;
  *)
    render_centered "$MESSAGE" "$(color_code green)"
    ;;
esac

$BEEP && printf "\a\a\a"

tput cnorm
sleep 2
