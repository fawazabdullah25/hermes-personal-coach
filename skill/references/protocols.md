# Protocols

## Open (first steps of every routine)
1. Invariant 12. `Status: paused` → `[SILENT]`. STOP.
2. Run CLOCK. QUIET = yes → `[SILENT]`. STOP.
3. `Mode` ≠ normal and `Mode Until` < TODAY → WRITE Mode: normal, Mode Until: none.
4. If STATE `Pending` ≠ none: in the file named by `Pending Log`, find the
   `Morning|Midday|Evening Reply:` line still `pending`. If found → set it to
   `no` and WRITE STATE `Silent Cycles` += 1.
5. WRITE STATE `Nudged: no`. S = Silent Cycles. Read `CONTRACT.md`.

## Due-Today(habit, DOW)
`Daily` → yes. `Weekdays` → Mon..Fri. `Weekends` → Sat/Sun. A day list
(`Mon/Wed/Fri`) → yes if DOW is in it. Otherwise no.

## Ledger-Update(one LOG habit line) — returns MESSAGES
1. Find `### H<n>` in HABITS.md. T = Scale-Up Threshold.
2. `[x]`: Streak += 1; Consecutive Misses = 0; Last Done = TODAY. If Scope:
   micro → Micro Completions += 1; if ≥ T → Scope: full, Micro Completions: 0,
   MESSAGE "H<n> is back to full size — <T> small wins in a row."
3. `[ ]`: Streak = 0; Consecutive Misses += 1. Misses == 1 → say nothing.
   Misses ≥ 2 AND Scope: full → Scope: micro; Micro Completions: 0; MESSAGE
   "From tomorrow H<n> is only: <Micro-step>. That is the whole task."
4. Last Evaluated = TODAY. WRITE the changed lines.
5. Never put a streak that just reset, or a miss count, into a message.

## Habit-Line(habit) — how a due habit is shown
- `Tracking Style: streaks` → `H<n> <text>` plus ` (day <Streak+1>)` only
  when Streak ≥ 2. Show at most 5.
- `Tracking Style: minimum` → show only the FIRST due habit, then "anything
  more is a bonus". Never show numbers.
- `Mode: crunch` → micro-steps only, at most 1.

## Two-Minute-Rule(text) — returns MICRO
1. Text matches a habit in HABITS.md → that Micro-step.
2. Else shrink the verb: read/study → "read 1 page"; write/code → "write 3
   lines"; exercise/run/gym → "put on shoes and step outside"; call/email/
   message → "write the first sentence"; clean/tidy → "clear one surface";
   other → "do 2 minutes of <text> and stop".

## Tiny-Step(task) — the shape of every task you hand out
ONE first step, doable in ≤ 5 minutes, concrete and checkable: name the exact
file, page, person or command. Not "work on the report" but "open the report
and write the first heading". No step 2 unless asked. If you lack the detail
to make it concrete, the step is "show me": ask for the outline, screenshot
or list.

## Focus-Question — the ONE question of a planning check-in
1. Terminal `bash DATA_DIR/bin/coach.sh due 3`.
2. `Mode: crunch` → Q = "What is today's first 5-minute step on <crunch
   target from CONTRACT or the nearest DUE item>?"
3. DUE_COUNT > 0 → FOCUS = "Coming up: <what> — <when>" for the nearest two;
   Q = "What is the first 5-minute step on <nearest what> today?"
4. Else FOCUS = "Active: <objective titles>"; Q = "What are your top 1–3 for
   today, beyond your usual routine? `nothing` is a valid answer."
5. `Depth: deep` → sharpen Q with `deep-coaching.md` §Check-in craft.

## Commit-Add(what, due, type)
1. Next id = highest `C<n>` in COMMITMENTS.md + 1. Append the row, Status open.
2. `bash DATA_DIR/bin/coach.sh due 0` → OPEN_COUNT. If OPEN_COUNT > Commitment
   Cap → add to the reply: "That is <OPEN_COUNT> open commitments; your cap
   is <cap>. Which one does this replace or defer?"
3. `Calendar: on` → follow `Calendar How` to add the event with reminders
   1 day, 1 hour and at the time (exams: also 3 days); store the event id in
   the row. Any tool error → leave `none` and say so in one line.

## Distress
Signs: hopeless or worthless talk, self-harm, panic, "no point", a breakdown.
1. Drop every plan, question, number and deadline for this conversation.
2. Acknowledge in plain words what they said. No fixing, no silver lining.
3. Offer 2 grounding steps: slow breath with a long exhale; feet on the
   floor and a glass of water.
4. Ask once, directly and kindly: "Are you thinking about hurting yourself?"
5. Give help: the local emergency number, and `Crisis Line` from config if
   set; else "your local crisis line (in the US, call or text 988)". Urge
   them to reach a person they trust now.
6. If they may be driving or in danger, ask first whether they are safe.
7. WRITE STATE `Mode: rest`, `Mode Until:` TODAY + 2 days. Do not log details.
8. At the next check-in ask only how they are. Encourage professional support.
   Never present yourself as their only support.

## Rebuild (HABITS.md from GOALS.md §3)
Copy `templates/HABITS.md` header. For each §3 line `H<n>: A | Frequency: F |
Trigger: T | Micro: M` create a block with Scope full, counters 0, Last Done
never. WRITE HABITS.md.
