# Contributing to hermes-personal-coach

Thanks for helping. This project's hard constraint is that it must work on
small local models, so most rules below exist to protect that.

## Ground rules

1. **Two layers.** Core files are read by small models on every run and
   must stay small and deterministic. Extended files (`deep-coaching.md`,
   `deep-sessions.md`, `integrations.md`) load rarely and may use judgement.
   Budgets, checked by `tests/lint.sh` as word counts: `SKILL.md` ≤ 900
   words; core references ≤ 950; extended references ≤ 1,500.
2. **Deterministic core.** Core instructions are numbered, imperative steps
   with explicit `If … → … Else → …`. No "consider" or "use judgement"
   outside the extended files.
3. **One question per check-in.** Every routine and reply handler asks at
   most one thing, writes its state, then stops. Conversations the user
   starts in deep mode may ask several numbered questions.
4. **Write before reply.** State is re-derived from files, never from
   conversation memory.
5. **Scripts do the arithmetic.** Dates, time windows and statistics belong
   in `skill/scripts/coach.sh`, not in prose the model must compute.
6. **No guilt.** No user-facing string may list misses, broken streaks or
   unanswered check-ins. Escalation makes the ask smaller and changes the
   channel; it never adds volume. Lint checks the obvious phrasings.
7. **Files.** The agent writes only under the data directory. The one
   exception is integration setup, behind an explicit `yes` per step. New
   data files need a template and a README note.
8. **Cron.** Jobs are created, updated and removed only in
   `references/cron-engine.md`. Scheduled runs cannot create jobs, so
   follow-ups are fixed jobs that reply `[SILENT]` when not needed.
9. **Personal rules go in `CONTRACT.md`,** never in the skill. A change
   that only suits one person is a contract line, not a pull request.
10. **Paths in user-facing text must be in backticks,** including the
    frontmatter `description`. Hermes sends a bare path as an attachment.
11. **Evidence.** A behaviour change should cite research, a transcript, or
    both, and `docs/RESEARCH.md` should say how strong the support is.
12. **Opt-in for anything that reaches outward** — other people, money,
    phone calls, the user's accounts.

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

### 4. Integrations
- Add a row to the catalogue in `references/integrations.md`, a rule in
  §Offer only if a clear usage signal exists, and a test in §Verify.
- Add a config flag (default `off`) to `templates/COACH_CONFIG.md`.
- Use it from exactly one routine step guarded by that flag, and make that
  step a silent no-op when the flag is off or the tool errors.
- Name only skills, tools and commands you have verified in the Hermes docs
  or a live install.

### 5. Schema changes
- Bump `VERSION` and the `Version` line in `templates/COACH_CONFIG.md`.
- Add a migration in `install.sh` (idempotent, guarded by the old version)
  and a note in `CHANGELOG.md`.
- Update `tests/lint.sh` if a new key is required.

## Pull request checklist

- [ ] `tests/lint.sh` passes
- [ ] Budgets respected (see ground rule 1)
- [ ] One question per message preserved
- [ ] No bare paths in user-facing text
- [ ] Tested on at least two model sizes; transcripts attached
- [ ] README and CHANGELOG updated if behaviour or schema changed

## Code of conduct

Be kind and specific. Critique prompts and code, not people.
