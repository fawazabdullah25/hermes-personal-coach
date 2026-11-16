#!/usr/bin/env bash
# personal-coach helper — deterministic date maths, silence detection and
# weekly statistics, so the model never has to do them in its head.
# bash >= 3.2 + coreutils (GNU or BSD date). Installed to DATA_DIR/bin/coach.sh.
#
# Usage: coach.sh <now|seen|week|due [days]|archive [days]>
# Every line of output is KEY=value, safe to read back verbatim.
set -u

DATA_DIR="${COACH_DATA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
STATE="$DATA_DIR/STATE.md"
CONFIG="$DATA_DIR/COACH_CONFIG.md"
COMMITS="$DATA_DIR/COMMITMENTS.md"
LOGS="$DATA_DIR/logs"

# --- portable date helpers ---------------------------------------------------
if date -d "@0" +%s >/dev/null 2>&1; then GNU_DATE=1; else GNU_DATE=0; fi

days_ago() {  # days_ago N -> YYYY-MM-DD   (N may be negative for the future)
  if [ "$GNU_DATE" = 1 ]; then date -d "$1 days ago" +%F
  else
    if [ "$1" -ge 0 ]; then date -v-"$1"d +%F; else date -v+"$(( -$1 ))"d +%F; fi
  fi
}
to_epoch() {  # to_epoch YYYY-MM-DD -> epoch seconds at local midnight
  if [ "$GNU_DATE" = 1 ]; then date -d "$1" +%s 2>/dev/null
  else date -j -f "%Y-%m-%d %H:%M:%S" "$1 00:00:00" +%s 2>/dev/null; fi
}
dow_of() {    # dow_of YYYY-MM-DD -> Mon..Sun
  if [ "$GNU_DATE" = 1 ]; then LC_ALL=C date -d "$1" +%a 2>/dev/null
  else LC_ALL=C date -j -f "%Y-%m-%d" "$1" +%a 2>/dev/null; fi
}

# --- file helpers ------------------------------------------------------------
cfg() {       # cfg "Key Name" [file] -> value of "- **Key Name**: value" or "- Key Name: value"
  f="${2:-$CONFIG}"
  [ -f "$f" ] || { echo ""; return; }
  grep -m1 -E "^- (\*\*)?$1(\*\*)?:" "$f" 2>/dev/null \
    | sed -E 's/^- (\*\*)?[^:]*(\*\*)?:[[:space:]]*//; s/[[:space:]]+$//'
}
set_line() {  # set_line file "Key" "value"  — replace or append "- Key: value"
  f="$1"; k="$2"; v="$3"; tmp="$f.tmp.$$"
  [ -f "$f" ] || printf '# Coach State\n' > "$f"
  if grep -q -E "^- (\*\*)?$k(\*\*)?:" "$f"; then
    awk -v k="$k" -v v="$v" '
      BEGIN { done = 0 }
      {
        line = $0; probe = line; gsub(/\*\*/, "", probe)
        if (!done && index(probe, "- " k ":") == 1) { print "- " k ": " v; done = 1 }
        else print line
      }' "$f" > "$tmp" && mv "$tmp" "$f"
  else
    printf -- '- %s: %s\n' "$k" "$v" >> "$f"
  fi
}
hm_to_min() { # "07:30" -> 450 ; anything else -> -1
  case "$1" in
    [0-2][0-9]:[0-5][0-9]) echo $(( 10#${1%%:*} * 60 + 10#${1##*:} )) ;;
    *) echo -1 ;;
  esac
}
in_window() { # in_window NOW_MIN START END (minutes; window may wrap midnight) -> yes|no
  n="$1"; s="$2"; e="$3"
  if [ "$s" -lt 0 ] || [ "$e" -lt 0 ] || [ "$s" -eq "$e" ]; then echo no; return; fi
  if [ "$s" -lt "$e" ]; then
    if [ "$n" -ge "$s" ] && [ "$n" -lt "$e" ]; then echo yes; else echo no; fi
  else
    if [ "$n" -ge "$s" ] || [ "$n" -lt "$e" ]; then echo yes; else echo no; fi
  fi
}

