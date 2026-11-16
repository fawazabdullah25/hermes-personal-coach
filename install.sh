#!/usr/bin/env bash
# hermes-personal-coach installer — bash >= 3.2, coreutils only.
# Installs CODE to $HERMES_HOME/skills/personal-coach and creates the DATA dir
# at $HERMES_HOME/personal-coach. Never touches SOUL.md, config.yaml, MEMORY.md.
# Upgrades from 1.x keep all data: missing config keys and new files are added.
set -euo pipefail

SKILL_NAME="personal-coach"
MODE="copy"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$REPO_DIR/skill"

usage() {
  cat <<EOF
Usage: ./install.sh [--link] [--hermes-home DIR]
  --link         symlink the repo's skill/ dir instead of copying (developers)
  --hermes-home  Hermes home (default: \$HERMES_HOME or ~/.hermes)
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --link) MODE="link" ;;
    --hermes-home) shift; HERMES_HOME="$1" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

SKILL_DIR="$HERMES_HOME/skills/$SKILL_NAME"
DATA_DIR="$HERMES_HOME/$SKILL_NAME"
TS="$(date +%Y%m%d-%H%M%S)"
VERSION="$(cat "$REPO_DIR/VERSION")"

info() { printf '  [coach] %s\n' "$*"; }
die()  { printf '  [coach] ERROR: %s\n' "$*" >&2; exit 1; }

# 1. Preconditions
[ -d "$HERMES_HOME" ] || die "Hermes home not found at $HERMES_HOME. Install Hermes Agent first."
[ -f "$SRC_DIR/SKILL.md" ] || die "skill/SKILL.md not found — run this script from the repo root."
mkdir -p "$HERMES_HOME/skills"

# 2. Legacy layout migration (early builds kept data inside the skill dir)
migrate_legacy() {
  for f in COACH_CONFIG.md GOALS.md HABITS.md STATE.md; do
    if [ -f "$SKILL_DIR/$f" ] && [ ! -f "$DATA_DIR/$f" ]; then
      mkdir -p "$DATA_DIR"; mv "$SKILL_DIR/$f" "$DATA_DIR/$f"; info "migrated $f -> $DATA_DIR"
    fi
  done
  if [ -d "$SKILL_DIR/logs" ] && [ ! -L "$SKILL_DIR" ] && [ ! -d "$DATA_DIR/logs" ]; then
    mkdir -p "$DATA_DIR"; mv "$SKILL_DIR/logs" "$DATA_DIR/logs"; info "migrated logs/ -> $DATA_DIR"
  fi
}

# 3. Install code
if [ -e "$SKILL_DIR" ] || [ -L "$SKILL_DIR" ]; then
  migrate_legacy
  if [ -L "$SKILL_DIR" ]; then
    rm "$SKILL_DIR"; info "removed old symlink"
  else
    mv "$SKILL_DIR" "$SKILL_DIR.bak.$TS"; info "previous install backed up to $SKILL_DIR.bak.$TS"
  fi
fi

if [ "$MODE" = "link" ]; then
  ln -s "$SRC_DIR" "$SKILL_DIR"; info "symlinked $SRC_DIR -> $SKILL_DIR"
else
  mkdir -p "$SKILL_DIR"
  cp -R "$SRC_DIR/." "$SKILL_DIR/"
  cp "$REPO_DIR/LICENSE" "$SKILL_DIR/LICENSE"
  cp "$REPO_DIR/VERSION" "$SKILL_DIR/VERSION"
  info "copied skill v$VERSION to $SKILL_DIR"
fi

# 4. Data directory (never overwrite existing user data)
mkdir -p "$DATA_DIR/logs/weekly" "$DATA_DIR/logs/archive" "$DATA_DIR/backups" \
         "$DATA_DIR/briefs" "$DATA_DIR/docs" "$DATA_DIR/bin"
for f in STATE.md CONTRACT.md COMMITMENTS.md; do
  [ -f "$DATA_DIR/$f" ] || cp "$SRC_DIR/templates/$f" "$DATA_DIR/$f"
done
chmod 700 "$DATA_DIR" 2>/dev/null || true

# Helper script lives in the data dir: it is the one path that is identical
# for the host and for a sandboxed agent terminal.
cp "$SRC_DIR/scripts/coach.sh" "$DATA_DIR/bin/coach.sh"
chmod 755 "$DATA_DIR/bin/coach.sh"
info "data directory ready at $DATA_DIR"

# 5. Tell the skill the absolute data path (a sandbox may remap "~")
printf 'DATA_DIR=%s\n' "$DATA_DIR" > "$SKILL_DIR/LOCAL.md"
info "recorded data path in $SKILL_DIR/LOCAL.md"

# 6. Migration: add keys that newer versions expect, keep every existing value
add_missing_keys() {  # add_missing_keys <template> <user file>
  tpl="$1"; usr="$2"; added=0
  [ -f "$usr" ] || return 0
  while IFS= read -r line; do
    case "$line" in "- "*:*) ;; *) continue ;; esac
    key="$(printf '%s' "$line" | sed -E 's/^- (\*\*)?([^:*]+)(\*\*)?:.*/\2/')"
    if ! grep -q -E "^- (\*\*)?$key(\*\*)?:" "$usr"; then
      if [ "$added" -eq 0 ]; then printf '\n## Added by upgrade to v%s\n' "$VERSION" >> "$usr"; fi
      printf '%s\n' "$line" >> "$usr"; added=$((added + 1))
    fi
  done < "$tpl"
  if [ "$added" -gt 0 ]; then info "added $added new setting(s) to $(basename "$usr")"; fi
  return 0
}
add_missing_keys "$SRC_DIR/templates/COACH_CONFIG.md" "$DATA_DIR/COACH_CONFIG.md"
add_missing_keys "$SRC_DIR/templates/STATE.md" "$DATA_DIR/STATE.md"

UPGRADE_NOTE=""
if [ -f "$DATA_DIR/COACH_CONFIG.md" ] && ! grep -q -E '^- (\*\*)?Version(\*\*)?: 2\.' "$DATA_DIR/COACH_CONFIG.md"; then
  UPGRADE_NOTE="yes"
fi

# 7. Hygiene: the skill dir must never contain data files
for f in COACH_CONFIG.md GOALS.md HABITS.md; do
  [ -e "$SKILL_DIR/$f" ] && die "unexpected data file $f inside skill dir — aborting to protect it"
done

cat <<EOF

  ============================================================
   hermes-personal-coach v$VERSION installed
   code : $SKILL_DIR
   data : $DATA_DIR
  ------------------------------------------------------------
   1. Restart the gateway so it registers the command:

          hermes gateway restart

   2. Open the chat where you want check-ins delivered
      (WhatsApp, Telegram, Discord, Slack, the CLI, etc...) and send:

          /personal-coach setup        (or: coach setup)

   Verify with /commands — look for /personal-coach.

   Agent terminal in Docker or another sandbox? Mount the data
   directory at the SAME path inside it (README: "Docker and
   sandboxes"), or check-in answers will not be saved.
  ============================================================
EOF

if [ -n "$UPGRADE_NOTE" ]; then
  cat <<EOF

  [coach] Upgrading from 1.x: your goals, habits and logs are untouched.
  [coach] After the gateway restart, send  /personal-coach setup  once in
  [coach] your coaching chat. It asks three new questions and re-registers
  [coach] the cron jobs (adds the follow-up job). Until then v1 jobs keep running.
EOF
fi
