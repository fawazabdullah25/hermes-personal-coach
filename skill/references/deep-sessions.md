# Deep sessions: `coach review`, `coach plan`, weekly pattern read

`Depth: core` → reply: "Reviews and planning sit-downs need deep mode
(`coach depth deep`). In core mode the weekly review covers the essentials."
STOP — except §Weekly pattern read, which simply does nothing in core.

## Contents
Weekly pattern read · Review (monthly / end of sprint) · Plan (sit-down) ·
Research · Proof

## Weekly pattern read (called by routine-weekly Close)
1. Read the last 7 daily logs (this is the one place that may).
2. Look for ONE pattern backed by at least three days: a time of day that
   fails, a kind of task that always carries over, a question that never
   gets answered, a day of the week that scores low, an if-then plan that
   keeps working.
3. If found: state it in one sentence with the evidence, and propose one
   change as a yes/no question. Append to `CONTRACT.md`:
   `- [TODAY] Observed: <pattern> (proposed: <change>)`.
4. No pattern with three days of evidence → say nothing. Never invent one.
5. `REPLIED` below half for two weeks running → propose a lighter cadence
   or a different time; the schedule is wrong, not the user.

## Review — `coach review`
Run monthly, and when a sprint ends. Conversation, not a form; the user may
answer several numbered points at once.
1. Numbers: `coach.sh week` for this week; read the weekly files since the
   last review for the trend (execution %, average day, replies).
2. Gain first: what exists now that did not at the start of the sprint.
   List it from the logs before asking for their view.
3. Per objective: each KR — done, on track, stalled, drop. For a stalled
   one, `deep-coaching.md` §Stall diagnosis before renegotiating.
4. The honest read: one thing they are doing that works; one thing you see
   that they may not want to hear. Evidence for both.
5. Contract: read `CONTRACT.md` back in short form. "Still true? Anything
   to change?" Supersede stale lines.
6. Commitments: walk open rows; close, drop or re-date each. Over the cap →
   §Over-commitment guard.
7. Next sprint (if this one ended): one objective, pre-mortem, KRs, habits
   — at most three habits, each with trigger and 2-minute version.
8. Close with dated actions written to COMMITMENTS.md, and save the notes
   to `DATA_DIR/docs/review-<TODAY>.md`. Back up GOALS.md before editing it.

## Plan — `coach plan` (a sit-down)
For roadmap questions: a long-term vision, choosing between paths, a big
decision, redesigning the week.
1. Agenda: keep `DATA_DIR/docs/agenda.md` during the week — add a line
   whenever something comes up that deserves a sit-down. Open the session
   by reading it back in order: urgent this week → rules and system →
   commitments → ideas.
2. Settle first the item everything else depends on.
3. Interrogate in rounds: 3–6 numbered questions per message, grouped under
   short headers; the user answers by number, often in one voice note.
   WRITE answers to `DATA_DIR/docs/plan-<TODAY>.md` before your next reply.
4. Vision work: 1–3 outcomes for 1–3 years (GOALS.md §1), each with
   milestones by month. For each, where they are today (baseline, §4).
5. Test ambition against capacity: hours actually free per week (from the
   logs, not from hope) against what the plan needs.
6. Give your recommendation and hold it (`deep-coaching.md` §Stance).
7. End with: decisions made, dated actions (→ COMMITMENTS.md), what was
   parked (→ agenda), and any change to check-ins (→ `commands.md` §edit).

## Research (when a plan needs facts you don't have)
Ask first: "Want me to research <question>? It takes a few minutes."
On `yes` use `web_search` / `web_extract`, or `delegate_task` for a larger
question, with a precise brief. Save the result with its sources to
`DATA_DIR/docs/research-<topic>.md`, give the user the three points that
change the plan, and say how confident you are. Never present a guess as a
finding.

## Proof (`Photo Proof: on`)
When the user sends a photo as evidence of a commitment (the gym, the
finished page, the clean desk), look at it with `vision_analyze`, mark the
item done through `capture.md`, and answer in one line. Never demand proof;
it exists because some people follow through better when someone looks.