# --- commands ----------------------------------------------------------------
cmd_now() {
  today="$(date +%F)"; now_hm="$(date +%H:%M)"; now_epoch="$(date +%s)"
  echo "TODAY=$today"
  echo "DOW=$(LC_ALL=C date +%a)"
  echo "NOW=$now_hm"
  echo "TZ=$(date '+%Z %z')"
  echo "YESTERDAY=$(days_ago 1)"
  echo "WEEK=$(date +%G-W%V)"
  echo "LOG=logs/$today.md"
  echo "YLOG=logs/$(days_ago 1).md"

  last="$(cfg 'Last User Epoch' "$STATE")"
  case "$last" in
    ''|0|*[!0-9]*) echo "HOURS_SILENT=unknown" ;;
    *) echo "HOURS_SILENT=$(( (now_epoch - last) / 3600 ))" ;;
  esac
  echo "SILENT_CYCLES=$(cfg 'Silent Cycles' "$STATE" | grep -E '^[0-9]+$' || echo 0)"

  now_min="$(hm_to_min "$now_hm")"
  bed="$(hm_to_min "$(cfg 'Bed Time')")"; wake="$(hm_to_min "$(cfg 'Wake Time')")"
  # QUIET = between bed time and wake time: never message or call inside it.
  echo "QUIET=$(in_window "$now_min" "$bed" "$wake")"
  # CALL_OK = inside "Call Hours: HH:MM-HH:MM" (weekends use Weekend Call Hours if set).
  hours="$(cfg 'Call Hours')"
  case "$(LC_ALL=C date +%a)" in
    Sat|Sun) wk="$(cfg 'Weekend Call Hours')"; case "$wk" in *:*-*:*) hours="$wk" ;; esac ;;
  esac
  case "$hours" in
    *:*-*:*) echo "CALL_OK=$(in_window "$now_min" "$(hm_to_min "${hours%%-*}")" "$(hm_to_min "${hours##*-}")")" ;;
    *) echo "CALL_OK=no" ;;
  esac
}

cmd_seen() {  # the user just sent a message: reset the silence counters
  set_line "$STATE" "Last User Message" "$(date '+%F %H:%M')"
  set_line "$STATE" "Last User Epoch" "$(date +%s)"
  set_line "$STATE" "Silent Cycles" "0"
  set_line "$STATE" "Escalation Step" "0"
  echo "SEEN=$(date '+%F %H:%M')"
}

