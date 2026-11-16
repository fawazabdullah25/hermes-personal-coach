# Routine: Weekly Review

READ: COACH_CONFIG.md, STATE.md, CONTRACT.md, GOALS.md, HABITS.md. Never
read daily logs directly; the script extracts the numbers.

## Fire (CRON RUN)
1. `protocols.md` §Open.
2. Terminal `bash DATA_DIR/bin/coach.sh week` → DAYS_LOGGED, COMPLETED,
   EXECUTION_SCORE, AVG_SCORE, BEST_DAY, HARDEST_DAY, REPLIED. Use these
   values verbatim. Script missing → say "numbers not tracked this week".
3. Terminal `date +%z`; differs from Host Timezone → DRIFT = true.
4. `bash DATA_DIR/bin/coach.sh due 14` → UPCOMING (nearest 3). Also any
   GOALS §1 milestone due this month or next.
5. Not Test Mode: `cp GOALS.md backups/GOALS.<TODAY>.md` only if GOALS.md
   differs from the newest backup.
6. Create `logs/weekly/<WEEK>.md` from the template with the numbers filled.
7. S ≥ 1 → `escalation.md` decides the message; go to step 9.
8. Compose ≤ 120 words: "Execution <EXECUTION_SCORE> (<COMPLETED>), average
   day <AVG_SCORE>, best day <BEST_DAY>." If EXECUTION_SCORE ≥ 85% say so
   plainly; never comment on a low number. UPCOMING in one line. DRIFT →
   "Clock offset changed — send `/personal-coach timezone` after this."
   Then Q1: "What is better than a week ago, however small?"
9. WRITE STATE Pending: weekly_q1 (keep `silence_reason` if escalation.md
   set it); Pending Since: TODAY NOW; Pending Log:
   `logs/weekly/<WEEK>.md`; Last Routine Run: weekly TODAY. Send.

## Answers (via pending.md)
- weekly_q1: write `Gain` and `Biggest Win`. Ask Q2: "One thing to change
  next week — what got in the way most?" Pending: weekly_q2.
- weekly_q2: write `What Got in the Way` and `Keep / Change`. Then:
  - OKR_DUE = sprint end date ≤ TODAY + 7 days, OR this is the first weekly
    review of the month. If OKR_DUE: list every KR with Status ≠ done/dropped
    and ask: "Status of each: `1.1 done`, `1.2 on-track`, `2.1 stalled`,
    `2.1 drop`." Pending: weekly_okrs.
  - Else go to Close.
- weekly_okrs: per `<id> <status>`: done → move the KR line to GOALS §5 with
  the date; drop → same, "dropped"; on-track / stalled → set Status. Any
  stalled → ask: "KR <id> is stalled. New target or date in the same shape,
  or `keep`?" Pending: weekly_renegotiate. Else Close.
- weekly_renegotiate: replace the KR line if a new one was given. Close.

## Close
1. `bash DATA_DIR/bin/coach.sh archive` → write `Dailies archived`.
2. `CONTRACT.md` has a stake, or `Partner` ≠ none → `accountability.md`
   §Weekly.
3. `Depth: deep` → `deep-sessions.md` §Weekly pattern read (may add ONE
   observation to the reply and one dated line to CONTRACT.md).
4. `Integration Offers: on` → `integrations.md` §Offer (at most one line).
5. WRITE the weekly file. WRITE STATE Pending: none.
6. Reply ≤ 80 words: one sentence on the week, the result of steps 2–4 if
   any, and when the next check-in arrives.
