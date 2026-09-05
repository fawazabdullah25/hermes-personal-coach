#!/usr/bin/env bash
# hermes-personal-coach installer — bash >= 3.2, coreutils only.
# Installs CODE to $HERMES_HOME/skills/personal-coach and creates the DATA dir
# at $HERMES_HOME/personal-coach. Never touches SOUL.md, config.yaml, MEMORY.md.
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
mkdir -p "$DATA_DIR/logs/weekly" "$DATA_DIR/logs/archive" "$DATA_DIR/backups"
[ -f "$DATA_DIR/STATE.md" ] || cp "$SRC_DIR/templates/STATE.md" "$DATA_DIR/STATE.md"
chmod 700 "$DATA_DIR" 2>/dev/null || true
info "data directory ready at $DATA_DIR"

# 5. Hygiene: the skill dir must never contain data files
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
  ============================================================
EOF
