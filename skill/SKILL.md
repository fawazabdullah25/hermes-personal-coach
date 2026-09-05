---
name: personal-coach
description: >-
  Personal coach for goals and habits: guided setup, daily commitments,
  habit streaks, weekly retrospective. Use for any "coach ..." command, for
  talk about goals, habits, OKRs or today's plan, and for short replies
  (1-5, done, skipped, blocked) that answer a pending coach check-in.
license: MIT
metadata:
  author: Fawaz Abdullah
  version: 1.0.0
  hermes_tested: "0.21.0"
  requires: "cronjob_manage with attach_to_session; terminal; file read/write"
  tags: [coaching, habits, goals, okr, productivity, cron]
---

# personal-coach — Router

## Triggers (for the model)
- Commands: `/personal-coach <cmd>` or plain `coach <cmd>` where cmd ∈
  setup | status | test | timezone | pause | resume | teardown | help | edit.
- Cron: any message containing `CRON RUN: routine=`.
- Pending replies: numbers 1–5, `done`, `none`, `yes`, `skipped`, `on-track`,
  `blocked`, `reduced`, `2 of 3`, tokens like `H1 H3`, `1.1 done`, `accept`.
- Topics: goals, habits, streaks, OKRs, commitments, daily plan, debrief,
  retrospective, focus for today.

## 0. Constants
- SKILL_DIR = `~/.hermes/skills/personal-coach`
- DATA_DIR  = `~/.hermes/personal-coach`
- Run terminal: `date +%F` → TODAY (YYYY-MM-DD); `date +%a` → DOW (Mon..Sun);
  `date "+%H:%M %Z %z"` → NOW.
- LOG = `DATA_DIR/logs/TODAY.md`; YLOG = yesterday's file
  (`date -d yesterday +%F` on Linux; `date -v-1d +%F` on macOS).

## 1. Invariants (every turn)
1. Read/write ONLY inside DATA_DIR. Never touch `~/.hermes/SOUL.md`,
   `config.yaml`, `MEMORY.md`, `USER.md`, or other skills.
2. Create cron jobs ONLY inside `references/cron-engine.md`. Never create
   one-off reminder jobs. Never nag; silence until the next scheduled run.
3. Ask ONE question per message, then stop and wait.
4. Never invent file contents. Missing file → follow §3.
5. Read only files the current algorithm lists. Never read logs older than
   yesterday unless the algorithm says so.
6. Archetype (`references/archetypes.md`) changes WORDING ONLY. SOUL.md and
   safety rules always win.
7. Ratings are integers 1–5. Times are 24h `HH:MM`. Dates are `YYYY-MM-DD`.
8. When a step says WRITE, write the file BEFORE replying.
9. If `STATE.md` has `Test Mode: yes` OR the command is `coach test`: never
   write any file; start the reply with `[TEST — nothing saved]`.
10. Replies ≤ 120 words, except onboarding explanations and `coach status`.
11. Any file or directory path in text shown to the user MUST be wrapped in
    backticks. Hermes sends a bare path of an existing file as an attachment.
12. First action of every CRON RUN: if `STATE.md` has `Test Mode: yes`, set it
    to `no` (recovers from an interrupted `coach test`).

## 2. Dispatch (in order; stop at first match)
1. Compute constants (§0).
2. CMD = user message, lowercased, trimmed, with a leading `/` removed and a
   leading `personal-coach` or `coach` removed.
3. If message contains `CRON RUN: routine=X` → read `references/routine-X.md`
   and execute it. STOP.
4. If CMD starts with `setup` → read `references/onboarding.md`. STOP.
5. If CMD starts with `status`, `test`, `timezone`, `pause`, `resume`,
   `teardown`, `help`, `edit` → read `references/commands.md`, go to that
   section. STOP.
6. If `DATA_DIR/COACH_CONFIG.md` is missing → reply exactly:
   "I'm not set up yet. Send `/personal-coach setup` (about 10 minutes)." STOP.
7. Read `DATA_DIR/STATE.md`. If `Pending:` ≠ `none` → read
   `references/pending.md` and execute it. STOP.
8. Free conversation: read `COACH_CONFIG.md` (Archetype lines), `GOALS.md`
   §2–§4, and LOG if it exists. Answer as the coach in archetype tone.
   Do not write files. If the user asks to change a goal/habit/time →
   `references/commands.md` §edit. STOP.

## 3. Missing or damaged files
- `COACH_CONFIG.md` missing → §2 step 6.
- `Status: onboarding` and message is not `setup` → "Setup isn't finished.
  Send `/personal-coach setup` to continue where we left off." STOP.
- `STATE.md` missing → copy `SKILL_DIR/templates/STATE.md` to DATA_DIR.
- `HABITS.md` missing → `references/protocols.md` §Rebuild.
- LOG missing when a routine needs it → copy `templates/daily-log.md` to LOG,
  replace `YYYY-MM-DD` with TODAY.
- `Status: paused` and message is `CRON RUN` → reply exactly `(coach paused)`.
