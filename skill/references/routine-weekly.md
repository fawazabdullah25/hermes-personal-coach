# Routine: Weekly Retrospective

READ: COACH_CONFIG.md, STATE.md, GOALS.md, HABITS.md. Do NOT read daily logs
directly; extract with terminal to save context.

## Fire (CRON RUN)
1. `Status: paused` → `(coach paused)`. STOP.
2. Terminal (one command):
   `cd ~/.hermes/personal-coach/logs && for f in $(ls [0-9]*.md | tail -7); do
   echo "== $f"; grep -E "Completion Rate|Evening Score" "$f"; done`
3. From the output compute: DAYS_LOGGED (files with an integer score),
   COMPLETED/TOTAL (sum of X/Y, skip `unplanned`), AVG_SCORE (mean of integer
   scores, 1 decimal). Streaks from HABITS.md.
4. Terminal: `date +%z`. If it differs from the offset in Host Timezone →
   DRIFT = true.
5. Milestones: any GOALS §1 milestone whose YYYY-MM ≤ current month + 1 →
   UPCOMING list.
6. `cp GOALS.md backups/GOALS.<TODAY>.md` (skip in TEST MODE).
7. Compose ≤ 120 words: numbers from step 3; UPCOMING (if any); if DRIFT:
   "Clock offset changed — send `/personal-coach timezone` after this."
   Then ask Q1: "Biggest win this week?"
8. WRITE STATE.md Pending: weekly_q1; Pending Log: logs/weekly/<YYYY-Www>.md
   (compute week id with `date +%G-W%V`); create that file from template with
   the numbers filled. Last Routine Run: weekly TODAY.

## Answers (invoked via pending.md)
- weekly_q1: write Biggest Win; ask "What got in the way most?"; Pending q2.
- weekly_q2: write What Got in the Way; ask "One thing to keep, one to change
  next week?"; Pending q3.
- weekly_q3: write Keep/Change. Then list every KR with Status ≠ done/dropped
  and ask: "For each KR reply its status: `1.1 done`, `1.2 on-track`,
  `2.1 stalled`, `2.1 drop`." Pending weekly_okrs.
- weekly_okrs: for each `<id> <status>`: done → move KR line to GOALS §5 with
  date; drop → same with "dropped"; on-track → set Status; stalled → set
  Status stalled and remember id. If any stalled: ask "KR <id> is stalled.
  Renegotiate: give a new target or deadline in the same shape, or `keep`."
  Pending weekly_renegotiate. Else go to Close.
- weekly_renegotiate: replace the KR line if a new version was given; Close.
- Close: (a) Housekeeping — terminal:
  `CUT=$(date -d '-56 days' +%F 2>/dev/null || date -v-56d +%F); cd
  ~/.hermes/personal-coach/logs; for f in [0-9]*.md; do [ "${f%.md}" \< "$CUT" ]
  && mv "$f" archive/; done; ls archive | wc -l` → write Dailies archived.
  (b) WRITE weekly file OKR Decisions + Housekeeping. (c) WRITE STATE.md
  Pending: none. (d) Reply ≤ 60 words in tone: one sentence on the week, one
  on the coming week's first check-in.
