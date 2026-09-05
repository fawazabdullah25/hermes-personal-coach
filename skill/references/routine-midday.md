# Routine: Midday Pulse

READ: COACH_CONFIG.md, STATE.md, LOG (create if missing).

1. If `Status: paused` → `(coach paused)`. STOP.
2. If LOG `Midday Friction Pulse → Status:` ≠ `pending` and CRON RUN → reply
   `(pulse already logged)`. STOP.
3. If `Pending:` is `morning_commitments` or `morning_woop` (morning was never
   answered): compose: "Midday, and no plan yet — that happens. Give me ONE
   thing you'll finish before evening." Pending: morning_commitments (unchanged)
   and go to step 6.
4. Else if commitments exist: compose (≤ 60 words): "Midday pulse. Reply
   `on-track`, `blocked`, or `reduced` — add one line if blocked."
5. Else (log has no commitments, morning routine never ran): same as step 3.
6. WRITE STATE.md: Pending: midday_status (unless step 3/5 kept
   morning_commitments); Last Routine Run: midday TODAY.
7. Send. Answer handled by pending.md.
