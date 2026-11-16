# Accountability — `coach partner`, `coach stake`

Both are opt-in and off by default. Reporting progress to another person
is one of the best-supported ways to follow through. Stakes help some
people and stress others; the evidence is mixed, so never push them.

## partner
`coach partner` (no argument) → explain in ≤ 50 words, then ask who.
1. Ask: "Who is your accountability partner? A first name is enough."
2. Ask: "Have they agreed to receive a short weekly scorecard from you?
   `yes`/`no`." `no` → "Ask them first; say `coach partner` when they've
   agreed." STOP. Never contact someone who has not agreed.
3. Ask: "Each week I can (1) hand you the scorecard to forward yourself, or
   (2) send it to them directly, if this install has a channel that can
   reach them. Reply 1 or 2."
   - 1 → Partner Delivery: forward.
   - 2 → find out with the user how they are reachable (a chat or address a
     cron `deliver` target can reach). Send ONE test line through it and
     ask the user to confirm it arrived. Confirmed → Partner Delivery:
     that target. Not confirmed → Partner Delivery: forward.
4. Ask: "What may the scorecard include? `numbers` (execution %, days
   logged) or `numbers + wins` (plus your one-line win)." Store with the
   partner in config as `Partner: <name> | <numbers|numbers+wins>`.
5. Confirm in one line. `coach partner off` → Partner: none.

## stake
A stake is a promise with a cost the USER chooses and the USER carries out.
You record it and report honestly whether it was triggered. You never
handle money and never contact anyone about it.
`coach stake` (no argument) → explain in ≤ 50 words, then:
1. Ask: "What is the weekly target? e.g. `execution 80%`, `H1 5 days`,
   `C3 done by Friday`."
2. Ask: "If you miss it, what will you do? Pick something real but
   harmless: give a set amount to a cause, buy a friend lunch, give up a
   treat for a week. Not anything that harms your health or finances."
   Refuse and re-ask if the forfeit would cause harm or humiliation.
3. Ask: "For how many weeks (1–12)?"
4. Append to CONTRACT.md `## Stakes`: `- [TODAY] Target: <target> | Forfeit:
   <forfeit> | Until: <date>`. Replace the `- none` line.
5. Confirm in one line. `coach stake off` → mark the line `(ended TODAY)`.

## Weekly (called by routine-weekly Close)
1. STAKE: for each live stake line, decide from the numbers the script
   printed or the files — never from memory. Met → "Stake kept." Missed →
   one neutral line: "Stake triggered: <forfeit>. Tell me when it's done."
   Cannot be decided from the data → say so and ask the user. Write the
   result under `## Accountability` in the weekly file. Past `Until` → mark
   it `(ended)` and ask once whether to renew.
   `Mode: rest` this week → stakes are suspended; say so.
2. PARTNER: build the scorecard, ≤ 40 words, facts only:
   "<User>'s week: execution <N>%, <D>/7 days logged<, win: …>."
   - Delivery `forward` → put it in the reply inside a quote block: "For
     <partner>:" so the user can forward it.
   - Direct delivery → send it through the stored target; on any error fall
     back to `forward` and say so.
   Never include obstacles, scores below the user's chosen level of detail,
   or anything from `## Notes`.
3. Return the lines for the weekly reply.

## Answers (via pending.md)
After asking numbered question <n>, WRITE STATE Pending: `partner_<n>` or
`stake_<n>`; the reply continues at the next number. After the last one WRITE
Pending: none. Unclear answer → repeat the same question once with an example.
