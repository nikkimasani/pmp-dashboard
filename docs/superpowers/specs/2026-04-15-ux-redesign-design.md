# PMP Boot Camp — UX/UI Redesign Design Spec
**Date:** 2026-04-15  
**Status:** Approved  
**Scope:** Full athletic-training overhaul with achievements system (Approach 3)

---

## Overview

Transform the PMP dashboard from a functional study tool into a motivating, game-like training environment. The redesign keeps all existing content and functionality intact while layering on athletic-training personality, a daily training system, celebration moments, and a full achievement/badge system.

**North star:** Open the app and immediately want to study.

---

## 1. Design Language

### Colors
Keep the existing dark base and purple/teal identity. Layer in semantic colors for new states:

| Color | Hex | Usage |
|-------|-----|-------|
| Purple (primary) | `#7c6bfa` | Navigation, XP bar, primary actions |
| Teal (accent) | `#00e5b8` | Progress gradients, secondary highlights |
| Green | `#2ed573` | Wins, completions, earned badges, positive delta |
| Orange | `#ffa502` | Streaks, momentum, in-reach badges |
| Blue | `#3d9eff` | Days remaining, info states |
| Purple-light | `#a55eea` | Levels, XP, Study zone label |
| Red | `#ff4757` | Alerts, weak areas, urgent states |

### Typography & Base
- Font: `'Outfit'` (unchanged)
- Background: `#07090f` (unchanged)
- No layout restructuring beyond sidebar and Start Here page

### App Name
**PMP Boot Camp** — rename from "PMP Base Camp" everywhere: sidebar logo, page `<title>`, browser tab, any heading references.

---

## 2. Start Here Page — Daily Training Hub

Complete replacement of the existing Start Here content. Structure (top to bottom):

### 2a. Greeting Bar
```
Good morning, Nikki 👊          [streak card: 14🔥 / Day Streak]
WEDNESDAY · DAY 23 OF 47
```
- Day count derived from days elapsed since exam date was first set (stored in `localStorage`)
- Streak card: orange border, prominent flame

### 2b. Stats Row (4 cards)
| Card | Value | Color | Extra |
|------|-------|-------|-------|
| Course Done | % of study plan sections marked complete | Purple | Mini progress bar |
| Quiz Avg | Rolling average across all quiz attempts | Green | "+N pts this week" delta vs 7 days ago |
| Days Left | Countdown to exam date | Blue | "On pace ✓" or "Behind ⚠️" |
| Badges Earned | Count of unlocked badges | Purple-light | "N in reach 🏅" |

### 2c. Coach's Briefing
Gold/orange bordered card with 💬 icon. Dynamic message assembled from 3 data points — see Section 6.

### 2d. Today's Training
3 task cards, one per task type. Each card has:
- Color-coded left border and icon (green/watch, purple/quiz, blue/flashcards)
- Task title + subtitle (module name, domain, estimated time)
- `START →` button that navigates directly to the relevant tab
- Checkbox state: incomplete → in-progress → complete (green checkmark)
- "Change Task" link (small, secondary) to swap to a different task
- Progress indicator: "0 of 3 complete" → updates as tasks are checked off

Tasks regenerate once per calendar day (keyed by date in localStorage). Completing all 3 awards +25 bonus XP.

### 2e. Exam Readiness Bar
Full-width bar at the bottom: label, percentage, purple→green gradient fill, plain-English status line ("2 domains need attention before exam day").

---

## 3. Sidebar Redesign

### Logo Area
```
[PMP] Boot Camp
Overall Progress  72%
████████████████░░░░  (purple→teal gradient)
```
Progress bar fills based on study plan completion percentage.

### Countdown (unchanged position, unchanged behavior)
Large number, "Days to Exam", "Set Target Date" button.

### Navigation — Training Zones
Replace flat nav list with 3 labeled zones. Zone labels are colored and non-clickable.

