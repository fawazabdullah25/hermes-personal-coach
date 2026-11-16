# Pending Reply Handler

READ: STATE.md; the file in `Pending Log`; HABITS.md when a section says so.
MSG = user message.

## First, for every pending reply
1. Run `capture.md` steps 1–3 and 5–8 (reply mark, ratings, done items,
   preferences). They write what MSG already contains.
2. MSG clearly does not answer the open question (another topic, a new
   request): answer it normally (router step 10), leave `Pending` unchanged,
   add nothing about the open item. STOP. The next routine replaces it.
3. MSG is `not now`, `later`, `busy` → reply "Fine." WRITE Pending: none. STOP.
4. Else go to the section named by `Pending`.

## morning_commitments
1. MSG is `nothing` / `none` / `no extras` → WRITE LOG `- [ ] 1. (no extras
   today)`; Pending: none. Reply ≤ 15 words, no question. STOP.
2. Extract 1–3 items: lines starting with a digit, "-" or "•"; else the
   whole message is item 1. Trim each to ≤ 100 chars. A voice transcript →
   take the things they said they WILL do, not the asides.
3. MSG ends with a lone number 1–5 and YLOG `Evening Score:` is `unknown` →
   write it into YLOG.
4. WRITE LOG lines `- [ ] 1. <item>` (2, 3 as given).
5. Ask: "What is most likely to derail item 1 today, and what will you do
   when it happens? `If ___, then I will ___`."
6. WRITE STATE Pending: morning_woop.

## morning_woop
1. MSG has "if" and "then" → PLAN = MSG. Else PLAN = "If " + MSG + ", then
   I will do the 2-minute version and continue."
2. WRITE LOG `- WOOP: <PLAN>`. WRITE STATE Pending: none.
3. Reply ≤ 40 words: the plan is locked. No question.

## midday_status
1. Check in THIS order: "not yet" / "later" → `Not-Yet`; "block" / "stuck"
   → `Blocked`; "reduc" / "smaller" / "cut" → `Scope-Reduced`; "track" /
   "good" / "yes" / "done" → `On-Track`. None → ask once: "Reply `on-track`,
   `not yet`, or `blocked`." STOP.
2. Blocked: `protocols.md` §Two-Minute-Rule on commitment 1 → MICRO. Reply:
   "Understood. Drop it to this: <MICRO>. That counts." STATUS =
   Scope-Reduced; NOTES = MSG + " → micro: " + MICRO.
3. WRITE LOG `Status: <STATUS>`, `Notes: <NOTES>`. WRITE Pending: none.
   Reply ≤ 40 words.

## evening_completions
1. MSG is only a number 1–5 (decimals allowed) → go to §evening_score.
2. DONE_NUMS = integers 1–3 in MSG; DONE_HABITS = tokens `H<digits>`;
   `none` → both empty.
3. WRITE LOG: `- [x]` for done items, others stay `[ ]`. `Completion Rate:
   <done>/<commitments with text>`. `Wins:` done items. `Obstacles:` not-done
   items, stated neutrally.
4. `protocols.md` §Ledger-Update for every habit in LOG `## Habits`. Collect
   its MESSAGES.
5. Compose ≤ 80 words: one line on the wins; MESSAGES verbatim; then ask:
   "Rate today 1–5 — your effort, not the outcome."
6. WRITE STATE Pending: evening_score.

## evening_score and evening_score_only
1. SCORE = first number 1–5 in MSG. None → ask once: "Just a number 1–5."
   STOP.
2. WRITE LOG `Evening Score: <SCORE>`. For evening_score_only also write
   `Completion Rate: unplanned`.
3. WRITE STATE Pending: none.
4. Reply ≤ 40 words by score: below 2.5 → acknowledge, no advice, tomorrow
   starts fresh; below 4 → neutral; 4 and up → one line of celebration.
   No question.
5. Minimalist `combined` only: if Pending Log was YLOG → now execute
   routine-morning.md for TODAY.

## commit_confirm
`yes` → `protocols.md` §Commit-Add with the item in `Pending Question`.
`no` → nothing. WRITE Pending: none. Reply one line.

## rest_days
A number N (1–14) → WRITE STATE Mode: rest; Mode Until: TODAY + N days
(terminal `date`). Reply: "Rest mode until <date>. A number at night is
enough, and skipping it is fine." `no` → nothing. WRITE Pending: none.

## Other values
- silence_reason → `escalation.md` §silence_reason.
- weekly_* → `routine-weekly.md` §Answers.
- stake_* / partner_* → `accountability.md`.
- integration_* → `integrations.md` §Answers.
