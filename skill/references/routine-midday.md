# Routine: Midday Pulse

READ: COACH_CONFIG.md, STATE.md, CONTRACT.md, LOG (create if missing).

1. `protocols.md` §Open.
2. LOG `Midday Friction Pulse → Status:` ≠ `pending` and CRON RUN →
   `[SILENT]`. STOP.
3. S ≥ 1 or `Mode` ≠ normal → `[SILENT]`. STOP. (Midday never escalates.)
4. LOG has no commitment text → compose: "Midday. Give me ONE thing you'll
   finish before evening — or `nothing`." WRITE Pending:
   morning_commitments; `Morning Reply: pending`. Go to step 6.
5. Else compose (≤ 50 words): name commitment 1 in the user's own words,
   then "Reply `on-track`, `not yet`, or `blocked` — add a line if blocked."
   WRITE Pending: midday_status; LOG `Midday Reply: pending`.
6. WRITE STATE Pending Since: TODAY NOW; Pending Log: LOG; Last Routine Run:
   midday TODAY.
7. Send. The answer is handled by pending.md.
