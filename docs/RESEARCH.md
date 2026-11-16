# Why the coach behaves the way it does

Every behaviour in v2 traces back to one of three sources: published
research, what working coaches do, or field experience from months of daily
use. This page says which is which, and how strong the support is. Where
the evidence is thin, the feature is opt-in.

## Research

| Finding | Strength | What the coach does with it |
|---|---|---|
| Prompting people to monitor progress improves goal attainment (138 trials, d ≈ 0.40); the effect is larger when progress is physically recorded and reported to someone else. [Harkin et al., 2016](https://eprints.whiterose.ac.uk/id/eprint/91437/) | Strong | Daily logs written by the coach; weekly numbers; the opt-in accountability partner. |
| People who are behind avoid information about their progress ("the ostrich problem"), most often because looking feels bad or would demand action. [Webb, Chang & Benn, 2013](https://eprints.whiterose.ac.uk/76946/); [Chang et al., 2017](https://pmc.ncbi.nlm.nih.gov/articles/PMC5297323) | Good | Silence is treated as avoidance, not laziness: each escalation step makes the ask smaller; nothing ever lists what was missed. |
| A broken streak makes people less likely to continue, and highlighting the break makes it worse. [Silverman & Barasch, J. Consumer Research](https://knowledge.insead.edu/marketing/consumer-streaks-are-motivating-key-keeping-them-alive) | Good | Streaks are shown only while alive; a reset streak is never mentioned; `style minimum` removes the numbers entirely. |
| Task aversiveness is among the strongest predictors of procrastination. [Steel, 2007](https://prism.ucalgary.ca/handle/1880/47914) | Strong | Every task handed out is one concrete step of five minutes or less; stalls are diagnosed by asking what makes the task unpleasant. |
| The quality of the coach–client working alliance predicts coaching outcomes (27 samples, r = .41). [Graßmann et al., 2020](https://fis.leuphana.de/en/publications/the-relationship-between-working-alliance-and-client-outcomes-in-/) | Good | `CONTRACT.md`: an explicit, dated agreement on how this person wants to be coached, read on every run. |
| Workplace coaching improves learning, performance and wellbeing. [Jones et al., 2016](https://centaur.reading.ac.uk/74522/) | Good | The general case for coaching at all. |
| If-then plans and mental contrasting (WOOP) help people act on intentions. | Strong (Gollwitzer & Sheeran; Oettingen — not re-verified for this release) | The morning "If ___, then I will ___" step, kept from v1. |
| Autonomy-supportive, question-led conversation (motivational interviewing, self-determination theory) builds the person's own reasons for change. [MI and self-determination theory commentary, IJBNPA 2012](https://link.springer.com/content/pdf/10.1186/1479-5868-9-19.pdf) | Good in health settings; less tested in coaching | Deep mode asks before telling, uses scaling questions, never argues for change. |
| Too many or badly timed prompts reduce engagement with behaviour-change tools. [mHealth app-fatigue review](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12637926/) | Suggestive — no trial isolates "fewer is better" | One follow-up at most; balanced cadence recommended over three check-ins a day; back-off after repeated silence. |
| Commitment contracts with a penalty help some people; reviews are mixed. [Commitment-device research summary](https://policyandpoliticsblog.com/2021/01/27/why-nudges-fail-and-other-puzzles-insights-from-research-on-commitment-devices/) | Mixed | `coach stake` is opt-in, never suggested unprompted, and refuses harmful forfeits. |
| "Identity-based habits" | Thin — popular, little controlled evidence. [Review: "Habit and Identity"](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6635880/) | Not used as a mechanism. |

One finding was deliberately left out: the well-known study on self-imposed
deadlines (Ariely & Wertenbroch, 2002) has a failed replication and a
retraction request against it, so nothing here depends on it.

## What working coaches do

| Practice | Source | In the skill |
|---|---|---|
| Listen fully, ask probing questions, give candid feedback immediately and in private. | Bill Campbell, as described in [*Trillion Dollar Coach*](https://www.shortform.com/summary/trillion-dollar-coach-summary-bill-campbell) | Deep mode §Stance: reflect first, say the hard thing once with evidence, hold the position. |
| Written commitments that are checked; accountability over elaborate planning. | [Matt Mochary](https://tim.blog/2023/03/01/matt-mochary/) | `COMMITMENTS.md` registry; evening check against the morning's list. |
| Daily "Did I do my best to…" questions that score effort, not results. | [Marshall Goldsmith](https://customerthink.com/did-i-do-my-best-to/) | The evening rating asks for effort, not outcome. |
| A weekly execution score — actions completed over actions planned — with 85% as a benchmark. | [The 12 Week Year](https://12weekyear.com/wp-content/uploads/2018/11/The_Weekly_Routine-Updates.pdf) | `EXECUTION_SCORE` in the weekly review. The benchmark is a convention, not a proven threshold. |
| Measure progress from the starting point, not against the ideal. | [Dan Sullivan, *The Gap and the Gain*](https://www.strategiccoach.com/resources/the-multiplier-mindset-blog/from-gap-to-gain-how-entrepreneurs-build-confidence) | The weekly question: "What is better than a week ago?" |
| Map the hidden commitment that competes with a stalled goal, then test the assumption behind it. | [Kegan & Lahey, *Immunity to Change*](https://mindsatwork.com/our-thinking/immunity-to-change) | Deep mode §Immunity map, for goals stalled three weeks or more. |
| Practice at the edge of ability with immediate feedback. | Anders Ericsson's deliberate-practice work | Deep mode §Skill goals. |

These are practitioner methods. Most are plausible and widely used; few
have been tested in controlled trials.

## Field experience

v1 ran daily for about ten weeks with one user and was adjusted as it went.
The lessons below were kept only where research or other people's reports
pointed the same way.

| Observed in use | Also seen elsewhere? | Change in v2 |
|---|---|---|
| Answers arrived hours late, in free chat or voice notes; the reply state machine missed them and the weekly review reported "0 logged". | Yes — other builders report users drifting into free-form updates. | `capture.md`: any message counts; facts are logged wherever they appear. |
| Specific, dated questions were answered; generic ones were skipped. | Consistent with the procrastination literature. | `protocols.md` §Focus-Question builds the question from the nearest deadline. |
| Habit boards and streak counts produced guilt, then silence. | Yes — the streak research above. | Tracking styles; no broken-streak messages. |
| Phone calls broke silences that texts did not; a call placed too early on a weekend went unanswered. | One person's experience. | Calls are opt-in, only on `relentless`, only inside call hours, with separate weekend hours. |
| Three check-ins a day was too many; the midday one was cut. | Yes — [another user abandoned three a day within a week](https://hitha.substack.com/p/swipe-file-create-an-ai-coach). | Balanced cadence is the recommended default. |
| A five-step weekly form never got past the first question. | Yes — "asks too many questions" is a common complaint. | The weekly review is two questions; key results are reviewed monthly. |
| Dates kept in prose across files led to wrong-day mistakes. | Yes — "loses track of what day it is" appears in other reports. | One commitments table; all date arithmetic done by a script. |
| The agent stored personal rules by patching the skill itself, which then could not be upgraded. | General to self-editing agents. | Personal rules live in `CONTRACT.md`; the skill tells the agent never to patch itself for preferences. |
| In a Docker terminal, `~` pointed at a throwaway copy and writes were lost. | Affects any sandboxed install. | The installer records the absolute data path; setup verifies that a write survives. |
| Terminal commands needing approval timed out unattended and dropped writes. | Affects any unattended run. | File tools only; the helper script replaces inline Python and `sed`. |

## Earlier attempts by others

| Project | Worth copying | Worth avoiding |
|---|---|---|
| [2026-coach](https://github.com/BayramAnnakov/2026-coach) | Outcome → milestones → weekly process goals → daily behaviours | Sixteen questions before any value; an inflated "15x" research claim; flattering filler |
| [OpenClaw accountability coach](https://github.com/hesamsheikh/awesome-openclaw-usecases/blob/main/usecases/habit-tracker-accountability-coach.md) | One follow-up after two hours, then no spam; 3–5 habits at most | No stated mechanism for scheduling or state |
| [Hitha Palepu's Claude coach](https://hitha.substack.com/p/swipe-file-create-an-ai-coach) | A standing no-judgement rest agreement; a coach that flags overload | Three long check-ins a day |
| [Agent-skill authoring guides](https://agentskills.io/skill-creation/best-practices.md), [common pitfalls](https://smcleod.net/2026/07/writing-and-reviewing-agent-skills-common-pitfalls/) | Trigger-only descriptions; references loaded on demand; scripts for deterministic work; a gotchas section | Making the model do arithmetic a script should do |

## What has not been tested

v2.0.0 has passed static checks and script tests only. It has not yet been
run end to end on a live Hermes install or across model sizes. See
`CONTRIBUTING.md` for how to report transcripts.
