# Repo Integration Spec — PMOSkills, PMIS-PMBOK, pmp-study-platform

**Date:** 2026-07-09
**Target:** `index.html` (single-file PMP bootcamp app, ~9,250 lines, vanilla JS, dark theme, sidebar `nav()` panels, Supabase auth, localStorage + Supabase persistence)
**Phase:** analysis only — no app changes in this phase.
**Analyzed clones:** scratchpad `repo-analysis/` (session-temp; re-clone if needed).

The app already has: quiz bank (~406 questions) with practice modes, timed 2026-ECO-weighted mock exam (60 Q / 80 min), flashcards, lessons, study plan, EVM formula reference + searchable terms, video library, Ramdayal module tracker, files integration, study group, application tracker, countdown, XP/streaks.

---

## Licensing summary (read first)

| Repo | LICENSE file | GitHub API `license` | Verdict |
|---|---|---|---|
| fakhruldeen/PMOSkills | MIT (2026, Mohamed Fakhruldeen) | MIT | **Safe to port content and code** with attribution note |
| engruxman4-cloud/PMIS-PMBOK | none | `null` | **All rights reserved by default — do not copy code verbatim** |
| AerwinApollo01/pmp-study-platform | none | `null` | **All rights reserved by default — do not copy code or question text verbatim** |

For the two unlicensed repos, the safe path is **clean-room reimplementation**: the underlying ideas (CPM forward/backward pass, PERT math, EVM formulas, exam-navigator UX, engagement-matrix concept) are standard PM bodies of knowledge and not protectable; the specific code and authored question/flashcard text are. All work packages below for those repos specify *reimplement, don't copy*. Optional: open a GitHub issue asking AerwinApollo01 to add a license — if MIT is granted, the 319-question bank becomes directly importable (highest-value single asset found in this analysis).

Additional trademark note: all three repos (and our app) reference PMBOK®/PMI® material. Keep the app's existing practice of paraphrased study content; do not import verbatim PMBOK text.

---

## Repo 1 — fakhruldeen/PMOSkills

### (a) Summary

- **What it is:** a Markdown reference architecture / "executable skill system" for PMOSkills built on PMBOK 8th Edition + 24 PMI companion references. **Not an app** — no runnable UI, no JS. ~14 MB, 430+ Markdown files.
- **Stack / run model:** pure documentation (Markdown + YAML frontmatter). Also published to npm/PyPI as `pmoskills`.
- **Structure:** `reference/` (glossary, 6 PMBOK-8 principles, 7 performance domains, processes, tools-techniques, inputs-outputs, tailoring), `artifacts/` (38+ template/example pairs per artifact, e.g. A15 schedule baseline), `skills/` (48 step-by-step SOP files across 8 lifecycle folders), `docs/` (traceability matrix, crosswalks).
- **License:** MIT — freely portable.
- **Secrets/APIs:** none.
- **Caution:** clone emits case-collision warnings on Windows (two files differing only in case under `artifacts/stakeholders-communications/`); harmless for data extraction but don't bulk-copy that folder blindly.

### (b) Features worth porting (ranked for a 2026 PMP studier)

1. **PMBOK 8 structured reference data** (HIGH): 50-term glossary (`reference/GLOSSARY.md`, one `####` heading per term), 6 principles (`reference/principles/pmbok8/P8-01…P8-06.md`), 7 performance domains (`reference/performance-domains/PD8-01…PD8-07.md`, ~120 lines each with Definition / Desired Outcomes / key activities). The 2026 exam is PMBOK-8-aligned; the app's Reference tab currently covers formulas + a term list but not principles/domains as structured study pages.
2. **PMBOK 8 traceability / crosswalk data** (MEDIUM): `docs/pmbok8-traceability-matrix.md`, `PRINCIPLES-CROSSWALK.md` — good raw material for "old KA → new performance domain" mapping, a known 2026 pain point for people studying from pre-2026 courses (like the Ramdayal videos the app tracks).
3. **Artifact cheat-sheet data** (LOW-MEDIUM): the 38 artifact records (what each artifact is, when produced, what feeds it) can be distilled into a compact "Artifacts & Documents" quick reference — exam questions frequently ask "which document…".

