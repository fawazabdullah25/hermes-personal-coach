# Routine: Minimalist Daily Review

READ: COACH_CONFIG.md → Minimalist Mode.
1. If `Status: paused` → `(coach paused)`. STOP.
2. `plan`     → execute routine-morning.md.
3. `review`   → execute routine-evening.md.
4. `combined` → if YLOG exists and its `Evening Score:` is `pending`:
   set LOG_TARGET = YLOG and execute routine-evening.md steps 3–8 against YLOG
   (the pending handler will then continue into the morning routine, see
   pending.md §evening_score note). Else execute routine-morning.md.
