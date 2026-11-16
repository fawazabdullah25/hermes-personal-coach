# Routine: Morning Kickoff

READ: COACH_CONFIG.md, STATE.md, CONTRACT.md, GOALS.md §2 + §3, HABITS.md,
YLOG if it exists, LOG (create from template if missing).

1. `protocols.md` §Open.
2. Dedupe: LOG line `- [ ] 1.` or `- [x] 1.` already has text and this is a
   CRON RUN → `[SILENT]`. STOP.
3. YESTERDAY_UNKNOWN = YLOG exists AND its `Evening Score:` is `pending`.
   If true and not Test Mode → set that line to `unknown`.
4. DUE = habits where §Due-Today is yes. WRITE LOG `## Habits (due today)`:
   one `- [ ] H<n> <text>` per DUE habit (Micro-step, prefixed "(micro)",
   when Scope: micro). None → `- (no habits due today)`.
5. `protocols.md` §Focus-Question → FOCUS, Q.
6. `Calendar: on` → read today's events as `Calendar How` says → TODAY_EVENTS
   (at most 3, `HH:MM title`). Any tool error → skip silently.
7. If S ≥ 1 → `escalation.md` decides the message; go to step 9.
8. Compose in archetype tone, ≤ 120 words, in this order:
   a. one-line opener (archetypes.md: morning)
   b. YESTERDAY_UNKNOWN → "Add a 1–5 for yesterday if you like."
   c. FOCUS
   d. TODAY_EVENTS, if any: "Today: …"
   e. DUE habits via `protocols.md` §Habit-Line: "Habits: …"
   f. Q — the only question.
9. WRITE STATE: Pending: morning_commitments (keep `silence_reason` if
   escalation.md set it); Pending Since: TODAY NOW;
   Pending Log: LOG; Pending Question: Q; Last Routine Run: morning TODAY.
   WRITE LOG `Morning Reply: pending`.
10. Send. The answer is handled by pending.md.
