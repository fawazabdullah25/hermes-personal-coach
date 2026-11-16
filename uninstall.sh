#!/usr/bin/env bash
# hermes-personal-coach uninstaller.
# 1) removes registered coach cron jobs via `hermes cron`, 2) removes code,
# 3) optionally removes data. Refuses to delete while cron jobs remain (unless --force).
set -euo pipefail

SKILL_NAME="personal-coach"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
ASSUME_YES="no"; FORCE="no"; DATA_ACTION="ask"

usage() {
  cat <<EOF
Usage: ./uninstall.sh [-y] [--force] [--keep-data|--purge-data] [--hermes-home DIR]
  -y            answer yes to prompts (data is still KEPT unless --purge-data)
  --force       delete files even if cron jobs could not be removed
  --keep-data   keep the data directory (goals, logs)
  --purge-data  delete the data directory
EOF
}
while [ $# -gt 0 ]; do
  case "$1" in
    -y) ASSUME_YES="yes" ;;
    --force) FORCE="yes" ;;
    --keep-data) DATA_ACTION="keep" ;;
    --purge-data) DATA_ACTION="purge" ;;
    --hermes-home) shift; HERMES_HOME="$1" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

SKILL_DIR="$HERMES_HOME/skills/$SKILL_NAME"
DATA_DIR="$HERMES_HOME/$SKILL_NAME"
CONFIG="$DATA_DIR/COACH_CONFIG.md"
JOBS_FILE="$HERMES_HOME/cron/jobs.json"

info() { printf '  [coach] %s\n' "$*"; }
warn() { printf '  [coach] WARNING: %s\n' "$*" >&2; }
confirm() {
  [ "$ASSUME_YES" = "yes" ] && return 0
  printf '  [coach] %s [y/N] ' "$1"; read -r a
  case "$a" in y|Y|yes|YES) return 0 ;; *) return 1 ;; esac
}
have_hermes() { command -v hermes >/dev/null 2>&1; }

# --- 1. Collect cron IDs from config ----------------------------------------
IDS=""
if [ -f "$CONFIG" ]; then
  IDS="$(grep -E '^- (Morning|Midday|Evening|Daily|Weekly|Nudge AM|Nudge PM) Cron ID:' "$CONFIG" \
        | sed -E 's/^[^:]*:[[:space:]]*//' | grep -v '^none$' || true)"
fi

# --- 2. Remove jobs through the Hermes CLI ----------------------------------
job_exists() {  # by id, checking CLI list then the on-disk store
  if have_hermes && hermes cron list 2>/dev/null | grep -q -- "$1"; then return 0; fi
  [ -f "$JOBS_FILE" ] && grep -q -- "$1" "$JOBS_FILE" && return 0
  return 1
}

REMAINING=""
if [ -n "$IDS" ]; then
  info "registered cron IDs: $(echo "$IDS" | tr '\n' ' ')"
  for id in $IDS; do
    if have_hermes && hermes cron remove "$id" >/dev/null 2>&1; then
      info "removed cron job $id"
    elif job_exists "$id"; then
      REMAINING="$REMAINING $id"; warn "could not remove $id"
    else
      info "cron job $id not found (already removed)"
    fi
  done
else
  info "no active cron IDs recorded in COACH_CONFIG.md"
fi

# Orphan sweep: any job named coach-* that the config lost track of
if have_hermes && [ -f "$JOBS_FILE" ] && grep -q '"coach-' "$JOBS_FILE"; then
  warn "jobs named coach-* still exist in $JOBS_FILE that this config did not list."
  warn "Run 'hermes cron list' and 'hermes cron remove <id>' for each, or /personal-coach teardown in chat."
  [ "$FORCE" = "yes" ] || REMAINING="$REMAINING (orphans)"
fi

if [ -n "$REMAINING" ] && [ "$FORCE" != "yes" ]; then
  cat >&2 <<EOF
  [coach] Cron jobs still registered:$REMAINING
  [coach] In your Hermes chat run:   /personal-coach teardown
  [coach] then re-run this script, or re-run with --force to delete files anyway.
EOF
  exit 1
fi

# --- 3. Remove code -----------------------------------------------------------
if [ -e "$SKILL_DIR" ] || [ -L "$SKILL_DIR" ]; then
  if confirm "Delete skill code at $SKILL_DIR?"; then
    if [ -L "$SKILL_DIR" ]; then rm "$SKILL_DIR"; else rm -rf "$SKILL_DIR"; fi
    info "skill removed (run 'hermes gateway restart' to drop the /personal-coach command)"
  else
    info "skill kept"
  fi
else
  info "skill dir not present"
fi

# --- 4. Data ------------------------------------------------------------------
if [ -d "$DATA_DIR" ]; then
  case "$DATA_ACTION" in
    keep)  info "data kept at $DATA_DIR" ;;
    purge) rm -rf "$DATA_DIR"; info "data deleted" ;;
    ask)
      if [ "$ASSUME_YES" = "yes" ]; then
        info "data kept at $DATA_DIR (use --purge-data to delete)"
      elif confirm "Also delete your goals and logs at $DATA_DIR? (cannot be undone)"; then
        rm -rf "$DATA_DIR"; info "data deleted"
      else
        info "data kept at $DATA_DIR"
      fi ;;
  esac
fi
info "done."
