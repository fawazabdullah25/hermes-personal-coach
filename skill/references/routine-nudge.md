# Routine: Follow-up (jobs `coach-nudge-am`, `coach-nudge-pm`)

One lighter follow-up to a check-in that got no reply — never a second one.
READ: COACH_CONFIG.md, STATE.md.

1. Invariant 12. Reply `[SILENT]` and STOP if ANY of these is true:
   - `Status` is not active, or `Intensity: gentle`, or `Mode: rest`
   - CLOCK says QUIET = yes
   - STATE `Pending: none`, or `Nudged: yes`, or `Silent Cycles` ≥ 1
   - `Pending Since` does not start with TODAY
   - in `Pending Log`, no `… Reply:` line is still `pending`
2. Pick the line by `Pending`:
   - morning_commitments, morning_woop → "Still time to pick one thing for
     today. What is it? `nothing` works too."
   - evening_completions, evening_score, evening_score_only → "Before the
     day closes: just a 1–5."
   - weekly_q1, weekly_q2 → "The weekly review is open — one line is enough."
   - anything else → `[SILENT]`. STOP.
3. `Depth: deep` → you may reword the line around the open `Pending
   Question`, same length, same ease. Never add "reminder" or "you haven't".
4. WRITE STATE `Nudged: yes`.
5. Send the one line. Do not change `Pending`.
