# Routine: Morning Kickoff

READ (only these): COACH_CONFIG.md, STATE.md, GOALS.md §2 + §3, HABITS.md,
YLOG if it exists, LOG (create from template if missing).

1. If `Status: paused` → reply `(coach paused)`. STOP.
2. Dedupe: if LOG line `- [ ] 1.` or `- [x] 1.` already has text after the
   number and this is a CRON RUN → reply `(morning already planned)`. STOP.
3. YESTERDAY_UNKNOWN = (YLOG exists AND its `Evening Score:` is `pending`).
   If true and not TEST MODE → set that line to `Evening Score: unknown`.
4. DUE = habits where protocols.md §Due-Today returns yes for DOW.
   For each DUE habit: TEXT = Micro-step if `Scope: micro` (prefix "(micro)"),
   else the habit action.
5. WRITE LOG section `## Habits (due today)` → one line per DUE habit:
   `- [ ] H<n> <TEXT>`. If DUE is empty write `- (no habits due today)`.
6. Compose message in archetype tone, this order, ≤ 120 words:
   a. one-line opener (archetypes.md phrase bank: morning)
   b. if YESTERDAY_UNKNOWN: "Yesterday's review is missing — no problem.
      Add a 1–5 for yesterday at the end of your reply if you like."
   c. "Active: " + objective titles only (no KRs).
   d. "Due today: " + DUE list (H-id + TEXT).
   e. Question: "What are your top 1–3 non-negotiables today? Reply as a
      numbered list."
7. WRITE STATE.md: Pending: morning_commitments; Pending Since: TODAY NOW;
   Pending Log: logs/TODAY.md; Last Routine Run: morning TODAY.
8. Send the message. The answer is handled by pending.md.
