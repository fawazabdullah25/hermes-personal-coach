# Cron Engine (the ONLY place that creates, updates or removes cron jobs)

Must run from a chat with the user — scheduled runs cannot create jobs. If
the cron tool is called `cronjob` in this install, use that name.

## Schedule construction
- Daily `HH:MM` → `M H * * *` (no leading zeros: 07:30 → `30 7 * * *`).
- Weekly `Day at HH:MM` → `M H * * D`; Sun=0 Mon=1 Tue=2 Wed=3 Thu=4 Fri=5 Sat=6.
- `Schedule Offset Hours` = k ≠ 0 → hour = terminal `echo $(( (H - k + 24) % 24 ))`;
  if that crosses midnight on a weekly job, shift D by one day.
- Do all time arithmetic in the terminal with `echo $(( … ))`, never mentally.

## Job table
| Job name       | Tier                | Routine | Time                      |
| coach-morning  | intensive, balanced | morning | Morning Kickoff           |
| coach-midday   | intensive           | midday  | Midday Pulse              |
| coach-evening  | intensive, balanced | evening | Evening Debrief           |
| coach-daily    | minimalist          | daily   | Daily Review              |
| coach-weekly   | all                 | weekly  | Weekly Retrospective      |
| coach-nudge-am | all, see §Nudges    | nudge   | first check-in + delay    |
| coach-nudge-pm | intensive, balanced | nudge   | Evening Debrief + delay   |

## Nudges (follow-up jobs)
- `Intensity: gentle` → no nudge jobs.
- D = Follow-up Delay Minutes. AM base = Morning Kickoff (or Daily Review).
  T = `echo $(( (H*60 + M + D) % 1440 ))`; hour = T / 60; minute = T % 60.
- PM base = Evening Debrief. GAP = minutes from Evening Debrief to Bed Time
  (add 1440 if Bed Time is past midnight). GAP < 40 → no PM job. GAP < D + 30
  → use D = GAP / 2 for the PM job.
- Minimalist `review` mode: the single nudge follows the same PM rule.

## Prompt template (only X changes)
"CRON RUN: routine=X. You are the user's personal coach. Load the
`personal-coach` skill and execute its `references/routine-X.md` exactly.
Ask at most one question. Your final response is delivered to the user:
output only the coaching message, or exactly [SILENT] when the routine says
so."

## Register
1. `cronjob_manage(action="list")`. Remove every existing job whose name
   starts with `coach-` (prevents duplicates on re-setup).
2. For each job in the table for the current tier and intensity:
   `cronjob_manage(action="create", name="<job>", schedule="<cron>",
   prompt="<template>", skills=["personal-coach"], attach_to_session=true)`.
   Omit `deliver` (→ the chat that ran setup). If `Cron Toolsets` ≠ default,
   also pass `enabled_toolsets=[<that list>]`.
3. Store each returned id in config `<Job> Cron ID`. Tool error → record
   `none`, tell the user, continue with the next job.

## Verify
1. `list`; find `coach-morning` (or `coach-daily`). REPORTED_H = hour of its
   next run; CONFIG_H = configured hour. Equal → Scheduler Timezone
   Verified: yes.
2. Differ → k = `echo $(( (CONFIG_H - REPORTED_H + 24) % 24 ))`; Schedule
   Offset Hours = k; §Update-All; re-list. Equal now → Verified: yes. Else
   Verified: no and tell the user: "Scheduler clock differs; tell me when
   the first check-in actually arrives and I'll fix it."
3. Any job whose last status is an error → tell the user its name and the
   error text in one line.

## Update-One(job)
`cronjob_manage(action="update", job_id=<id>, schedule="<new cron>")` — never
remove + create (keeps id and delivery chat). Id MISSING → create it as in
§Register step 2 and store the new id.

## Update-All
§Update-One for every job in the table, then §Sync-Nudges.

## Sync-Nudges (after any change of Intensity, times or delay)
Nudge jobs that should exist but don't → create. Exist but shouldn't →
remove and set the id to `none`. Exist → §Update-One with the new time.

## Sync-Toolsets (after `Cron Toolsets` changes)
For every coach job: `cronjob_manage(action="update", job_id=<id>,
enabled_toolsets=[…])`.

## Teardown
`list`. Remove every config ID that exists, and any job whose name starts
with `coach-`. Set all IDs to `none`.
