# PMP 2026 Exam Refresh Design

## Goal

Update the PMP Command Center so its study guidance matches PMI's PMP exam launching on July 9, 2026.

## Source Of Truth

Use PMI's current PMP certification and new-exam pages as the authority for changed exam facts:

- Launch date: July 9, 2026
- Old exam last date: before July 8, 2026
- Domain weighting: People 33%, Process 41%, Business Environment 26%
- Exam experience: 180 questions, 240 minutes
- New emphasis: AI, sustainability, stakeholder engagement, value delivery, outcomes, and adaptive real-world project dynamics

## Scope

Modify the latest local project at `C:\Users\nikki\pmp-dashboard`, which is linked to the Vercel project `pmp-dashboard`.

Keep the app as a single static `index.html` file. Do not redesign the UI, split the app, add a build step, or preserve a legacy exam mode.

## Content Changes

Replace stale ECO 2021 language with 2026 PMP exam language. Update old weighting references from `People 42% / Process 50% / Business 8%` to `People 33% / Process 41% / Business Environment 26%`.

Refresh the study guidance so Process remains the largest domain, Business Environment becomes a major priority, and People is still important but no longer framed as 42% or the highest-ROI domain.

Add explicit coverage cues for AI, sustainability, value delivery, outcome focus, stakeholder engagement, hybrid/predictive/agile delivery, and adaptive real-world scenarios.

Update mock exam timing from 230 minutes to 240 minutes.

## Verification

After editing, search `index.html` for stale phrases:

- `ECO 2021`
- `42%`
- `50% of your exam`
- `Business: 8%`
- `230 minutes`

Any remaining matches must either be removed or intentionally refer to historical context, which this refresh does not need.

Open the local HTML file to confirm the app still renders as a static dashboard.