### (c) Port plan per feature

**Feature 1+2 — "PMBOK 8 Library" panel (new sidebar tab)**
- **Source files:** `reference/GLOSSARY.md`; `reference/principles/pmbok8/*.md` (6 files); `reference/performance-domains/PD8-0*.md` (7 files); `PRINCIPLES-CROSSWALK.md`.
- **Target:** NEW sidebar tab "PMBOK 8" under the 🗂️ Other nav zone (after the Reference `ni` row, ~line 1130) + new panel `p-pmbok8` appended after `p-weak` (~line 1649).
- **Implementation notes (vanilla-JS):** convert Markdown → a single JS const `PMBOK8_LIB = { glossary:[{term,def}…50], principles:[{id,name,summary,outcomes[]}…6], domains:[{id,name,definition,outcomes[],examTips}…7], crosswalk:[…] }` appended in the data region (after `QUIZ_QUESTIONS` pushes, ~line 4400). Render as an accordion + search box reusing existing `.panel` / card CSS variables. Strip the YAML frontmatter and the practitioner boilerplate (Ref ID tables, changelogs) during extraction — keep Definition + Desired Outcomes + exam-relevant bullets only. Include a one-line MIT attribution comment in the data block.
- **Effort:** small-medium. 90% of the work is content distillation, not code.

**Feature 3 — Artifacts quick reference (optional extension of Feature 1)**
- **Source:** `artifacts/*/A##-*-record.md` header sections only (purpose + lifecycle placement).
- **Target:** third accordion section inside `p-pmbok8`.
- **Notes:** distill to ~1 sentence per artifact; do NOT port the full templates (practitioner-oriented, huge).

### (d) Skip and why

