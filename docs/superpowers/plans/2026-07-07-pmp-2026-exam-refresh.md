# PMP 2026 Exam Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the PMP Command Center content so it aligns with PMI's July 9, 2026 PMP exam update.

**Architecture:** The project is a single static HTML app. The implementation updates existing strings and data objects in `index.html` without changing app structure, storage, styling, or deployment configuration.

**Tech Stack:** Static HTML, CSS, JavaScript, browser `localStorage`, Vercel static deployment.

---

## File Structure

- Modify: `C:\Users\nikki\pmp-dashboard\index.html`
- No new runtime files.
- Verification uses PowerShell `Select-String` and direct browser/file rendering.

### Task 1: Update Static Exam Facts And Resource Labels

**Files:**
- Modify: `C:\Users\nikki\pmp-dashboard\index.html`

- [ ] **Step 1: Replace hero/resource stale labels**

Find the Ramdayal course card near the top of `index.html` and replace:

```html
The #1 most recommended PMP course for the ECO 2021 exam. 20 sections · 38+ hours · 400+ practice questions · covers PMBOK 6 knowledge areas AND PMBOK 7 principles/performance domains. Ramdayal's "Is it Agile, Hybrid, or Predictive?" decision framework is the single most useful test-taking tool you'll learn. 35 contact hours — fulfills PMI's education requirement.
```

with:

```html
Primary PMP prep for the 2026 exam refresh. 20 sections · 38+ hours · 400+ practice questions · covers PMBOK 6 knowledge areas, PMBOK 7 principles/performance domains, and the predictive/agile/hybrid decision framework. Supplement with refreshed 2026 topics: AI, sustainability, value delivery, stakeholder engagement, and business outcomes. 35 contact hours — fulfills PMI's education requirement.
```

Replace:

```html
<span class="bdg bdg-green">ECO 2021 Aligned</span>
```

with:

```html
<span class="bdg bdg-green">2026 PMP Refresh</span>
```

- [ ] **Step 2: Update reference guide exam split**

Replace:

```html
<div class="f-block"><div class="f-name">Exam Domains</div><code class="f-eq">People: 42%  |  Process: 50%  |  Business: 8%</code><div class="f-note">~50% Predictive questions, ~50% Agile/Hybrid questions</div></div>
```

with:

```html
<div class="f-block"><div class="f-name">Exam Domains</div><code class="f-eq">People: 33%  |  Process: 41%  |  Business Environment: 26%</code><div class="f-note">Predictive, agile, and hybrid approaches appear through scenario-based questions.</div></div>
```

- [ ] **Step 3: Update mock exam timing**

Replace:

```html
Take the full 180-question mock under timed conditions (230 minutes).
```

with:

```html
Take the full 180-question mock under timed conditions (240 minutes).
```

### Task 2: Update Module And Lesson Guidance

**Files:**
- Modify: `C:\Users\nikki\pmp-dashboard\index.html`

- [ ] **Step 1: Update Module 1 ECO breakdown**

Replace the `ECO 2021 Domain Breakdown` heading and body with:

```javascript
{ heading:'2026 PMP Domain Breakdown', body:'<strong style="color:#7c6bfa">People — 33%</strong>: Leadership, conflict, team development, stakeholder engagement, and collaboration.<br><strong style="color:#ffa502">Process — 41%</strong>: Planning, delivery, measurement, risk, quality, scope, schedule, cost, and change control across predictive, agile, and hybrid work.<br><strong style="color:#ff6b81">Business Environment — 26%</strong>: Strategy, governance, compliance, benefits realization, sustainability, AI awareness, value delivery, and business outcomes.' },
```

- [ ] **Step 2: Update People module title and tips**

Replace:

```javascript
title:'Module 4 — People Domain (42% of Exam)'
```

with:

```javascript
title:'Module 4 — People Domain (33% of Exam)'
```

Replace the first People module tip:

```javascript
'42% of questions are People Domain — treat this as your highest-ROI study area after agile.'
```

with:

```javascript
'People is 33% of the 2026 exam — still essential, but balance it with Process and the expanded Business Environment domain.'
```

- [ ] **Step 3: Update Business Environment module emphasis**

In the Business Environment module resources, keep the current PMBOK and governance references and add wording in lesson content that Business Environment is now 26% and includes AI, sustainability, value delivery, strategy, governance, compliance, benefits realization, and outcomes.

Use this body for the OPM lesson:

