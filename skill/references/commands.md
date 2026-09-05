# Commands

## help
Reply the command list with one-line descriptions. No file reads.

## status
READ: COACH_CONFIG.md, GOALS.md §2, LOG (if exists), HABITS.md.
1. Call `cronjob_manage(action="list")`. For each ID in config, HEALTH = found
   (state, next run) | MISSING.
2. Reply as a compact block: Status, Tier, Archetype; times; each cron ID with
   HEALTH; today's commitments with [x]/[ ]; active KRs with Status; habit
   streaks (H-id=streak, scope). If any MISSING: "Run `/personal-coach
   timezone` to re-register, or `setup` if several are missing."

## test <morning|pulse|evening|weekly|daily>
1. WRITE STATE.md `Test Mode: yes` (this single write is allowed).
2. Execute the matching routine (pulse = midday) as if CRON RUN, obeying
   Invariant 9 (no writes, `[TEST — nothing saved]` prefix).
3. WRITE STATE.md `Test Mode: no`. Do NOT set Pending.

## timezone
1. Terminal `date "+%Z %z"`. Compare with Host Timezone.
2. If equal and Scheduler Timezone Verified: yes → "No change needed." STOP.
3. Else set Host Timezone; run cron-engine.md §Update-All then §Verify;
   WRITE config. Reply with new next-run times.

## pause / resume
1. `cronjob_manage(action="list")`; for each ID in config that exists →
   `cronjob_manage(action="pause"|"resume", job_id=ID)`.
2. WRITE config Status: paused | active. Reply one line.

## teardown
1. Ask: "Remove all coach cron jobs? Your goals and logs stay on disk. `yes`/`no`."
2. `yes` → cron-engine.md §Teardown; WRITE config IDs = none, Status: paused.
   Reply: "Cron jobs removed. Data kept in `~/.hermes/personal-coach/.` To delete
   files run uninstall.sh."

## edit (natural language changes)
Allowed edits: a time (→ change config line, then cron-engine §Update-One),
a habit (add/remove/frequency → GOALS §3 + protocols §Rebuild for the one
block), a KR text, archetype, `back to full H<n>`. Confirm the exact line
change before writing: "Change `<old>` → `<new>`? yes/no."
