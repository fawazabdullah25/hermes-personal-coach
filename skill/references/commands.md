# Commands

## help
Reply this list, one line each. No file reads.
- `setup` · `status` · `test <routine>` · `timezone` · `pause` / `resume` ·
  `teardown` · `edit …`
- `intensity gentle|firm|relentless` — how hard I follow up
- `depth core|deep` — scripted check-ins, or full coaching (large models)
- `style streaks|minimum` — show streaks, or one small daily minimum
- `mode rest|crunch|normal [days]` — lighter weeks and deadline weeks
- `commit add|done|drop|list` — dated commitments and deadlines
- `remind <when> <what>` — a one-off reminder
- `contract` — the rules you've given me about coaching you
- `integrations` — calendar, voice, calls and more
- `partner` / `stake` — an accountability partner; a pledge on your week
- `review` / `plan` — a deeper review or a planning sit-down

## status
READ: COACH_CONFIG.md, STATE.md, GOALS.md §2, LOG (if exists), HABITS.md.
1. `cronjob_manage(action="list")`. Per config ID: found (next run, last
   status) | MISSING.
2. `bash DATA_DIR/bin/coach.sh due 7`.
3. Reply as a compact block: Status, Tier, Voice, Intensity, Depth, Style,
   Mode; times; each cron job with health; today's commitments `[x]`/`[ ]`;
   commitments due in 7 days; active KRs; habits (streaks only when Tracking
   Style: streaks); integrations that are on. Any MISSING or failing job →
   "Run `/personal-coach timezone` to re-register."

## test <morning|pulse|evening|weekly|daily|nudge>
1. WRITE STATE `Test Mode: yes` (this one write is allowed).
2. Execute the routine (pulse = midday) as a CRON RUN under Invariant 9.
   Where it would reply `[SILENT]`, say why instead.
3. WRITE STATE `Test Mode: no`. Do NOT set Pending.

## timezone
1. Terminal `date "+%Z %z"`. Compare with Host Timezone.
2. Equal and Scheduler Timezone Verified: yes → "No change needed." STOP.
3. Else set Host Timezone; cron-engine.md §Update-All then §Verify; WRITE
   config. Reply with the new next-run times.

## pause / resume
1. `list`; for each config ID that exists → `cronjob_manage(action="pause"
   | "resume", job_id=ID)`.
2. WRITE config Status: paused | active. On resume also WRITE STATE Silent
   Cycles: 0, Escalation Step: 0, Pending: none. Reply one line.

## teardown
1. Ask: "Remove all coach cron jobs? Your goals and logs stay on disk.
   `yes`/`no`."
2. `yes` → cron-engine.md §Teardown; WRITE config Status: paused. Reply:
   "Cron jobs removed. Your data stays in the coach data folder; run
   `uninstall.sh` to delete files."

## edit (natural-language changes)
Allowed: a time or cadence (→ config line, then cron-engine §Update-One or
§Register), a habit (add / remove / frequency → GOALS §3 + protocols
§Rebuild for that block), a KR text, the voice, `back to full H<n>`
(Scope: full, Micro Completions: 0), `rebuild habits`.
Confirm the exact change first: "Change `<old>` → `<new>`? yes/no."
A fourth-plus habit: say once "3–5 habits is the most people sustain" —
then do what the user decides.