```javascript
{ heading:'OPM — Organizational Project Management', body:'OPM is the framework that aligns project, program, and portfolio management with organizational strategy. In the 2026 PMP exam, Business Environment expands to 26%, so expect more questions about strategy, governance, compliance, benefits realization, sustainability, AI-aware delivery, value delivery, and measurable business outcomes. When a project\'s strategic rationale changes, the PM must evaluate whether the project should continue, be modified, or be cancelled.' }
```

- [ ] **Step 4: Update domain weakness analysis**

Replace the Business Environment bullet in `Domain Weakness Analysis` with:

```html
Business Environment score below 70%? → Re-study Module 7. Focus on strategic alignment, benefits realization, governance/compliance, sustainability, AI-aware delivery, value delivery, and business outcomes.
```

### Task 3: Update Practice Resource Descriptions

**Files:**
- Modify: `C:\Users\nikki\pmp-dashboard\index.html`

- [ ] **Step 1: Update video resource stale percentages**

Replace:

```javascript
desc:"⭐ PRIMARY INSTRUCTOR. The most respected PMP teacher for the ECO 2021 exam. His scenario-based approach teaches you HOW to think, not just what to memorize. Watch these before anything else."
```

with:

```javascript
desc:"Primary PMP instructor for core exam strategy. His scenario-based approach teaches you HOW to think, not just what to memorize. Supplement with refreshed 2026 topics: AI, sustainability, value delivery, stakeholder engagement, and business outcomes."
```

Replace:

```javascript
desc:"50% of your exam is agile/hybrid. Ramdayal's agile mindset framework is the clearest explanation of how PMI thinks about agile scenarios."
```

with:

```javascript
desc:"Agile and hybrid scenarios remain central to the 2026 exam. Ramdayal's agile mindset framework is a clear explanation of how PMI thinks about adaptive delivery."
```

Replace:

```javascript
desc:"42% of the exam covers people skills. Ramdayal's People Domain walkthrough covers leadership, conflict, teams, and stakeholders — all scenario-based."
```

with:

```javascript
desc:"33% of the 2026 exam covers people skills. Ramdayal's People Domain walkthrough covers leadership, conflict, teams, collaboration, and stakeholders — all scenario-based."
```

Replace:

```javascript
desc:"180-Question Free Simulator", desc:"Full-length free simulator with ECO 2021 split (People/Process/Business Environment)."
```

with:

```javascript
desc:"180-Question Free Simulator", desc:"Full-length free simulator. Cross-check domain weighting against the 2026 PMP split before relying on score diagnostics."
```

### Task 4: Verify And Commit

**Files:**
- Modify: `C:\Users\nikki\pmp-dashboard\index.html`

- [ ] **Step 1: Search for stale terms**

Run:

```powershell
Select-String -Path C:\Users\nikki\pmp-dashboard\index.html -Pattern "ECO 2021|42%|50% of your exam|Business: 8%|230 minutes" -CaseSensitive:$false
```

Expected: no stale active-study references. If matches remain, inspect and update them unless they are unrelated CSS or intentionally historical.

- [ ] **Step 2: Search for new required terms**

Run:

```powershell
Select-String -Path C:\Users\nikki\pmp-dashboard\index.html -Pattern "2026 PMP|People: 33%|Process: 41%|Business Environment: 26%|240 minutes|AI|sustainability|value delivery" -CaseSensitive:$false
```

Expected: matches in the refreshed course card, reference guide, modules, lessons, and mock exam guidance.

- [ ] **Step 3: Open local app**

Run:

```powershell
Start-Process C:\Users\nikki\pmp-dashboard\index.html
```

Expected: browser opens the static PMP Command Center without a build step.

- [ ] **Step 4: Commit implementation**

Run:

```powershell
git -C C:\Users\nikki\pmp-dashboard add index.html docs/superpowers/specs/2026-07-07-pmp-2026-exam-refresh-design.md docs/superpowers/plans/2026-07-07-pmp-2026-exam-refresh.md
git -C C:\Users\nikki\pmp-dashboard commit -m "Refresh PMP dashboard for 2026 exam"
```

Expected: one commit containing the spec, plan, and content refresh.

## Self-Review

Spec coverage: The plan covers domain weighting, exam time, stale ECO references, study priority changes, and new 2026 emphasis areas.

Placeholder scan: No task contains placeholder implementation language.

Type consistency: The app remains a static HTML file; no new functions, APIs, or types are introduced.
