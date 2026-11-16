# Routine: Evening Debrief

READ: COACH_CONFIG.md, STATE.md, CONTRACT.md, LOG (create if missing),
HABITS.md.

1. `protocols.md` §Open.
2. LOG `Evening Score:` is a number and CRON RUN → `[SILENT]`. STOP.
3. HAS_PLAN = commitment line 1 has text other than "(no extras today)".
4. If S ≥ 1 → `escalation.md` decides the message. WRITE Pending:
   evening_score_only (keep `silence_reason` if escalation.md set it). Go
   to step 8.
5. NOT HAS_PLAN, or `Mode: rest` → low-friction check, in tone: "No full
   review tonight. Just a 1–5 for the day — your effort, not the outcome."
   WRITE Pending: evening_score_only. Go to step 8.
6. HAS_PLAN: list commitments (number + text) and DUE habits (H-id + text)
   from LOG — at most 6 lines; commitments already `[x]` are shown as done,
   not asked again. Compose ≤ 90 words: opener + list + "Which did you
   finish? Reply with numbers and habit IDs, e.g. `1 3 H2`, or `none`."
7. WRITE Pending: evening_completions. (The rating is asked next turn.)
8. WRITE STATE Pending Since: TODAY NOW; Pending Log: LOG; Pending Question:
   the question sent; Last Routine Run: evening TODAY. WRITE LOG `Evening
   Reply: pending`.
9. Send.
