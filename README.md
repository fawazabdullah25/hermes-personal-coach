# hermes-personal-coach

An autonomous, psychologically grounded personal coach for
[Nous Research Hermes Agent](https://github.com/NousResearch/hermes-agent).

It runs entirely inside your existing Hermes install — no servers, no
databases, no accounts. The coach checks in with you on a schedule you choose,
in whatever chat you already use with Hermes (WhatsApp, Telegram, Discord,
Slack, the CLI, etc...), and keeps its memory in plain Markdown files you can read
and edit yourself.

## What a day looks like

```
07:00  Coach:  Morning. What is within your control today?
               Active: Ship the onboarding flow · Run a 10k
               Due today: H1 30-min run · H3 Read 10 pages
               What are your top 1–3 non-negotiables today?
       You:    1. finish signup form  2. run  3. call mum
       Coach:  What's the #1 thing likely to derail item 1, and what will
               you do when it happens? Format: If ___, then I will ___.
       You:    if slack gets noisy then i will mute it until 11
       Coach:  Locked. Mute until 11, then ship.

20:30  Coach:  Which did you finish? Reply with numbers and habit IDs,
               e.g. `1 3 H2`, or `none`.
       You:    1 3 H1
       Coach:  Form shipped, mum called, run done. Rate the day 1–5.
       You:    4
       Coach:  Good day. Tomorrow we go again.
```

Miss a habit two days running and the coach doesn't lecture you — it shrinks
the habit to its 2-minute version until you've won three in a row.

## Features

- **GROW onboarding** – ten-minute guided setup: vision → reality → options →
  this week's commitment. Progress is saved after every question.
- **Daily WOOP commitments** – 1–3 non-negotiables plus an
  *if-obstacle-then-action* plan every morning.
- **Habit streaks with the Two-Day Rule** – first miss is acknowledged
  neutrally; second consecutive miss triggers automatic scope reduction to a
  2-minute micro-step; three micro wins scale it back up.
- **Anti-ghosting** – if you ignore a check-in the coach never nags. The next
  scheduled check-in adapts (e.g. the evening debrief becomes a single
  "rate the day 1–5").
- **Weekly retrospective** – numbers for the week, three reflection questions,
  OKR status and renegotiation, log archiving.
- **Three cadences** – intensive (morning / midday / evening), balanced
  (morning / evening), minimalist (one check-in a day). All include a weekly
  retro on the day and time you pick.
- **Four voices** – Stoic Strategist, Drill Sergeant, Empathetic Mentor, or
  describe your own. Tone only; it never overrides your Hermes persona or
  safety rules.
- **Local and private** – everything lives in `~/.hermes/personal-coach/`.
  Nothing leaves your machine except the LLM calls Hermes already makes.

## Requirements

- Hermes Agent **0.21.0 or later** (tested on 0.21.0). The skill needs the
  `cronjob_manage` tool with `attach_to_session` support, the terminal tool,
  and file read/write.
- A model that follows multi-step tool instructions reliably:
  - **Recommended floor: a 14B-class instruct model.**
  - 8B models work best-effort — always use the `/personal-coach …` slash
    commands rather than plain text, and expect the occasional retry.
  - 32B+ and hosted frontier models are comfortable.
- Bash 3.2+ and coreutils for the install scripts (macOS and Linux).

## Install

```bash
git clone https://github.com/fawazabdullah25/hermes-personal-coach.git
cd hermes-personal-coach
./install.sh            # or: bash install.sh
hermes gateway restart  # required so the gateway registers the new command
```

`install.sh` copies the skill to `~/.hermes/skills/personal-coach/` and creates
an empty data directory at `~/.hermes/personal-coach/`. It never touches
`SOUL.md`, `config.yaml`, `MEMORY.md`, credentials, or other skills.

Developers can symlink instead of copying with `./install.sh --link`; user
data still lives outside the repo, so `git status` never shows it.

Verify: send `/commands` in your chat and page through until you see
`/personal-coach`.

## Quickstart

> **Run setup from the chat where you want the check-ins delivered.**
> Cron jobs post back to the chat that created them.

1. Send `/personal-coach setup` (plain `coach setup` also works on most models).
2. Answer one question at a time:
   1. Confirm your clock and time zone, and which day your week starts.
   2. Pick a cadence and enter times as 24-hour `HH:MM`.
   3. Pick a voice.
   4. Give 1–3 long-term outcomes, one sprint objective (4–12 weeks) with
      1–3 key results (the coach proposes each KR in a fill-in shape — just
      say `accept` or send your own version), and up to 5 habits with a
      trigger and a 2-minute fallback each.
3. The coach registers its cron jobs, verifies the scheduler shows the right
   next-run time, and tells you when the first check-in arrives.
4. Try it immediately: `/personal-coach test morning` (dry run, nothing saved).

## Commands

Use `/personal-coach <command>` (reliable on every model) or `coach <command>`.

| Command | What it does |
|---|---|
| `setup` | Runs or resumes the onboarding wizard. If already set up, offers `redo` (re-creates cron jobs; backs up `GOALS.md`) or `keep`. |
| `status` | Active OKRs, today's commitments, habit streaks and scope, each cron job's health (found / missing, next run). |
| `test morning` \| `pulse` \| `evening` \| `weekly` \| `daily` | Simulates that check-in now. Dry run: prefixed `[TEST — nothing saved]`, writes nothing. |
| `timezone` | Re-reads the system clock and rewrites the cron schedules in place (job IDs unchanged). Use after DST changes or travel. |
| `pause` / `resume` | Pauses/resumes every coach cron job in Hermes and records the state. No messages arrive while paused. |
| `teardown` | Removes all coach cron jobs. Goals and logs stay on disk. |
| `help` | Lists these commands. |
| `edit` (natural language) | "move my evening debrief to 21:00", "add habit: stretch daily, after coffee, micro: 1 stretch", "back to full H2". The coach shows the exact line change and asks `yes/no` before writing. |

You can also just talk to it: "what should I focus on today?", "I'm stuck on
KR 1.2". Those turns read your files but never write them.

## Cadence tiers

| Tier | Check-ins | Times you provide |
|---|---|---|
| intensive | morning kickoff · midday pulse · evening debrief · weekly retro | wake, bed, morning, midday, evening, weekly day+time |
| balanced | morning kickoff · evening debrief · weekly retro | wake, bed, morning, evening, weekly day+time |
| minimalist | one daily check-in · weekly retro | wake, bed, daily time, weekly day+time, and a mode: `plan` (morning planning), `review` (evening review), or `combined` (morning: review yesterday + plan today) |

## Voices

| Voice | Style |
|---|---|
| Stoic Strategist | Calm, precise, focused on what you control and on deep work. |
| Drill Sergeant | Short sentences, urgent, zero excuses — but never insults. |
| Empathetic Mentor | Warm, reflective, names feelings, psychologically safe. |
| Custom | You describe tone, humour and toughness in 2–3 sentences. |

All voices share hard rules: no sarcasm about failures, never moralise a
miss, at most two sentences of personality per message, and they never
override your `SOUL.md` or Hermes safety behaviour.

## How it works

### Two directories

| Path | Contents | Owner |
|---|---|---|
| `~/.hermes/skills/personal-coach/` | Code: `SKILL.md`, `references/`, `templates/` | Replaced on upgrade. The agent never writes here. |
| `~/.hermes/personal-coach/` | Data: `COACH_CONFIG.md`, `GOALS.md`, `HABITS.md`, `STATE.md`, `logs/`, `backups/` | Yours. Survives upgrade and uninstall (unless you choose to purge). |

### Data files (all Markdown, all editable by hand)

- `COACH_CONFIG.md` — status, time zone, cadence, times, voice, registered cron IDs.
- `GOALS.md` — §1 vision & roadmap milestones (never archived), §2 active OKRs
  with status, §3 habits with trigger and micro-step, §4 constraints, §5 archive.
- `HABITS.md` — the habit ledger: streak, consecutive misses, scope
  (`full`/`micro`), micro completions. Updated by the evening routine.
- `STATE.md` — five lines: what question is currently pending, since when,
  and whether test mode is on.
- `logs/YYYY-MM-DD.md` — one file per day: commitments + WOOP plan, habits
  due, midday status, evening completions, wins, obstacles, 1–5 score.
- `logs/weekly/YYYY-Www.md` — weekly rollups (kept forever).
- `logs/archive/` — daily logs older than 56 days, moved there by the weekly
  retro. Long roadmaps are unaffected: milestones live in `GOALS.md §1` and
  are surfaced when they come within a month.
- `backups/` — a copy of `GOALS.md` before every weekly edit and before `redo`.

### Routing

`SKILL.md` is a small router (about 900 tokens). It dispatches to exactly one
reference file per turn — onboarding, one of the routines, the command
handler, or the pending-reply handler — so even small models see only the
algorithm they need. Every reference file is a numbered, if/else algorithm
with one question per message and explicit WRITE steps.

### Cron

Each check-in is a native Hermes cron job named `coach-morning`,
`coach-midday`, `coach-evening`, `coach-daily`, or `coach-weekly`, created
with a 5-field cron expression, `skills=["personal-coach"]`, and
`attach_to_session=true`. The job's prompt names the exact reference file to
execute. Because it was created from your chat, its output is delivered
there, and your reply continues the same session.

If your gateway is configured to start fresh sessions periodically, replies
still work: every check-in records what it asked in `STATE.md`, and the
router checks that first on every message.

Every routine is idempotent — if the scheduler fires late or twice (after a
reboot, for example) it detects that the step is already done and stays quiet.
The coach never creates extra reminder jobs.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `/personal-coach` not in `/commands` | Run `hermes gateway restart`. Then check `ls ~/.hermes/skills/personal-coach/SKILL.md` exists. |
| Check-ins arrive in the wrong chat / not at all | They go to the chat that ran setup. Open the chat you want, run `/personal-coach teardown`, then `/personal-coach setup` → `redo`. |
| Check-ins arrive at the wrong hour | `/personal-coach timezone`. If still wrong, tell the coach "the morning check-in arrived at 06:00" — it stores an offset and rewrites the schedules. |
| `status` shows a cron job as MISSING | `/personal-coach timezone` re-creates missing jobs. `hermes cron doctor` and `hermes cron list` show the scheduler's view. |
| Coach answered "4 what?" to a rating | Your session was reset between check-in and reply. Send `/personal-coach status` once (this loads the skill), then repeat the rating. On small models prefer the slash command for every interaction. |
| Duplicate morning messages | Run `/personal-coach status`; if two jobs share a name, `/personal-coach setup` → `redo` removes all `coach-*` jobs and re-creates them. |
| Coach sent a file instead of text | A bare file path in its reply — please open an issue with the message; paths must be in backticks. |
| I want quiet for a while | `/personal-coach pause`, later `/personal-coach resume`. Nothing fires while paused and no streaks are penalised for days without a log. |
| Setup got interrupted | Send `/personal-coach setup` — it resumes at the saved step. |
| I edited `GOALS.md` by hand | Fine. If you changed habits, send `coach edit rebuild habits` so the ledger is regenerated. Keep the line shapes shown in the file. |

## Privacy

All coaching data is plain text under `~/.hermes/personal-coach/` with
`0700` permissions. The skill makes no network calls of its own. Delete the
directory and it's gone.

## Upgrade

```bash
cd hermes-personal-coach && git pull && ./install.sh && hermes gateway restart
```

Code is replaced; the previous install is kept as
`~/.hermes/skills/personal-coach.bak.<timestamp>`; data is untouched. If a
release changes a data schema, `install.sh` migrates it and `CHANGELOG.md`
says so.

## Uninstall

```bash
./uninstall.sh                # removes cron jobs via `hermes cron`, then the code; asks about data
./uninstall.sh --keep-data    # never prompts about data
./uninstall.sh -y --purge-data
```

If a cron job cannot be removed the script stops and asks you to run
`/personal-coach teardown` first (or `--force`).

## Renaming the command to `/coach`

The slash command is the skill's directory name. To get `/coach`:
`SKILL_NAME="coach"` in `install.sh` and `uninstall.sh`, `name: coach` in
`skill/SKILL.md`, then reinstall and `hermes gateway restart`. Data stays at
`~/.hermes/coach/`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). New voices, better prompts for small
local models, and integrations are especially welcome.

## License

MIT — see [LICENSE](LICENSE).