**🏋️ Train** (green label)
- 🚀 Start Here
- 🎬 Video Library → live indicator: `X/20` modules watched (green)
- 🧠 Practice Quiz → live indicator: quiz average % (orange if <70, green if ≥70)
- 🃏 Flashcards → `NEW` pill if never opened

**📊 Progress** (blue label) — rename nav id `progress` → `stats`
- 📊 My Stats → live indicator: badge count `N 🏅`
- 🎯 Weak Areas → live indicator: `N ⚠️` in red if any exist

**📚 Study** (purple label)
- 📚 Study Plan → live indicator: `X/20` sections done (green)
- 🎓 Lessons
- 🧮 Reference
- 📝 My Notes
- 📋 Application
- 🤝 Study Group
- 📁 Your Files
- 📖 Study Center

### Bottom
Streak counter (unchanged). Mountain progress SVG (unchanged, keep existing animation).

---

## 4. Celebration System

### Tier 1 — Quick Win Toast
**Triggers:** Complete a today's task, finish a flashcard session, check off a study plan step.  
**Design:** Bottom-right corner, slides in. Title + subtitle + `+1` circle badge. Auto-dismisses after 3 seconds. Never blocks content.

### Tier 2 — Personal Record Banner
**Triggers:** Any quiz result that beats the stored best score for that domain/topic.  
**Design:** Appears above quiz results. Gold bordered card with 🏆, new score, previous best, point delta in green. Persists until user scrolls or navigates.  
**Storage:** `localStorage` key `pmp_best_scores` — object keyed by quiz domain/id, value = best % score.

### Tier 3 — Big Moment Modal
**Triggers:**
- Study plan section marked complete
- Streak hits 7, 14, or 30 days
- Badge unlocked

**Design:** Dark overlay, centered card, confetti particle burst (JS canvas, ~2s). Shows achievement name + description. "Keep Going →" button dismisses. Clicking overlay also dismisses.  
**Confetti:** ~60 particles, colors from palette (`#7c6bfa`, `#00e5b8`, `#2ed573`, `#ffa502`, `#ff4757`), gravity + fade animation, canvas overlaid at z-index 9999.

---

## 5. Badge & Achievement System

All data stored in `localStorage` key `pmp_achievements`: `{ xp: number, level: number, badges: string[], bestScores: object }`.

### XP Earnings
| Action | XP |
|--------|-----|
| Complete a today's task | +25 |
| Complete all 3 today's tasks (bonus) | +25 |
| Pass a quiz (≥70%) | +50 |
| Section marked complete in study plan | +100 |
| Video module watched (Task 1 marked complete) | +75 |
| Daily streak maintained | +25 |
| Badge unlocked | +150 |

### Level Thresholds & Titles
| Level | XP Required | Title |
|-------|------------|-------|
| 1 | 0 | Recruit |
| 2 | 500 | Trainee |
| 3 | 1,000 | Associate |
| 4 | 1,750 | Practitioner |
| 5 | 2,750 | Senior Practitioner |
| 6 | 4,000 | Project Lead |
| 7 | 5,500 | Project Manager |
| 8 | 7,500 | Senior PM |
| 9 | 10,000 | PMP Candidate |
| 10 | 13,000 | PMP Champion |

### Domain Mastery Badges
Earned by completing all lessons + passing the section quiz for each domain.

| Badge | Icon | Trigger |
|-------|------|---------|
| Scope Master | 🏗️ | Scope Management complete |
| Schedule Pro | ⏱️ | Schedule Management complete |
| Cost Controller | 💰 | Cost & EVM complete |
| Quality Guard | ✅ | Quality Management complete |
| Risk Manager | ⚠️ | Risk Management complete |
| Procurement Pro | 📦 | Procurement complete |
| People Leader | 🤝 | Resource Management complete |
| Comms Expert | 📡 | Communications complete |
| Agile Champion | 🔄 | Agile/Hybrid complete |
| Integration Ace | 🔗 | Integration Management complete |

