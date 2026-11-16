# Integrations — `coach integrations [name]`

The coach works with nothing but chat, cron and files. Everything here is
optional, off by default, and switched on only by the user. Hermes installs
differ: CHECK that a tool or skill really exists before you mention it as
available, and never describe a setup step you have not verified in this
install (`skills_list`, the tool list, or `hermes skills search <name>`).

## Contents
Catalogue · Offer · Setup · Verify · Answers · Memory pointer · Rules

## Catalogue
| Name | What it adds to coaching | Usually provided by |
|------|--------------------------|---------------------|
| calendar | Deadlines become events with reminders; the morning check-in knows today's schedule | bundled `google-workspace` skill, or a calendar MCP server |
| voice | Spoken check-ins and follow-ups; the user can answer by voice note | `text_to_speech` tool; transcription is automatic on most chat platforms; the user can also send `/voice tts` |
| calls | A real phone call when texts go unanswered (relentless intensity) | optional `telephony` skill (Twilio; paid), or a SIP call MCP server with a free softphone app on the user's phone |
| proof | Photo evidence of a finished commitment | `vision_analyze` tool |
| memory | The coach is recognised after a session reset | `memory` tool (§Memory pointer); optional memory providers via `hermes memory setup` |
| history | Recall what was said weeks ago | `session_search` tool — nothing to set up |
| research | A roadmap or study plan built from real sources | `web_search`, `web_extract`, `delegate_task` |
| notes | Commitments mirrored to the user's notes or reminders app | bundled `obsidian`, `apple-notes`, `apple-reminders` skills |
| fitness | Workout and nutrition data for health goals | optional `fitness-nutrition` skill |
| code | Commits and PRs as evidence for coding goals | bundled `github` skill |
| lights | A cue in the room when a focus block starts | optional `openhue` skill; Home Assistant plugin |
| music | A focus playlist tied to a habit ("only while studying") | Spotify plugin |
| events | An outside event (a wearable, a form, a git push) triggers a check-in | Hermes webhooks routed to a coach cron job |
| push | A second channel for the weekly scorecard | a cron `deliver` target such as email or ntfy |

If the user asks for something not listed, look for a matching skill or MCP
server, say what you found and how sure you are, and follow §Setup.

## Offer (called by the weekly Close; at most one line per fortnight)
1. `Integration Offers: off`, or STATE `Last Offer` is less than 14 days
   ago, or `Mode` ≠ normal → return nothing.
2. Pick the FIRST rule that matches and is neither on nor in `Declined
   Integrations`:
   - 2+ open dated rows in COMMITMENTS.md and `Calendar: off` → calendar
   - `Input Mode: voice` and `Voice Notes: off` → voice
   - `Intensity: relentless` and `Calls: off` → calls
   - REPLIED below half this week, `Voice Notes: off` → voice
   - `Memory Pointer: off` and the `memory` tool exists → memory
   - `Depth: deep` → any catalogue row a goal clearly calls for (a fitness
     goal → fitness; a coding goal → code; a study goal → research)
   No match → return nothing.
3. Return one line: "Idea: <benefit in ≤ 15 words>. Want it? `yes`, `later`,
   or `never`." WRITE STATE Last Offer: TODAY; Pending: integration_offer;
   Pending Question: <name>.

## Setup(name)
1. Already working? If the tool or skill is present → go to §Verify.
2. Explain in ≤ 60 words: what it adds, what it needs (account, key, app,
   cost), and what it will be allowed to do. Ask: "Set it up? `yes`/`no`."
3. `Action Mode: do` → one step at a time: show the exact command or
   change, wait for `yes`, run it, show the result. This is the ONLY place
   you may act outside DATA_DIR (install a skill, add an MCP server entry).
   If a step is refused by the system, or you cannot reach the host config
   (sandboxed terminal), switch to guide for this integration.
4. `Action Mode: guide` → WRITE `DATA_DIR/briefs/<name>-setup.md`: goal,
   prerequisites, exact steps and commands, how to test, how to undo. Send
   the steps in chat too. The brief is written so the user — or another
   tool or person who manages the host — can follow it without this chat.
   Ask the user to say `done` when finished. WRITE STATE Pending:
   integration_done; Pending Question: <name>.
5. Secrets (API keys, passwords, tokens): never ask for them in chat and
   never write them into DATA_DIR. Say which file or setting they go in.
6. Then §Verify.

## Verify — nothing is "on" until a real test passes
Ask before testing. One test per integration:
- calendar: create an event titled "coach test" 10 minutes from now with a
  reminder, read it back, delete it.
- voice: send one 5-second voice note; ask if it played.
- calls: one test call inside call hours; ask if it rang and was audible.
- proof: ask for any photo; describe it in one line.
- others: one read-only call that returns real data.
Passed → WRITE config: the flag `on`, and `Calendar How` / `Call How` as
ONE line naming the exact skill or tools to use and any quirk found in the
test. If scheduled runs need the tool (calls, calendar, voice) and the cron
jobs restrict toolsets → WRITE `Cron Toolsets` (add the toolset or MCP
server name) and run cron-engine.md §Sync-Toolsets, then test once from a
scheduled run with `cronjob_manage(action="run")`.
Failed → flag stays `off`; say exactly what failed; offer to retry later.

## Answers (via pending.md)
- integration_offer: `yes` → §Setup(name). `later` → nothing. `never` / `no
  thanks` → add the name to `Declined Integrations`; "I won't suggest it
  again." WRITE Pending: none.
- integration_done (user said `done` in guide mode) → §Verify.

## Memory pointer (`Memory Pointer`)
With the user's `yes`, add ONE entry with the `memory` tool (target
`memory`): "personal-coach skill is active; data in <DATA_DIR>. A short
reply (a 1–5, done, nothing) may answer its check-in — load the skill and
read STATE.md." Agent memory is small and shared: never add more than this
one entry, and never store coaching content there. Full memory → tell the
user, change nothing. WRITE `Memory Pointer: on`.

## Rules
- `coach integrations` with no name → list what is on, what is off, and
  what was declined; ask which one to set up.
- `coach integrations off <name>` → flag `off`. Remove nothing from the
  host unless the user asks; then follow §Setup in reverse.
- `coach integrations offers on|off` → WRITE `Integration Offers`.
- Calendar habits: dated commitments go on the calendar; daily habits do
  not (they are chat check-ins). Every event gets reminders. Tell the user
  whenever you remove an event. Ask before the first event; after that,
  follow what `CONTRACT.md` says about asking.
- Calls: only inside `Call Hours`, never during bed→wake hours, at most 3
  attempts per trigger, 2–3 sentences per turn. The user can stop them any
  time with `coach intensity firm`.
- Any integration that errors in a scheduled run must fail quietly: skip
  it, finish the check-in, and mention the fault once in the next reply
  the user reads.
