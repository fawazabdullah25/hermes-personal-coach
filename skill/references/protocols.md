# Protocols

## Due-Today(habit, DOW)
1. Frequency `Daily` → yes.
2. `Weekdays` → yes if DOW ∈ Mon..Fri. `Weekends` → yes if Sat/Sun.
3. Day list (e.g. `Mon/Wed/Fri`) → yes if DOW appears in the list.
4. Otherwise no.

## Ledger-Update(one LOG habit line)  — returns MESSAGES
1. Find the block `### H<n>` in HABITS.md. T = Scale-Up Threshold (config).
2. If line is `[x]`: Streak += 1; Consecutive Misses = 0; Last Done = TODAY;
   if Scope: micro → Micro Completions += 1; if Micro Completions ≥ T →
   Scope: full; Micro Completions: 0; add MESSAGE
   "H<n> is back to full scope — <T> micro wins in a row."
3. If line is `[ ]`: Streak = 0; Consecutive Misses += 1.
   - Misses == 1 → add nothing (Two-Day Rule: first miss is acknowledged
     neutrally, never with guilt). 
   - Misses ≥ 2 AND Scope: full → Scope: micro; Micro Completions: 0; add
     MESSAGE "H<n> slipped two days running. From tomorrow it's only:
     <Micro-step>. That is the whole task."
4. Last Evaluated = TODAY. WRITE the changed lines (one line at a time).

## Two-Minute-Rule(commitment text) — returns MICRO
1. If the text matches a habit action in HABITS.md → MICRO = that Micro-step.
2. Else build MICRO by shrinking the verb: read/study → "read 1 page";
   write/code → "write 3 lines"; exercise/run/gym → "put on shoes and step
   outside"; call/email/message → "write the first sentence"; clean/tidy →
   "clear one surface"; other → "do 2 minutes of <text> and stop".

## Scale-Up by user request
"back to full H<n>" → Scope: full; Micro Completions: 0. Confirm in one line.

## Rebuild (HABITS.md from GOALS.md §3)
1. Copy templates/HABITS.md header. For each §3 line `H<n>: A | Frequency: F
   | Trigger: T | Micro: M` create a block with Scope full, counters 0,
   Last Done never. WRITE HABITS.md.
