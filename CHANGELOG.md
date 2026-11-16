# Changelog

## 2.0.0

A redesign based on published research, coaching practice and ten weeks of
daily use. See `docs/RESEARCH.md`. Existing data is kept; run
`/personal-coach setup` once after upgrading.

**Follow-through**
- Intensity levels: `gentle`, `firm` (default) and `relentless`. Firm sends
  one lighter follow-up to an unanswered check-in; relentless adds a voice
  note and then a phone call, inside call hours. Repeated silence makes the
  coach back off, not pile on.
- Any message counts as a reply. Ratings, finished items and new deadlines
  are logged from free chat and late voice notes.
- Check-in questions are built from the nearest real deadline.
- `[SILENT]` replies: a scheduled run with nothing to say sends nothing.

**Coaching**
- Two depths: `core` (deterministic, for small local models) and `deep`
  (candid feedback, stall diagnosis, pattern reading, planning sessions and
  reviews, for large models).
- `CONTRACT.md`: dated rules for how you want to be coached.
- `COMMITMENTS.md`: one table of dated commitments, with a cap.
- Rest and crunch modes; a `minimum` tracking style with no streak numbers.
- The weekly review is two questions and reports an execution score; key
  results are reviewed monthly.
- A distress protocol.

**Reach**
- `coach integrations`: calendar, voice notes, phone calls, photo proof and
  more, offered one at a time and only switched on after a passing test.
  You choose whether the agent performs setup steps or writes them for you.
- Opt-in accountability partner and stakes.

**Robustness**
- `bin/coach.sh` does date arithmetic, silence detection and weekly
  statistics.
- The installer records the absolute data path and migrates 1.x configs.
- Setup takes about five minutes, down from ten.

**Changed from 1.0.0**
- "Never nag" is now "never guilt": one follow-up is allowed on `firm`.
  Choose `gentle` for the 1.0.0 behaviour.
- One-off reminders are allowed when you ask for them.
- No-op scheduled runs reply `[SILENT]` instead of a bracketed note.
- Ratings accept decimals.
- Not yet tested end to end on a live Hermes install.

## 1.0.0
- Initial release: GROW onboarding, intensive/balanced/minimalist cadences,
  four voices, WOOP daily commitments, habit ledger with Two-Day Rule and
  2-minute scope reduction, anti-ghosting evening safety check, weekly
  retrospective with OKR renegotiation and log archiving.
- Native Hermes cron jobs with `attach_to_session`; `STATE.md` pending-reply
  fallback.
- Separate code (`~/.hermes/skills/personal-coach/`) and data
  (`~/.hermes/personal-coach/`) directories.
