# hermes-personal-coach

A personal coach for [Nous Research Hermes Agent](https://github.com/NousResearch/hermes-agent)
that checks in on a schedule, follows up when you go quiet, and tells you
what it sees.

It runs inside your existing Hermes install — no servers, no accounts. It
talks to you in the chat you already use (WhatsApp, Telegram, Discord,
Slack, the CLI…) and keeps its memory in plain Markdown files you can read
and edit.

> **Status of 2.0.0:** the scripts and installer are tested; the coaching
> flows have not yet been run end to end on a live Hermes install. Expect
> rough edges and please report transcripts.

## What a day looks like

```
07:00  Coach:  Morning. Coming up: client proposal — in 2d (Thu).
               Habits: H1 30-min run (day 4)
               What is the first 5-minute step on the proposal today?
       You:    outline the pricing section
       Coach:  What is most likely to derail it, and what will you do
               then? If ___, then I will ___.
       You:    if slack gets noisy then i will mute it until 11
       Coach:  Locked. Mute until 11, then the outline.

09:00          (no reply to a check-in? on "firm", one lighter follow-up:)
       Coach:  Still time to pick one thing for today. What is it?
               "nothing" works too.

20:30  Coach:  Which did you finish? 1 pricing outline · H1 run
               Reply with numbers and habit IDs, e.g. `1 H1`, or `none`.
       You:    1 H1
       Coach:  Outline done, run done. Rate today 1–5 — your effort,
               not the outcome.
       You:    4
       Coach:  Good day. Tomorrow we go again.
```

You don't have to reply in that format. "did the outline, forgot the run,
maybe a 3.5 — oh and the demo moved to the 14th" sent as a voice note two
hours later is logged just the same.

## What it does

**Pushes, at the level you choose**

| Intensity | When a check-in goes unanswered |
|---|---|
| `gentle` | Nothing extra. The next check-in gets smaller. |
| `firm` (default) | One lighter follow-up, then it backs off. After three in a row it asks, once, what's going on. |
| `relentless` | Firm, then a voice note, then a phone call — inside your call hours, never at night. |

The longer you stay quiet, the *less* it sends. People who fall behind tend
to avoid looking at their progress, so each step makes the ask smaller
instead of louder. It never lists what you missed.

**Coaches, at the depth your model can handle**

| Depth | For | Behaviour |
|---|---|---|
| `core` | Small local models (about 14B and up) | Short scripted check-ins; numbered, deterministic steps. |
| `deep` | Large hosted models | Everything in core, plus: candid feedback with evidence, diagnosis when something stalls, pattern reading across your week, planning sit-downs and monthly reviews. |

**Keeps track**

- **Daily plan with an if-then** – the morning question is built from your
  nearest real deadline; you add one obstacle plan.
- **Habits that shrink instead of breaking** – miss twice and the habit
  drops to its 2-minute version until you've won three in a row. Prefer no
  numbers at all? `coach style minimum`.
- **Commitments in one place** – exams, deadlines and promises live in one
  table with dates. Past your cap, the coach asks what the new one replaces.
- **Weekly review in two questions** – an execution score (done ÷ planned),
  what improved, what to change. Key results are reviewed monthly.
- **A coaching contract** – dated rules about what works for you and what
  doesn't. Tell it "stop asking me X" and it writes that down and obeys it.
- **Rest and crunch modes** – a score-only week when you're ill or
  travelling; a narrowed focus when a deadline is close.

**Connects to the rest of your setup** (all optional, off by default)

| Integration | What it adds |
|---|---|
| Calendar | Deadlines become events with reminders; mornings know your schedule. |
| Voice notes | Spoken check-ins; answer by voice. |
| Phone calls | A real call when texts go unanswered. |
| Photo proof | Send a picture of the finished thing. |
| Accountability partner | A weekly scorecard to someone you choose. |
| Stakes | A pledge you set and carry out if you miss your target. |
| Others | Notes apps, fitness data, GitHub activity, lights, music, webhooks. |

The coach suggests at most one of these per fortnight, when your own usage
shows a need for it, and stops for good if you say `never`. At setup you
choose whether it performs setup steps itself (asking before each one) or
writes them out for you to run — useful when the agent is sandboxed and
cannot reach its own configuration. Nothing counts as "on" until a real
test passes.

## Requirements

- Hermes Agent **0.21.0 or later**, with the cron tool (`cronjob_manage`
  with `attach_to_session`), the terminal tool, and file read/write.
- A model that follows multi-step tool instructions:
  - `core` depth: a 14B-class instruct model is the recommended floor;
    smaller models are best-effort — use the slash commands.
  - `deep` depth: a large hosted model.
- Bash 3.2+ and coreutils (macOS and Linux).

## Install

```bash
git clone https://github.com/fawazabdullah25/hermes-personal-coach.git
```

```bash
cd hermes-personal-coach && ./install.sh
```

```bash
hermes gateway restart
```

`install.sh` copies the skill to `~/.hermes/skills/personal-coach/`, creates
the data directory at `~/.hermes/personal-coach/`, and records that
directory's absolute path for the skill. It never touches `SOUL.md`,
`config.yaml`, `MEMORY.md`, credentials or other skills.

Developers can symlink instead of copying with `./install.sh --link`.

Verify: send `/commands` in your chat and look for `/personal-coach`.

### Docker and sandboxes

If your agent's terminal runs in Docker or another sandbox, `~` inside it
can be a throwaway copy, and anything the coach writes there is lost. Mount
the data directory into the sandbox **at the same absolute path** it has on
the host (for the Docker backend, a `docker_volumes` entry in Hermes
`config.yaml`), then run `install.sh` on the host. Setup checks that a
write survives and stops with a clear message if it doesn't.

## Quickstart

> **Run setup from the chat where you want the check-ins.** Cron jobs post
> back to the chat that created them.

1. Send `/personal-coach setup` (plain `coach setup` works on most models).
2. Answer one question at a time — about five minutes:
   clock and week start → how often and when → voice and intensity → one
   goal for the next 4–12 weeks with a key result → up to three habits →
   any fixed dates this month → coaching depth and who performs setup steps.
3. The coach registers its cron jobs, checks the scheduler's clock, and
   tells you when the first check-in arrives.
4. Try it now: `/personal-coach test morning` (dry run, nothing saved).

Longer-term vision, more objectives and a full roadmap come later, with
`coach plan`, once the daily rhythm is working.

## Commands

Use `/personal-coach <command>` (reliable on every model) or `coach <command>`.

| Command | What it does |
|---|---|
| `setup` | Runs or resumes onboarding. After an upgrade it asks only the new questions. |
| `status` | Settings, cron health, today's plan, commitments due this week, key results, habits. |
| `test morning` \| `pulse` \| `evening` \| `weekly` \| `daily` \| `nudge` | Dry-runs that check-in. Writes nothing. |
| `intensity gentle` \| `firm` \| `relentless` | How hard it follows up. |
| `depth core` \| `deep` | Scripted check-ins, or full coaching. |
| `style streaks` \| `minimum` | Show running streaks, or one small daily minimum with no numbers. |
| `mode rest [days]` \| `crunch [days] <target>` \| `normal` | Lighter weeks and deadline weeks. |
| `commit add <what> <date>` \| `done C3` \| `drop C3` \| `defer C3 <date>` \| `list` | Dated commitments. |
| `cap <n>` | How many open commitments before the coach asks what a new one replaces. |
| `remind <when> <what>` | A one-off reminder (calendar event if connected, else a one-shot job). |
| `contract` | Show or change the rules you've given the coach. |
| `integrations [name]` | Connect calendar, voice, calls and more; `integrations offers off` stops suggestions. |
| `partner` / `stake` | Accountability partner; a pledge on your weekly target. |
| `review` / `plan` | Monthly or end-of-sprint review; a planning sit-down (deep depth). |
| `timezone` | Re-reads the clock and rewrites schedules. Use after travel or DST. |
| `pause` / `resume` | Stops and restarts all coach jobs. |
| `teardown` | Removes all coach cron jobs. Data stays. |
| `edit …` | "move my evening check-in to 21:00", "add habit: stretch daily, after coffee, micro: 1 stretch". Confirms before writing. |
| `help` | Lists commands. |

## Cadence

| Tier | Check-ins |
|---|---|
| balanced (recommended) | morning plan · evening review · weekly review |
| minimalist | one check-in a day (`plan`, `review` or `combined`) · weekly review |
| intensive | morning · midday · evening · weekly — best for a short push; most people drop three a day within a week |

## Voices

| Voice | Style |
|---|---|
| Stoic Strategist | Calm, precise, focused on what you control. |
| Drill Sergeant | Short, urgent, zero excuses — and zero insults. |
| Empathetic Mentor | Warm, reflective, names feelings. |
| Custom | You describe tone, humour and toughness. |

Voice changes wording only. How often the coach follows up comes from
intensity, so a Drill Sergeant on `gentle` still leaves you alone.

## How it works

### Two directories

| Path | Contents | Owner |
|---|---|---|
| `~/.hermes/skills/personal-coach/` | Code: `SKILL.md`, `references/`, `templates/`, `scripts/` | Replaced on upgrade. |
| `~/.hermes/personal-coach/` | Your data | Yours. Survives upgrade and uninstall. |

### Data files (all Markdown, all editable by hand)

- `COACH_CONFIG.md` — schedule, voice, intensity, depth, integrations, cron IDs.
- `GOALS.md` — vision and milestones, objectives and key results, habits,
  constraints and your "why", archive.
- `HABITS.md` — the habit ledger: streak, scope (`full`/`micro`), last done.
- `COMMITMENTS.md` — one table of dated commitments.
- `CONTRACT.md` — how you want to be coached; newest dated line wins.
- `STATE.md` — the open question, when you last wrote, the current mode.
- `logs/YYYY-MM-DD.md` — the day: plan, if-then, habits, completions, score,
  notes captured from chat.
- `logs/weekly/YYYY-Www.md` — weekly rollups, kept forever.
- `logs/archive/` — daily logs older than 56 days.
- `briefs/` — setup instructions the coach wrote for you.
- `docs/` — review notes, plans, research.
- `bin/coach.sh` — the helper script (replaced on upgrade).

### Routing

`SKILL.md` is a small router. Each turn loads exactly one reference file —
onboarding, a routine, a command handler or the reply handler — so small
models see only the algorithm they need. Deep-mode files load only when
`Depth: deep`.

Date arithmetic, silence detection and weekly statistics are done by
`bin/coach.sh`, not by the model.

### Cron

Each check-in is a native Hermes cron job named `coach-morning`,
`coach-midday`, `coach-evening`, `coach-daily` or `coach-weekly`. On `firm`
and `relentless` there are also `coach-nudge-am` and `coach-nudge-pm`, which
fire once after a check-in and stay silent unless it went unanswered. Every
routine is idempotent: fired late or twice, it replies `[SILENT]`, which
Hermes does not deliver.

## Safety

The coach is not a therapist or a doctor. If you say something that sounds
like a crisis, it stops coaching, points you to emergency and crisis
services, and switches to rest mode. Set a local number with the
`Crisis Line` line in `COACH_CONFIG.md`.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `/personal-coach` not in `/commands` | `hermes gateway restart`; check `~/.hermes/skills/personal-coach/SKILL.md` exists. |
| Answers aren't remembered; setup restarts | Sandbox write problem — see "Docker and sandboxes". |
| Check-ins arrive in the wrong chat | Open the right chat: `/personal-coach teardown`, then `/personal-coach setup` → `redo`. |
| Check-ins arrive at the wrong hour | `/personal-coach timezone`. |
| `status` shows a job MISSING or failing | `/personal-coach timezone` re-creates missing jobs; `hermes cron list` shows the scheduler's view. A failing job usually means the model provider errored. |
| No follow-ups arrive | Intensity is `gentle`, or you answered, or you'd already been quiet for a while (it backs off). `/personal-coach test nudge` explains. |
| Calls or calendar work in chat but not in check-ins | Scheduled runs have a restricted tool list. Run `coach integrations <name>` again; it adds the toolset to the jobs. |
| Too many messages | `coach intensity gentle`, a lighter cadence via `coach edit`, or `coach mode rest 7`. |
| Coach sent a file instead of text | A bare file path in its reply — please open an issue with the message. |
| Setup got interrupted | `/personal-coach setup` resumes at the saved step. |
| I edited `GOALS.md` by hand | Fine. If you changed habits, send `coach edit rebuild habits`. |

## Privacy

Everything is plain text under `~/.hermes/personal-coach/` with `0700`
permissions. The skill makes no network calls of its own; integrations you
switch on use the tools you connect. Secrets are never written to the data
directory. Delete the directory and it's gone.

## Upgrade

```bash
cd hermes-personal-coach && git pull && ./install.sh && hermes gateway restart
```

Code is replaced (the previous install is kept as
`personal-coach.bak.<timestamp>`); data is untouched; missing settings are
added with their defaults.

**From 1.x:** then send `/personal-coach setup` once. It keeps your goals,
habits and logs, asks three new questions, and re-registers the cron jobs.
1.x behaviour is closest to `intensity gentle` + `depth core` + `style
streaks`. See `CHANGELOG.md`.

## Uninstall

```bash
./uninstall.sh
```

Removes the cron jobs, then the code, and asks about your data
(`--keep-data`, `--purge-data`, `-y`). If a job cannot be removed, run
`/personal-coach teardown` first, or pass `--force`.

## Renaming the command to `/coach`

Set `SKILL_NAME="coach"` in `install.sh` and `uninstall.sh` and `name: coach`
in `skill/SKILL.md`, reinstall, and restart the gateway. Data then lives at
`~/.hermes/coach/`.

## Why it works this way

`docs/RESEARCH.md` lists the research, coaching practice and field
experience behind each behaviour, and how strong the evidence is.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Transcripts from real installs —
especially small local models — are the most useful contribution right now.

## License

MIT — see [LICENSE](LICENSE).
