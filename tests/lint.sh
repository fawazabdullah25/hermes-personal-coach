#!/usr/bin/env bash
# Static checks that protect small-model behaviour. Run from repo root.
set -euo pipefail
cd "$(dirname "$0")/.."
FAIL=0
bad() { printf '  FAIL: %s\n' "$*"; FAIL=1; }
ok()  { printf '  ok:   %s\n' "$*"; }

# 1. Required files
for f in LICENSE README.md CONTRIBUTING.md CHANGELOG.md VERSION install.sh uninstall.sh \
         SOUL.md.snippet skill/SKILL.md \
         skill/templates/COACH_CONFIG.md skill/templates/GOALS.md skill/templates/HABITS.md \
         skill/templates/STATE.md skill/templates/daily-log.md skill/templates/weekly-log.md; do
  [ -f "$f" ] && ok "$f" || bad "missing $f"
done
for r in onboarding routine-morning routine-midday routine-evening routine-weekly \
         routine-daily pending protocols commands archetypes cron-engine; do
  [ -f "skill/references/$r.md" ] || bad "missing skill/references/$r.md"
done

# 2. Frontmatter
head -1 skill/SKILL.md | grep -q '^---$' || bad "SKILL.md must start with YAML frontmatter"
grep -q '^name: personal-coach$' skill/SKILL.md || bad "frontmatter name must be personal-coach"
FM="$(awk 'NR==1{next} /^---$/{exit} {print}' skill/SKILL.md)"
echo "$FM" | grep -q '^description:' || bad "frontmatter needs description"
DESC="$(echo "$FM" | awk '/^description:/{f=1;next} f&&/^[a-z_]+:/{exit} f{print}' | tr -s ' \n' ' ')"
[ "$(echo "$DESC" | wc -w)" -le 60 ] && ok "description ≤ 60 words" || bad "description > 60 words (shown in /commands)"
echo "$DESC" | grep -Eq '(~|/home|/Users)/' && bad "description contains a filesystem path (gateway would attach the file)" || ok "no paths in description"

# 3. Budgets (word-count proxy: ~1.35 tokens/word)
w="$(wc -w < skill/SKILL.md)"; [ "$w" -le 650 ] && ok "SKILL.md $w words" || bad "SKILL.md $w words > 650 (~900 tokens)"
for f in skill/references/*.md; do
  w="$(wc -w < "$f")"; [ "$w" -le 950 ] && ok "$(basename "$f") $w words" || bad "$f $w words > 950 (~1300 tokens)"
done

# 4. Bare ~/.hermes paths outside backtick code spans (spans may wrap lines)
if awk '
  FNR==1 { inspan=0 }
  {
    s=$0
    if (inspan) { i=index(s,"`"); if (i==0) next; s=substr(s,i+1); inspan=0 }
    gsub(/`[^`]*`/, "", s)                       # drop complete inline spans
    i=index(s,"`"); if (i>0) { s=substr(s,1,i-1); inspan=1 }   # span opens here
    if (s ~ /~\/\.hermes/) { print FILENAME ":" FNR ": " $0; found=1 }
  }
  END { exit found ? 1 : 0 }
' skill/SKILL.md skill/references/*.md; then
  ok "no bare paths outside code spans"
else
  bad "bare ~/.hermes path outside backticks in the lines above"
fi

# 5. Scripts
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck install.sh uninstall.sh tests/lint.sh && ok "shellcheck" || bad "shellcheck"
else
  echo "  skip: shellcheck not installed"
fi
bash -n install.sh && bash -n uninstall.sh && ok "bash -n" || bad "syntax error in scripts"

[ "$FAIL" -eq 0 ] && echo "LINT PASSED" || { echo "LINT FAILED"; exit 1; }