- **48 skill SOP files** — workflow automation for practicing PMs, zero exam value.
- **Full artifact templates/examples** (~3 files per artifact) — for doing projects, not passing the exam; would bloat the single file.
- **Companion-reference summaries (REF-01…24), inputs-outputs registry, tailoring guides, npm/PyPI packaging, archive/** — reference depth beyond exam scope.
- **PMBOK-7 archive folders** — superseded; the app targets the 2026 exam.

---

## Repo 2 — engruxman4-cloud/PMIS-PMBOK

### (a) Summary

- **What it is:** "PMIS CommManager" — an AI Studio-generated React app for stakeholder communications management (PMBOK processes 5.3/5.6/5.7). A practitioner tool, not a study tool. Small: ~1,800 lines of TSX across 7 components.
- **Stack / run model:** React 19 + Vite + TypeScript, `lucide-react`, `recharts`, `mammoth` (.docx parsing), `@google/genai`. Runs with `npm run dev`; **requires `GEMINI_API_KEY`** in `.env.local` (injected via `vite.config.ts` define — no hardcoded secret in the repo, verified).
- **Features:** stakeholder register with power/interest classification; engagement assessment matrix (Unaware→Leading, current vs desired, gap highlighting); communications requirements planner; communication-issue log; performance dashboards (recharts); AI extraction of stakeholders/comm-requirements from pasted charter text (Gemini); .docx import; reports view.
- **License:** **none — all rights reserved.** Code cannot be legally copied.
- **API dependency:** Gemini — conflicts with the app's constraint set (no new external API dependencies; Supabase only).

### (b) Features worth porting

1. **Stakeholder Engagement Assessment Matrix as a *drill*** (MEDIUM): the current-vs-desired engagement grid (C/D markers per stakeholder across Unaware/Resistant/Neutral/Supportive/Leading) is a real exam topic. Ported as an interactive learning widget (given a scenario, place C and D; app scores the gap reasoning) — not as a practitioner register.

That's it. Everything else is practitioner tooling.

### (c) Port plan

**Feature 1 — Engagement Matrix drill (extension of existing Drills tab, `p-study`)**
- **Source to extract:** *concepts only* — the `EngagementLevel` enum ordering and the matrix layout idea from `components/MonitorEngagement.tsx` and `types.ts`. **Do not copy code** (unlicensed, and it's React/JSX anyway — would need a full rewrite regardless).
- **Target:** new drill card inside the Study Center / Drills panel (`p-study`, HTML ~line 1512; drill logic lives in the `sc-content` JS region ~lines 6900–7130).
- **Implementation notes:** author 6–10 original mini-scenarios ("Sponsor attends no meetings but controls budget…") as a small JS array; render a 5-column grid of buttons; user taps current then desired level; score + explain. ~150 lines vanilla JS, zero dependencies, original content.
- **Effort:** small.

### (d) Skip and why

- **All React components verbatim** — no license + React 19/JSX + recharts have no place in a single-file vanilla app.
- **Gemini AI extraction, .docx import (mammoth)** — external API key + npm dependency; violates the app's no-build/no-new-API constraints and adds nothing for exam prep.
- **Comms performance dashboards, issue log, reports** — practitioner PMIS features; a studier needs to *answer questions about* these, not operate them.
- **Overall:** lowest-value repo of the three; the one drill idea is the only take-away.

---

## Repo 3 — AerwinApollo01/pmp-study-platform

### (a) Summary

- **What it is:** the closest cousin to our app — a self-contained PMBOK-8 study platform: 1,131-line `index.html` (vanilla JS, no CDNs) + 7,004-line `content.json` (319 questions / 100 flashcards / 14 formulas, every item source-cited and ECO-2026-tagged) + experimental `matching-lab/` (TypeScript, precompiled `dist/app.js`).
- **Run model:** static — GitHub Pages or any static server (fetches `content.json`; falls back to a tiny built-in set on `file://`). Session-only state by design (no localStorage).
- **Features:** flashcards with topic/type filters + wrong-first spaced repetition; quiz engine with ECO-domain and predictive-vs-agile filters; **interactive EVM calculator** (PV/EV/AC/BAC → SV, CV, SPI, CPI, 4 EAC variants, ETC, VAC, TCPI with interpretations); **Scheduling Lab** (CPM solver with forward/backward pass + SVG network diagram + 3 practice networks; PERT beta/triangular with σ ranges; cheapest-crash compression solver; methods reference); **exam simulator** (ECO-2026-weighted sampling, countdown at 1.3 min/Q, question navigator with flag-for-review, Above/Target/Below bands, readiness gauges per domain/approach/topic, wrong-only review); session dashboard; matching-lab drag-and-drop with "NOT-logic error rate" and "escalation index" behavioral metrics.
- **License:** **none — all rights reserved** (GitHub API confirms `license: null`). Content provenance is also mixed: 110 of the 319 questions were transcribed from a third-party YouTube Q&A video.
- **Secrets/APIs:** none. Pure client-side.

### (b) Features worth porting (ranked)

1. **Scheduling Lab — CPM solver + SVG network diagram + PERT + crash solver** (VERY HIGH): the app currently has only static CPM/PERT formulas and a PDF of exercises. Interactive forward/backward-pass practice with a rendered network diagram is the single biggest gap vs. this repo, and schedule math is guaranteed exam content.
2. **Interactive EVM calculator** (HIGH): the app has the formula *reference*; a calculator that shows all four EAC variants + TCPI with plain-English interpretation turns passive reference into practice. Tiny effort.
3. **Mock-exam UX upgrades** (HIGH): question navigator grid (answered/flagged/current), flag-for-review, wrong-only review filter, and per-domain readiness gauges with Above/Target/Below bands. The app's mock exam already samples 33/41/26 and has a timer — these are additive UX layers on existing code.
4. **Matching-lab behavioral metrics** (MEDIUM): tracking "NOT-question" misses and escalation-trap picks is a genuinely novel weak-signal detector for situational judgment. Fold the *metrics* into the existing quiz engine (tag existing questions) rather than porting the drag-and-drop lab.
5. **Question/flashcard bank** (HIGH value, **BLOCKED by license**): 319 tagged, source-cited questions would nearly double the bank — but no license + 110 video-transcribed items means do not import. Action item: request a license via GitHub issue; revisit if granted.

### (c) Port plan per feature — all clean-room (no verbatim code)

**Feature 1 — Scheduling Lab (new sidebar tab)**
- **Source studied:** `index.html` lines ~744–967 (`solveCpm`, `renderCpmDiagram`, `computePert`, `solveCrash`, `renderRef`) — use as *behavioral spec only*.
- **Target:** NEW sidebar tab "Sched Lab" in the 🏋️ Train nav zone (after the Flashcards `ni` row, ~line 1114) + new panel `p-schedlab` appended after `p-weak` (~line 1649); CSS appended at the end of the style block (before the responsive section ~line 957 or after line 1018); JS appended as a new marked section at the end of the main script.
- **Implementation notes:** standard algorithms, write fresh — Kahn topological sort with cycle detection; forward pass `ES = max(EF of preds)`, backward pass `LF = min(LS of succs)`; float = LS−ES; critical path = zero-float in topo order. SVG diagram: layer nodes by topo depth (columns), draw `<line>` edges, red-stroke critical path, node = 3-row box (ES·Dur·EF / ID / LS·Float·LF). PERT: beta `(O+4M+P)/6`, triangular `(O+M+P)/3`, σ `(P−O)/6`, ±1σ/±2σ. Crash: greedy min-cost-per-period on current critical path, recompute after each step. Author 3 original practice networks (do not copy theirs). Editable table UI with add/remove rows.
- **Effort:** the largest package — ~500–600 lines total (CSS+HTML+JS).

**Feature 2 — EVM calculator (extension of existing Reference tab)**
- **Source studied:** `computeEVM()` (~35 lines) — spec only; formulas are universal PMI math already listed in our own Reference tab.
- **Target:** new card at the top of `p-ref` (HTML lines 1361–1401): 5 inputs (PV, EV, AC, BAC, atypical checkbox) → live-computed table of SV, CV, SPI, CPI, EAC (all 4 variants with the selected one highlighted), ETC, VAC, TCPI(BAC) and TCPI(EAC), each with a green/red interpretation chip ("behind schedule", "over budget").
- **Implementation notes:** one `computeEvmCalc()` function + `oninput` bindings; guard divide-by-zero → "—". Reuse existing `.f-block` styling. ~120 lines.
- **Effort:** small.

**Feature 3 — Mock exam upgrades (extension of Study Center mock exam)**
- **Source studied:** `buildExNav/updateExNav/renderReport/renderExReview` — spec only.
- **Target:** existing mock-exam JS region only (`renderMockQuestion`/`finishMockExam`, ~lines 6890–7130) plus its report renderer. No new panel, no sidebar change, no CSS-block change (inline styles or reuse existing classes).
- **Implementation notes:** add `flagged:Set` to `_mockState`; render a numbered button grid (green=answered, amber=flagged, ring=current) that jumps on click; add a "Flag for review" toggle next to each question; in the report add per-domain bars using the existing domain colors and an Above ≥75% / Target ≥60% / Below band label (documented as a heuristic, not a PMI cut score); add a "show wrong only" checkbox to the review list. ~180 lines, all within existing functions' region.
- **Effort:** small-medium.

**Feature 4 — NOT-logic / escalation-trap metrics (extension of quiz engine + Weak Areas)**
- **Source studied:** `matching-lab/src/analytics.ts` concept (two ratios + a 20% warning threshold) — reimplement trivially.
- **Target:** data region — add `notLogic:true` to existing questions whose stem contains NOT/EXCEPT/LEAST, and `escalationTrap:[optionIdx]` tags on existing situational questions where a distractor defers to sponsor/PMO; JS — small hooks in the existing answer handler to increment two counters in the existing localStorage stats object; UI — two stat cards in the Weak Areas panel (`p-weak`, ~line 1627) that turn amber above 20%.
- **Implementation notes:** tagging pass over `QUIZ_QUESTIONS` is the real work; the metric code is ~40 lines. Skip the drag-and-drop matching UI entirely.
- **Effort:** small (mostly content tagging).

### (d) Skip and why

- **content.json question/flashcard bank verbatim** — unlicensed + 110 items transcribed from someone else's video. Revisit only if the author grants a license.
- **Matching-lab drag-and-drop UI + TypeScript build** — experimental by the author's own admission, needs a toolchain, and HTML5 drag-and-drop is poor on tablets (the app is used on mobile/tablet). Keep only the metrics idea (Feature 4).
- **Their flashcard/quiz/spaced-repetition engines** — the app already has richer versions (persistence, XP, Supabase sync); theirs are session-only.
- **Session-only "no storage" design** — opposite of our persistence model.
- **Their dashboard** — subset of the app's My Stats panel.

---

## Proposed build order — 4 work packages for parallel worktree builds

Region map of `index.html` (current line ranges): CSS `<style>` ≈ 27–1018 · responsive CSS ≈ 957–1018 · overlays + sidebar ≈ 1021–1166 · panels HTML ≈ 1167–1649 · data constants ≈ 1650–5200 (QUIZ_QUESTIONS at 4199) · app JS ≈ 5200–9246 (mock exam ≈ 6890–7130). Each package below touches a disjoint set of anchors so four worktrees merge cleanly. Convention: every package wraps its additions in `<!-- ===== WP# NAME ===== -->` / `/* ===== WP# ===== */` comment fences and **appends at its own named anchor — never reflows existing lines**.

| WP | Package | Regions touched (anchors) | Size |
|---|---|---|---|
| **WP1** | **Scheduling Lab tab** (Repo 3 F1, clean-room) | Sidebar: 1 line after the Flashcards `ni` (~1114) · new panel appended immediately after `p-weak` closing div (~1649) · CSS appended at very end of `<style>` (after responsive block, ~1018) · JS appended at very end of main script (before `</script>`) | L (largest — schedule 1 agent, no other duties) |
| **WP2** | **EVM calculator + PMBOK 8 data prep** (Repo 3 F2 + PMOSkills extraction) | `p-ref` panel interior only (1361–1401) · new `PMBOK8_LIB` const inserted in data region directly after the last `QUIZ_QUESTIONS.push` (~4400) · JS inserted directly after `initRefPanel`-adjacent code with its own fence | M |
| **WP3** | **Mock exam upgrades + engagement drill** (Repo 3 F3 + Repo 2 F1) | Study Center JS region only (~6890–7130, inside existing mock functions) · drill card markup added inside `p-study` panel (~1512–1521) · no sidebar/CSS-block edits (reuse classes) | M |
| **WP4** | **PMBOK 8 Library tab + NOT/escalation metrics** (PMOSkills UI + Repo 3 F4) | Sidebar: 1 line after the Reference `ni` in the Other zone (~1130) · new panel `p-pmbok8` appended after WP1's anchor point *using its own distinct fence* (safe: both are pure insertions at adjacent but different anchor comments) · `p-weak` panel interior (1627–1649) · question tagging = scripted attribute additions inside QUIZ_QUESTIONS (touches data region lines WP2 does not) | M |

Sequencing: WP1–WP3 are fully independent. WP4 has two soft couplings — it consumes `PMBOK8_LIB` (produced by WP2) and inserts a panel near WP1's insertion point — so merge order **WP1 → WP2 → WP3 → WP4**, with WP4 rebased last. If strict parallelism is needed, WP4 can ship `PMBOK8_LIB` itself and WP2 drops that half.

Explicitly deferred: importing the 319-question bank (pending license), matching-lab drag-and-drop UI, all PMIS practitioner features, PMOSkills artifact templates/skill SOPs.