cmd_week() {  # statistics over the last 7 calendar days (today included)
  logged=0; scored=0; done_sum=0; plan_sum=0; asked=0; replied=0
  score_sum="0"; best=""; best_s=""; worst=""; worst_s=""
  i=6
  while [ "$i" -ge 0 ]; do
    d="$(days_ago "$i")"; f="$LOGS/$d.md"; i=$(( i - 1 ))
    [ -f "$f" ] || continue
    logged=$(( logged + 1 ))
    cr="$(grep -m1 -E '^- Completion Rate:' "$f" | sed -E 's/^[^:]*:[[:space:]]*//')"
    case "$cr" in
      [0-9]*/[0-9]*)
        done_sum=$(( done_sum + 10#${cr%%/*} ))
        rest="${cr##*/}"; rest="${rest%%[!0-9]*}"
        plan_sum=$(( plan_sum + 10#${rest:-0} )) ;;
    esac
    sc="$(grep -m1 -E '^- Evening Score:' "$f" | sed -E 's/^[^:]*:[[:space:]]*//; s/[[:space:]].*$//')"
    case "$sc" in
      [1-5]|[1-5].[0-9]|[1-5].[0-9][0-9])
        scored=$(( scored + 1 ))
        score_sum="$(awk -v a="$score_sum" -v b="$sc" 'BEGIN { printf "%.2f", a + b }')"
        if [ -z "$best_s" ] || awk -v a="$sc" -v b="$best_s" 'BEGIN { exit !(a > b) }'; then best="$d"; best_s="$sc"; fi
        if [ -z "$worst_s" ] || awk -v a="$sc" -v b="$worst_s" 'BEGIN { exit !(a < b) }'; then worst="$d"; worst_s="$sc"; fi ;;
    esac
    a="$(grep -c -E '^- (Morning|Midday|Evening) Reply: (yes|no)' "$f" 2>/dev/null)"; a="${a:-0}"
    r="$(grep -c -E '^- (Morning|Midday|Evening) Reply: yes' "$f" 2>/dev/null)"; r="${r:-0}"
    asked=$(( asked + a )); replied=$(( replied + r ))
  done
  echo "DAYS_LOGGED=$logged/7"
  echo "COMPLETED=$done_sum/$plan_sum"
  if [ "$plan_sum" -gt 0 ]; then echo "EXECUTION_SCORE=$(( done_sum * 100 / plan_sum ))%"
  else echo "EXECUTION_SCORE=n/a"; fi
  if [ "$scored" -gt 0 ]; then
    echo "AVG_SCORE=$(awk -v s="$score_sum" -v n="$scored" 'BEGIN { printf "%.1f", s / n }') ($scored days rated)"
    echo "BEST_DAY=$best $(dow_of "$best") ($best_s)"
    echo "HARDEST_DAY=$worst $(dow_of "$worst") ($worst_s)"
  else
    echo "AVG_SCORE=n/a"
  fi
  if [ "$asked" -gt 0 ]; then echo "REPLIED=$replied/$asked check-ins"; else echo "REPLIED=n/a"; fi
}

cmd_due() {   # open commitments due within N days (default 3), plus overdue ones
  horizon="${1:-3}"
  [ -f "$COMMITS" ] || { echo "DUE_COUNT=0"; echo "OPEN_COUNT=0"; return; }
  today_e="$(to_epoch "$(date +%F)")"; n=0; open=0
  # table rows: | ID | What | Due | Type | Status | Stake | Calendar |
  while IFS='|' read -r _ id what due _type status _rest; do
    id="$(echo "$id" | tr -d '[:space:]')"
    case "$id" in C[0-9]*) ;; *) continue ;; esac
    status="$(echo "$status" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')"
    [ "$status" = "open" ] || continue
    open=$(( open + 1 ))
    due="$(echo "$due" | tr -d '[:space:]')"; day="${due%%T*}"
    case "$day" in [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;; *) continue ;; esac
    de="$(to_epoch "$day")"; [ -n "$de" ] || continue
    diff=$(( (de - today_e) / 86400 ))
    [ "$diff" -le "$horizon" ] || continue
    what="$(echo "$what" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
    n=$(( n + 1 ))
    if [ "$diff" -lt 0 ]; then when="overdue by $(( -diff ))d"
    elif [ "$diff" -eq 0 ]; then when="today"
    elif [ "$diff" -eq 1 ]; then when="tomorrow"
    else when="in ${diff}d ($(dow_of "$day"))"; fi
    echo "DUE_$n=$id | $what | $due | $when"
  done < "$COMMITS"
  echo "DUE_COUNT=$n"
  echo "OPEN_COUNT=$open"
}

cmd_archive() {  # move daily logs older than N days (default 56) to logs/archive
  keep="${1:-56}"; cut="$(days_ago "$keep")"; moved=0
  mkdir -p "$LOGS/archive"
  for f in "$LOGS"/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].md; do
    [ -f "$f" ] || continue
    b="$(basename "$f" .md)"
    if [ "$b" \< "$cut" ]; then mv "$f" "$LOGS/archive/" && moved=$(( moved + 1 )); fi
  done
  echo "ARCHIVED_NOW=$moved"
  echo "ARCHIVE_TOTAL=$(find "$LOGS/archive" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')"
}

case "${1:-}" in
  now)     cmd_now ;;
  seen)    cmd_seen ;;
  week)    cmd_week ;;
  due)     cmd_due "${2:-3}" ;;
  archive) cmd_archive "${2:-56}" ;;
  *) echo "usage: coach.sh <now|seen|week|due [days]|archive [days]>" >&2; exit 2 ;;
esac
