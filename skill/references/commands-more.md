# More commands

Each one: confirm in ONE line what changed. WRITE config before replying.

## intensity <gentle|firm|relentless>
1. No argument → explain in ≤ 60 words: gentle = no follow-ups, the next
   check-in just gets smaller; firm = one lighter follow-up per ignored
   check-in; relentless = firm, then a voice note, then a phone call, inside
   your call hours. Ask which. STOP.
2. `relentless` with `Calls: off` and `Voice Notes: off` → set it, and add:
   "Calls and voice notes aren't set up, so for now this behaves like firm.
   `coach integrations` sets them up."
3. WRITE `Intensity`. Then cron-engine.md §Sync-Nudges.

## depth <core|deep>
`deep` suits large hosted models; `core` suits small local models. WRITE
`Depth`. If the user asks which: "If I follow long instructions reliably
for you, pick deep."

## style <streaks|minimum>
WRITE `Tracking Style`. minimum = one small daily minimum, no streak
numbers; streaks = running streaks shown while they are alive.

## mode <rest|crunch|normal> [days] [target]
- `rest N` (default 3, max 14): WRITE STATE Mode: rest; Mode Until: TODAY +
  N. Evening becomes score-only; no follow-ups, no escalation.
- `crunch N <target>` (default 7): WRITE Mode: crunch; Mode Until. Append
  to CONTRACT.md Agreements: `[TODAY] Crunch until <date>: <target>`. Daily
  question is about the target; habits shrink to one micro-step.
- `normal`: WRITE Mode: normal; Mode Until: none.
Compute dates in the terminal (`date -d "+N days" +%F`, or `date -v+Nd +%F`).

## commit <add|done|drop|defer|list>
- `add <what> <date> [time]`: work out the date from CLOCK; echo it back as
  `YYYY-MM-DD (Day)`; then `protocols.md` §Commit-Add.
- `done C<n>` / `drop C<n>`: set Status. `defer C<n> <date>`: change Due
  (and the calendar event, if any).
- `list`: `bash DATA_DIR/bin/coach.sh due 30`; show the rows, nearest first.

## cap <number>
WRITE `Commitment Cap` (1–15): the most open commitments before I ask what
a new one replaces.

## remind <when> <what>
1. Work out the exact local time from CLOCK and echo it back.
2. `Calendar: on` → add a calendar event with a reminder at the time, per
   `Calendar How`.
3. Else create a one-shot job (allowed here only): `cronjob_manage(action=
   "create", name="coach-remind-<short>", schedule="<ISO local time>",
   prompt="Send the user exactly: Reminder — <what>", attach_to_session=
   true)`.
4. Both fail → say so plainly; never claim a reminder is set without a
   returned id.

## contract [add works|fails|agree <text>]
- No argument → show `CONTRACT.md` sections as short bullets (newest first,
  superseded lines hidden) and ask: "Anything to add or change?"
- `add …` → append `- [TODAY] <text>` to that section.
- A rule that contradicts an older one → append ` (superseded TODAY)` to
  the old line; never delete.
