# Routine: Evening Debrief (with Anti-Ghosting Safety Check)

READ: COACH_CONFIG.md, STATE.md, LOG (create if missing), HABITS.md.

1. If `Status: paused` → `(coach paused)`. STOP.
2. If LOG `Evening Score:` is an integer and CRON RUN → `(debrief already done)`.
   STOP.
3. HAS_PLAN = commitment line 1 has text.
4. If NOT HAS_PLAN → SAFETY CHECK (low friction): compose exactly, in tone:
   "High-friction day? No need for a full review. Just reply with a 1 to 5
   rating on how the day felt." WRITE STATE.md Pending: evening_score_only.
   Go to step 8.
5. If HAS_PLAN: list commitments (number + text) and DUE habits (H-id + text)
   from LOG. Compose (≤ 90 words): opener + list + "Which did you finish?
   Reply with numbers and habit IDs, e.g. `1 3 H2`, or `none`."
6. WRITE STATE.md Pending: evening_completions.
7. (Rating is asked in the next turn by pending.md — one question per message.)
8. WRITE STATE.md Last Routine Run: evening TODAY. Send.