### Streak & Hustle Badges
| Badge | Icon | Trigger |
|-------|------|---------|
| Week Warrior | 🔥 | 7-day streak |
| Two-Week Push | 💪 | 14-day streak |
| Iron Will | 🏆 | 30-day streak |

### Performance Badges
| Badge | Icon | Trigger |
|-------|------|---------|
| Sharp Shooter | 🎯 | Score 80%+ on any quiz |
| Exam Ready | 🧠 | Score 80%+ on full mock exam |
| Perfect Score | ⭐ | Score 100% on any section quiz |

### Badge Display States
- **Earned** — green border glow, full color icon, "EARNED" label
- **In Reach** — orange border, full color icon, "IN REACH" label, mini progress bar showing completion %
- **Locked** — muted border, grayscale icon, "LOCKED" label

"In Reach" = trigger condition is >50% met (e.g., 3/5 lessons done for a domain badge).

### Achievement Gallery Location
Lives on the **My Stats** tab (currently "Progress" tab — rename to "My Stats"). Three sections: Domain Mastery, Streak & Hustle, Performance.

---

## 6. Today's Training Generator

Runs once per calendar day on Start Here page load. Result cached in `localStorage` as `pmp_daily_training_YYYY-MM-DD`.

### Task 1 — Watch
1. Find the current study plan section (first incomplete section in order)
2. Return the next unwatched video module for that section
3. Fallback: if all modules watched, return the module for the section with the lowest quiz score

### Task 2 — Drill
1. Read weak areas (domains with quiz avg below 70%)
2. Pick the domain with the lowest average
3. Generate 20-question quiz weighted 60% toward that domain, 40% general
4. Fallback: if no weak areas, pick domain of Task 1's section

### Task 3 — Review
1. Read quiz history for incorrectly answered questions
2. Pull 10 flashcards matching the most-missed topics (last 7 days)
3. Fallback: if no history, pull flashcards from Task 1's section topic

### Daily Reset
- Date checked on page load; new tasks generated if date has changed
- Completing all 3 tasks awards +25 bonus XP and shows Tier 1 toast
- "Change Task" button available per task — replaces that slot with the next best option

---

## 7. Coach's Briefing Generator

Runs on Start Here page load. Selects a message template based on 3 computed signals.

### Input Signals
1. **Focus area** — domain with the lowest quiz average (or "overall" if all ≥75%)
2. **Momentum** — quiz average delta vs. 7 days ago: positive / flat / negative
3. **Urgency** — days remaining: >45 (plenty) / 20–45 (moderate) / <20 (urgent) / ≤7 (exam week)

### Scenario Matrix
| Momentum | Urgency | Tone |
|----------|---------|------|
| Positive | Any | Encouraging + reinforcing ("the studying is working") |
| Flat | Plenty | Steady + focused ("keep the consistency") |
| Flat/Negative | Moderate | Direct + motivating ("this is the time to push") |
| Any | Urgent | No-nonsense + confident ("you can do this, here's the plan") |
| Any | Exam week | Calm + reassuring ("trust your preparation") |
| Streak broken | Any | Welcome-back + re-engaging |

~10 message templates per scenario. Selected randomly (seeded by date so it doesn't change on page refresh).  
All templates stored as JS template literal strings with `${focusDomain}`, `${daysLeft}`, `${delta}` interpolation slots.

---

## Implementation Notes

- Single file `index.html` — all changes stay in that file
- No new dependencies — confetti is hand-rolled JS canvas (~50 lines)
- All new state keys use `pmp_` prefix to avoid collisions with existing localStorage keys
- Existing quiz, flashcard, study plan, and progress logic unchanged — only display layer and new reward hooks added
- Target: mobile-friendly (existing layout is already responsive)

---

## Out of Scope
- OneDrive OAuth integration (separate track)
- Backend or sync across devices
- Any changes to quiz question content, study plan structure, or lesson content
