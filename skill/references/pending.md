# Pending Reply Handler

READ: STATE.md; the file in `Pending Log`; HABITS.md when the section says so.
MSG = user message. If MSG is clearly unrelated (a question about something
else, > 40 words with no numbers/ids/keywords), answer it normally, keep
Pending unchanged, and add one line: "(Your <pending item> is still open —
answer whenever.)" STOP.

## morning_commitments
1. Extract 1–3 items: lines starting with a digit, "-", or "•"; else treat the
   whole message as item 1. Trim to ≤ 100 chars each.
2. If message ends with a lone integer 1–5 and YLOG `Evening Score:` is
   `unknown` → write that integer into YLOG.
3. WRITE LOG lines `- [ ] 1. <item>` (2, 3 as given; leave others blank).
4. Ask: "What's the #1 thing likely to derail item 1 today, and what will you
   do when it happens? Format: `If ___, then I will ___`."
5. WRITE STATE.md Pending: morning_woop.

## morning_woop
1. If MSG contains "if" and "then" (any case) → PLAN = MSG. Else PLAN =
   "If " + MSG + ", then I will do the 2-minute version and continue."
2. WRITE LOG line `- WOOP: <PLAN>`.
3. WRITE STATE.md Pending: none.
4. Reply ≤ 40 words, tone: confirm the plan is locked. No further questions.

## midday_status
1. STATUS = `On-Track` if MSG contains "track"/"good"/"yes"; `Blocked` if
   "block"/"stuck"/"no"; `Scope-Reduced` if "reduc"/"smaller"/"cut".
   Else ask once: "Reply `on-track`, `blocked`, or `reduced`." STOP.
2. If Blocked: apply protocols.md §Two-Minute-Rule to commitment 1 → MICRO.
   Reply: "Understood. Drop it to this: <MICRO>. That counts." Set
   STATUS = Scope-Reduced and NOTES = MSG + " → micro: " + MICRO.
3. WRITE LOG `Status: <STATUS>` and `Notes: <NOTES>`.
4. WRITE STATE.md Pending: none. Reply ≤ 40 words.

## evening_completions
1. DONE_NUMS = integers 1–3 in MSG; DONE_HABITS = tokens matching H<digits>;
   `none` → both empty.
2. WRITE LOG: mark `- [x]` for DONE_NUMS and DONE_HABITS; leave others `[ ]`.
   Completion Rate: <len(DONE_NUMS)>/<number of commitments with text>.
   Wins: list of done items. Obstacles: list of not-done items, neutral,
   no judgement words.
3. Execute protocols.md §Ledger-Update for every habit in LOG `## Habits`.
   Collect MESSAGES it returns (scope changes, scale-ups).
4. Compose ≤ 80 words: one line acknowledging wins; MESSAGES verbatim; then
   ask: "Rate the day 1–5."
5. WRITE STATE.md Pending: evening_score.

## evening_score  and  evening_score_only
1. SCORE = first integer 1–5 in MSG. If none → ask once: "Just a number 1–5."
   STOP.
2. WRITE LOG `Evening Score: <SCORE>`. If evening_score_only also write
   `Completion Rate: unplanned` and `Obstacles: no plan logged today`.
3. WRITE STATE.md Pending: none.
4. Reply ≤ 40 words, tone by score: 1–2 → acknowledge, no advice, mention
   tomorrow resets; 3 → neutral; 4–5 → brief celebration. No questions.
5. Minimalist `combined` only: if Pending Log was YLOG → now execute
   routine-morning.md for TODAY.

## weekly_q1 / weekly_q2 / weekly_q3 / weekly_okrs / weekly_renegotiate
→ handled in routine-weekly.md §Answers (same file, to keep context small).
