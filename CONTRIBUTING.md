# Contributing to hermes-personal-coach

Thanks for helping. This project's hard constraint is that it must work on
small local models, so most rules below exist to protect that.

## Ground rules

1. **Budgets.** `skill/SKILL.md` ≤ 900 tokens. Each file in
   `skill/references/` ≤ 1,300 tokens and ≤ 12 numbered steps per algorithm.
   `tests/lint.sh` checks word counts as a proxy (≈ 650 and 950 words).
2. **Deterministic algorithms.** Instructions are numbered, imperative steps
   with explicit `If … → … Else → …`. No "consider", "you may", "use judgement".
3. **One question per message.** Every routine and handler asks at most one
   thing, writes its state, then stops.
4. **Write before reply.** Any step that changes state says `WRITE <file>`
   before the message is composed. State is always re-derived from files,
   never from conversation memory.
5. **Files.** The agent writes only under `~/.hermes/personal-coach/`. New
   files need a template in `skill/templates/` and a schema note in the README.
6. **Cron.** Jobs are created, updated, paused, resumed, and removed only in
   `references/cron-engine.md`. Never add one-off reminder jobs anywhere.
7. **Paths in user-facing text must be in backticks.** Hermes sends a bare
   path of an existing file as an attachment. This includes the frontmatter
   `description`.
8. **Frontmatter `description`** stays two sentences: one for humans (it is
   shown in `/commands`), one with trigger keywords for the model. No paths.
9. **Non-destructive.** Nothing may read or write `~/.hermes/SOUL.md`,
   `config.yaml`, `MEMORY.md`, `USER.md`, or other skills.

Run `tests/lint.sh` before opening a PR.

## Setting up for development

```bash
git clone https://github.com/fawazabdullah25/hermes-personal-coach.git
cd hermes-personal-coach
./install.sh --link       # symlink skill/ so edits are live
hermes gateway restart
```

Data lives outside the repo, so you can safely run real setups.

## Testing a change

There is no unit-test framework for prompts; we use transcripts.

1. **Dry runs:** `/personal-coach test <morning|pulse|evening|weekly|daily>`
   executes a routine without writing files.
2. **Real fires without waiting:** `hermes cron list`, then
   `hermes cron run <job_id>` (fires on the next scheduler tick) or, from chat,
   ask the agent to `cronjob_manage run` the job. Delivery and reply
   continuation are only testable this way.
3. **Model matrix:** test on at least two of — an 8B model, a 14B model
   (reference floor), a 32B+ or hosted model. State which ones in the PR.
4. **Transcripts:** paste the before/after chat transcript for the affected
   routine into the PR, with model name and quantisation. Redact personal
   goals.

## Areas we want help with

### 1. Prompt optimisation for small local models
- Shorter phrasing that keeps the algorithm unambiguous.
- Reordering steps so the most failure-prone WRITE happens earliest.
- Better keyword extraction rules in `references/pending.md`.
- Evidence beats opinion: include transcripts showing the failure you fixed.

### 2. Shell scripts
- Targets bash ≥ 3.2 (macOS default) and Linux; coreutils only.
- Must pass `shellcheck` with no warnings.
- Test both `./install.sh` and `./install.sh --link`, and `uninstall.sh` with
  and without registered cron jobs (`hermes cron list` to check).

### 3. New coaching voices (archetypes)
Add one block to `references/archetypes.md`:
- Name, one line of style, and a phrase bank with exactly the keys
  `morning`, `win`, `miss`.
- ≤ 120 words total. Must obey the Common rules (no sarcasm about failures,
  never moralise a miss, ≤ 2 sentences of personality per message).
- Add the option to `references/onboarding.md` Step 3 and the README table.

### 4. Integrations (calendar, health data, task managers, …)
Generic pattern, so integrations stay optional and small-model-safe:
- One reference file per integration, e.g. `references/integration-calendar.md`.
- Enabled by a config line `Integration: calendar = on` (default `off`) added
  to `COACH_CONFIG.md` by the integration's own setup step, never by the main
  onboarding.
- Invoked from exactly one routine step guarded by that flag.
- Must be a no-op when the flag is off or the tool/skill it needs is absent.
- Must not add more than one question to any routine.

### 5. Schema changes
- Bump `VERSION` and the `Version` line in `templates/COACH_CONFIG.md`.
- Add a migration in `install.sh` (idempotent, guarded by the old version)
  and a note in `CHANGELOG.md`.
- Update `tests/lint.sh` if a new key is required.

## Pull request checklist

- [ ] `tests/lint.sh` passes
- [ ] Budgets respected (SKILL.md ≤ 900 tokens, references ≤ 1,300)
- [ ] One question per message preserved
- [ ] No bare paths in user-facing text
- [ ] Tested on at least two model sizes; transcripts attached
- [ ] README and CHANGELOG updated if behaviour or schema changed

## Code of conduct

Be kind and specific. Critique prompts and code, not people.
