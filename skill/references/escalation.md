# Escalation — what to do when check-ins go unanswered

Inputs: `Intensity` (config), S = Silent Cycles (check-ins in a row with no
reply of any kind), `Escalation Step` (STATE), QUIET and CALL_OK (CLOCK),
`Mode`, `Voice Notes`, `Calls`. Called by routines when S ≥ 1.

Why it is built this way: people who fall behind avoid looking at their
progress, and every unread message adds pressure. So each step makes the ask
SMALLER and changes the CHANNEL; it never adds volume or blame.

## Always (every intensity)
- Never message or call when QUIET = yes. `Mode: rest` → §Shrink only.
- Never mention the silence count, missed days or earlier messages.
- When the user comes back: one warm line, no recap of what was missed, then
  carry on from today.
- When this file's answer is `[SILENT]`: the routine replies `[SILENT]` and
  STOPS — it writes nothing, so a silent run is never counted as ignored.
- §Ask-Why sets its own `Pending`; the routine must not overwrite it.

## Shrink (S ≥ 1) — replaces the routine's normal message
≤ 30 words, no list, one question answerable in one word.
- morning / daily-plan: "Morning. One thing for today — or `nothing`."
- evening / daily-review: "How was today, 1–5? A number is enough."
- midday: reply `[SILENT]`.
- weekly: numbers in one line, then "One word for the week?"
Keep the routine's normal Pending value so the answer is still understood.

## Ladder
| S | gentle | firm | relentless |
|---|--------|------|------------|
| 1–2 | Shrink | Shrink | Shrink; at S = 2 → §Voice |
| 3 | Shrink | §Ask-Why once | §Ask-Why once; then §Call |
| 4–9 | one Shrink a day | one Shrink a day | §Call once a day, max 2 more days; then one Shrink a day |
| ≥ 10 | weekly only | weekly only | weekly only |

- "One Shrink a day": only the first planning routine of the day speaks
  (morning or daily); other routines reply `[SILENT]`.
- "Weekly only": daily routines reply `[SILENT]`; the weekly routine sends
  the numbers plus "Still here when you want to pick it up. Say `coach`."

## Ask-Why (once: only if Escalation Step < 1)
Send instead of the routine message: "No pressure — which fits right now:
`busy`, `too many messages`, `avoiding it`, or `pause me`?"
WRITE STATE Pending: silence_reason; Escalation Step: 1.

## Voice (only if Voice Notes: on and Escalation Step < 2)
Send the Shrink message as a voice note with `text_to_speech` instead of
text (same words, spoken warmly, ≤ 15 seconds). WRITE Escalation Step: 2.
Tool missing or failing → send the text.

## Call (only if Calls: on, CALL_OK = yes, Escalation Step < 6)
1. Not CALL_OK → send the Shrink text now; the next routine inside call
   hours makes the call.
2. Place the call exactly as `Call How` (config) describes. No answer or a
   dropped line → try again, at most 3 attempts in this run.
3. On the call: say who you are, 2–3 sentences per turn. Ask the Ask-Why
   question, listen, agree ONE step per `protocols.md` §Tiny-Step, say
   goodbye. Never lecture.
4. WRITE Escalation Step += 1 (first call sets it to 3). Append to LOG
   `## Notes`: `- <HH:MM> call: answered|no answer — <≤ 15 words>`.
5. Answered → run `bash DATA_DIR/bin/coach.sh seen`; reply `[SILENT]`.
   Not answered → send one line: "Tried calling. Nothing urgent — one word
   back is enough."
6. Call tool missing or erroring → set `Calls: off` in config, tell the user
   once that calls stopped working, continue as firm.

## silence_reason (answer handler, via pending.md)
- `busy` → "Understood. Want rest mode — a score-only check-in for a few
  days? Reply a number of days, or `no`." Pending: rest_days.
- `too many messages` → propose the next lighter cadence (intensive →
  balanced → minimalist) via `commands.md` §edit.
- `avoiding` → `Depth: deep`: `deep-coaching.md` §Stall diagnosis. Core:
  "Thanks for saying it. What is the smallest version you would do today?"
- `pause` → `commands.md` §pause.
- anything else → treat as a normal message (`capture.md`).
Then WRITE Pending: none (unless set above).
