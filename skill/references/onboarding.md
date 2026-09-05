# coach setup — Onboarding (GROW)

Progress is saved after every step in COACH_CONFIG.md (`Onboarding Step`) so a
reset session resumes. Ask exactly one question per message. Write files with
the file write tool; copy templates with terminal `cp`.

## Step 0 — Resume or restart
1. If COACH_CONFIG.md missing → `mkdir -p DATA_DIR/logs/weekly DATA_DIR/logs/archive
   DATA_DIR/backups`; copy templates COACH_CONFIG.md, GOALS.md, HABITS.md, STATE.md
   into DATA_DIR. Set STEP = 1.
2. Else if `Status: onboarding` → STEP = value of `Onboarding Step`. Say
   "Resuming setup at step STEP." Go to that step.
3. Else (active/paused) → ask: "You're already set up. Reply `redo` to start
   over (existing cron jobs will be replaced; GOALS.md is backed up) or `keep`."
   - `keep` → STOP. - `redo` → copy GOALS.md to
   `backups/GOALS.<TODAY>.md`; run cron-engine.md §Teardown; reset config to
   template; STEP = 1.
4. IMPORTANT: this must run from the chat where the user wants check-ins. Say
   once: "Check-ins will be delivered to THIS chat."

## Step 1 — Timezone (Reality)
1. Terminal: `date "+%H:%M %Z %z"`.
2. Ask: "Your system clock says <HH:MM> (<Z> <±hhmm>). Does that match your
   local time? Reply `yes` or give the correct offset like `+0200`."
3. `yes` → Host Timezone = "<Z> <±hhmm>". Otherwise store the given offset and
   set Model Note: "user offset differs from host; verify schedule".
4. Ask: "Which day does your week start? `Mon`, `Sun`, or `Sat`." Store.
5. WRITE config; Onboarding Step = 2.

## Step 2 — Cadence & times
1. Ask: "Pick a cadence:
   1 intensive — morning plan, midday pulse, evening debrief, weekly retro
   2 balanced — morning plan, evening debrief, weekly retro
   3 minimalist — one daily check-in, weekly retro
   Reply 1, 2 or 3."
2. Store Cadence Tier. Then collect times ONE AT A TIME, validating `HH:MM`
   (00–23, 00–59); if invalid, repeat the same question once with an example.
   - intensive: Wake, Bed, Morning Kickoff, Midday Pulse, Evening Debrief.
   - balanced: Wake, Bed, Morning Kickoff, Evening Debrief.
   - minimalist: Wake, Bed, then ask: "Should the daily check-in be
     `plan` (morning: plan today), `review` (evening: review today), or
     `combined` (morning: review yesterday + plan today)?" Store Minimalist
     Mode; then ask Daily Review time.
3. Ask: "Weekly retrospective day and time? e.g. `Sun 18:00`." Validate day ∈
   Mon..Sun. Store as "Day at HH:MM".
4. WRITE config; Onboarding Step = 3.

## Step 3 — Archetype
1. Ask: "Choose your coach's voice:
   1 Stoic Strategist — calm, rational, deep work, what's in your control
   2 Drill Sergeant — direct, urgent, zero excuses
   3 Empathetic Mentor — warm, reflective, psychologically safe
   4 Custom — you describe it
   Reply 1–4."
2. If 4 → ask: "In 2–3 sentences: tone, humor level, toughness level." Store
   as Archetype Prompt; Archetype = Custom. Else Archetype = name, Prompt = none.
3. WRITE config; Onboarding Step = 4.

## Step 4 — Goals & habits (Goal → Reality → Options → Will)
1. GOAL: "Name 1–3 outcomes you want in 1–3 years. One line each." Write each
   as `V<n>` in GOALS.md §1. For each, ask: "What's one milestone on the way to
   V<n>, and by which month (YYYY-MM)?" (skip allowed). Write milestones.
2. REALITY: "For V1, where are you today? One or two sentences." Store the
   answer in §4 as `- Baseline V1: …` (repeat for V2/V3 only if given).
3. OPTIONS → OBJECTIVES: "What is the ONE objective for the next 4–12 weeks
   that moves this forward? Title only." Write `### O1`. Ask: "How many weeks
   is this sprint (4–12)?" Write sprint dates (start TODAY, end TODAY + weeks).
   Allow up to 3 objectives: after each, ask "Another objective? `yes`/`no`."
4. KEY RESULTS (template method): For each objective propose ONE KR in this
   exact shape: "KR 1.1: [Increase|Reduce|Complete] <metric> from <baseline>
   to <target> by <sprint end>." Ask: "Accept, edit, or replace? Reply
   `accept` or send your version in the same shape." Allow up to 3 KRs per
   objective; after each, "Another KR? `yes`/`no`." Write each with
   `| Status: on-track`.
5. WILL → HABITS: "Which daily/weekly habits are non-negotiable? List up to 5,
   one per line." For EACH habit, ask in one message:
   "H<n> <habit>: (a) frequency — `Daily`, `Weekdays`, `Weekends`, or days like
   `Mon/Wed/Fri`; (b) trigger — 'After ___, I will ___'; (c) 2-minute version
   for hard days. Reply as three lines."
   Validate frequency; write §3 line `H<n>: … | Frequency | Trigger | Micro`.
6. Ask: "Any constraints I must respect (no messages before/after certain
   hours, health limits, family rules)?" Write §4.
7. WRITE GOALS.md. Run protocols.md §Rebuild to create HABITS.md.
   Onboarding Step = 5.

## Step 5 — Register cron jobs
1. Read `references/cron-engine.md` and execute §Register, then §Verify.
2. On success: Status = active, Onboarding Step = done; WRITE config;
   WRITE STATE.md Pending: none.
3. Reply (archetype tone, ≤ 100 words): summary of tier, times, first check-in
   (name + time), and: "Commands: `/personal-coach status | test morning |
   pause | resume | timezone | teardown | help`."
