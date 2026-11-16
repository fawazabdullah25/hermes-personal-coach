# coach setup — Onboarding, part 1 (steps 0–3)

About 5 minutes in total. Progress is saved in COACH_CONFIG.md (`Onboarding
Step`) after every step, so a reset session resumes. ONE question per
message. Steps 4–6 are in `references/onboarding-goals.md`.

## Step 0 — Resume, upgrade or restart
1. COACH_CONFIG.md missing → `mkdir -p DATA_DIR/logs/weekly
   DATA_DIR/logs/archive DATA_DIR/backups DATA_DIR/briefs`; copy templates
   COACH_CONFIG.md, GOALS.md, HABITS.md, STATE.md, CONTRACT.md and
   COMMITMENTS.md into DATA_DIR. Read COACH_CONFIG.md back: if it is not
   there, STOP and tell the user: "I can't write to my data folder. See
   'Docker and sandboxes' in the README." Else STEP = 1.
2. `Status: onboarding` → STEP = `Onboarding Step`. Say "Resuming setup at
   step STEP." STEP ≥ 4 → continue in onboarding-goals.md.
3. Active or paused, and `Version` is not `2.0.0` → UPGRADE: say "Updated to
   v2 — your goals, habits and logs are kept. Three quick questions. New:
   an unanswered check-in now gets one lighter follow-up; `coach intensity
   gentle` turns that off." Go to onboarding-goals.md Step 5, then Step 6.
4. Active or paused on 2.0.0 → ask: "You're already set up. `redo` starts
   over (cron jobs are replaced; GOALS.md is backed up) or `keep`."
   `keep` → STOP. `redo` → copy GOALS.md to `backups/GOALS.<TODAY>.md`;
   cron-engine.md §Teardown; reset config to the template; STEP = 1.
5. Say once: "Check-ins will arrive in THIS chat."

## Step 1 — Clock
1. Terminal `date "+%H:%M %Z %z"`.
2. Ask: "Your system clock says <HH:MM> (<Z> <±hhmm>). Is that your local
   time? `yes`, or give your offset like `+0200`."
3. `yes` → Host Timezone = "<Z> <±hhmm>". Else store the offset and set
   Model Note: "user offset differs from host; verify schedule".
4. Ask: "Which day does your week start? `Mon`, `Sun` or `Sat`."
5. WRITE config; Onboarding Step = 2.

## Step 2 — Cadence and times
1. Ask: "How often should I check in?
   1 balanced — morning plan + evening review (recommended)
   2 minimalist — one check-in a day
   3 intensive — morning, midday and evening (most people drop this within
     a week; pick it only for a short push)
   All include a weekly review. Reply 1, 2 or 3."
2. Store Cadence Tier. Collect times ONE AT A TIME, validating `HH:MM`
   (00–23, 00–59); if invalid, ask again once with an example.
   - all tiers first: "When do you usually wake up?" then "…go to bed?"
     (I never message or call between bed time and wake time.)
   - balanced: Morning Kickoff, Evening Debrief.
   - intensive: Morning Kickoff, Midday Pulse, Evening Debrief.
   - minimalist: ask "Should the daily check-in `plan` the day (morning),
     `review` it (evening), or `combined` (morning: review yesterday + plan
     today)?" Store Minimalist Mode; then the Daily Review time.
3. A check-in time inside bed→wake hours → say so and ask again.
4. Ask: "Weekly review day and time? e.g. `Sun 18:00`." Store "Day at HH:MM".
5. WRITE config; Onboarding Step = 3.

## Step 3 — Voice and intensity
1. Ask: "Choose my voice:
   1 Stoic Strategist — calm, rational, what's in your control
   2 Drill Sergeant — direct, urgent, zero excuses, zero insults
   3 Empathetic Mentor — warm, reflective
   4 Custom — you describe it
   Reply 1–4."
2. 4 → ask: "In 2–3 sentences: tone, humour, toughness." Store as Archetype
   Prompt; Archetype = Custom. Else Archetype = the name.
3. Ask: "When you don't answer a check-in, how hard should I push?
   1 gentle — I wait; the next check-in just gets smaller
   2 firm — one lighter follow-up, then I back off (recommended)
   3 relentless — follow-up, then a voice note, then a phone call inside
     your call hours (needs voice / calls set up; I'll help later)
   Reply 1, 2 or 3."
4. Store Intensity. 2 or 3 → ask: "How long should I wait before the one
   follow-up? Reply minutes, or `ok` for 120." Store Follow-up Delay Minutes
   (30–480).
5. WRITE config; Onboarding Step = 4. Continue in
   `references/onboarding-goals.md`.
