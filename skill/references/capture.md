# Capture — any message counts

Run on every user message that is not a command. MSG = the message. It may be
long, late, a voice transcript, or about something else. Take the facts out,
write them where the routines look, and never make the user repeat them.
Skip all WRITEs in Test Mode.

1. REPLY MARK: if STATE `Pending` ≠ none, in `Pending Log` set the
   `Morning|Midday|Evening Reply:` line that is `pending` to `yes`.
2. RATING: MSG is only a number 1–5, or has a number 1–5 next to "rate",
   "rating", "score", "out of 5" or "/5":
   - MSG says "yesterday" → target YLOG, else LOG.
   - Target `Evening Score:` is `pending` or `unknown` → WRITE the number.
     Several days rated at once → write each day you can identify.
3. DONE: MSG says done / finished / did / completed / sent / submitted and
   names a commitment number, an `H<n>`, or words matching a line in LOG →
   mark that line `[x]`. Matches a row in COMMITMENTS.md → set its Status
   `done`. If LOG `Completion Rate` is already a fraction → recount it.
4. NEW DEADLINE: MSG names something with a date or day ("exam on the 12th",
   "due Friday", "meeting Tuesday 18:00") that is not in COMMITMENTS.md:
   - Work out the date from CLOCK. Unsure which date or which item → ask.
   - `Depth: deep` → `protocols.md` §Commit-Add now, and tell the user in one
     line: "Added: <what> — <due>."
   - `Depth: core` → ask: "Add `<what>` due `<YYYY-MM-DD>` to your
     commitments? `yes`/`no`". WRITE STATE Pending: commit_confirm, Pending
     Question: `<what> | <due>`. STOP.
5. DROPPED or MOVED: MSG says something is cancelled, dropped or postponed →
   if exactly one row fits, update its Status or Due and say so. If two
   could fit → ask which. Never move a date on a guess.
6. NOTE: anything else about progress or obstacles → append one line to LOG
   `## Notes`: `- <HH:MM> <≤ 20 words>`.
7. PREFERENCE: MSG tells you how to coach them ("stop asking X", "I prefer
   Y", "that question is useless") → append a dated line to the matching
   section of `CONTRACT.md`, and confirm in one line: "Noted in your
   contract: <rule>."
8. `Input Mode: voice` → words may be misheard. Read through obvious
   mishearings from context; when one changes the meaning (a name, date or
   number), confirm it in your reply. Add to `CONTRACT.md` "Known
   mishearings" only on the third time the same one appears. An aside is
   not a decision: do not turn passing remarks into commitments.
9. Do not announce what you logged beyond one short line, and only when you
   wrote something the user would want to verify (a date, a status change).
10. Return to the caller. Steps 2–7 never ask more than one question in
    total; if two things are unclear, ask the one about a date first.
