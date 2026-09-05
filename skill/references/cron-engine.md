# Cron Engine (the ONLY place that creates/updates/removes cron jobs)

## Schedule construction
- Daily `HH:MM` → cron `M H * * *` (strip leading zeros: 07:30 → `30 7 * * *`).
- Weekly `Day at HH:MM` → `M H * * D`, D: Sun=0 Mon=1 Tue=2 Wed=3 Thu=4 Fri=5 Sat=6.
- If `Schedule Offset Hours` = k ≠ 0: H' = (H − k) mod 24 (terminal:
  `python3 -c "print((H-k)%24)"`); if H' crosses midnight for weekly, shift
  D by ±1 accordingly.

## Job table (by tier)
| Job name       | Tier                  | Routine | Config time         |
| coach-morning  | intensive, balanced   | morning | Morning Kickoff     |
| coach-midday   | intensive             | midday  | Midday Pulse        |
| coach-evening  | intensive, balanced   | evening | Evening Debrief     |
| coach-daily    | minimalist            | daily   | Daily Review        |
| coach-weekly   | all                   | weekly  | Weekly Retrospective|

## Prompt template (identical for all; only X changes)
"CRON RUN: routine=X. You are the user's personal coach. Read
`~/.hermes/skills/personal-coach/SKILL.md`, then read and execute
`~/.hermes/skills/personal-coach/references/routine-X.md` exactly. Data is in
`~/.hermes/personal-coach/`. Ask at most one question. Your final response is
delivered to the user: output only the coaching message."

## Register
1. `cronjob_manage(action="list")`. For any existing job whose name starts
   with `coach-` → `remove` it (prevents duplicates on re-setup).
2. For each job in the table for the current tier:
   `cronjob_manage(action="create", name="<job>", schedule="<cron>",
   prompt="<template with X>", skills=["personal-coach"],
   attach_to_session=true)`. (Omit `deliver` → origin chat.)
3. Store the returned id in config `<Job> Cron ID`. If the tool errors →
   record `none`, tell the user, continue with the next job.

## Verify (scheduler timezone self-check)
1. `cronjob_manage(action="list")`; find `coach-morning` (or `coach-daily`).
2. REPORTED_H = hour of its next run as shown by the tool. CONFIG_H = hour of
   the configured time. If they match → Scheduler Timezone Verified: yes.
3. If they differ → k = (CONFIG_H − REPORTED_H) mod 24 (python one-liner);
   Schedule Offset Hours = k (or −k if REPORTED is later than CONFIG);
   run §Update-All; re-list; if now equal → Verified: yes; else Verified: no
   and tell the user: "Scheduler clock differs; check-in times may be off by
   <k>h — tell me the time the first check-in actually arrives and I'll fix it."

## Update-One(job)
`cronjob_manage(action="update", job_id=<id>, schedule="<new cron>")` —
never remove+create (keeps id and delivery target). If the id is MISSING →
create it as in §Register step 2 and store the new id.

## Update-All
Run Update-One for every job in the table for the tier.

## Teardown
1. `list`. For each config ID that exists → `remove`. Also remove any job whose
   name starts with `coach-` (orphans from crashed setups).
2. Set all IDs to `none`.
