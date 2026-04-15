# PRD: PMP Dashboard

## Purpose

A personal, all-in-one study companion for the PMP exam. Replaces scattered notes, spreadsheets, and video bookmarks with a single offline-capable HTML file.

## Users

Single user (personal study tool). No sign-in, no backend required.

## Features

- **Practice Quizzes** — question bank with per-attempt scoring and history
- **Study Plan** — progress tracker mapped to PMP exam knowledge domains
- **Video Library** — connects to a personal OneDrive folder to browse and stream PMP study videos via Graph API; scans subfolders dynamically
- **Flashcards** — key concept review
- **Notes** — freeform study notes persisted in localStorage
- **XP / Progress System** — gamified XP tied to quiz completions and study plan actions

## Technical Constraints

- Single `index.html` — all CSS, HTML, and JS must remain inline
- No build step, no npm, no framework
- `msal-browser.min.js` bundled locally for MSAL OAuth (OneDrive)
- All user data in `localStorage` — no cross-device sync
- OneDrive in-app streaming requires MSAL OAuth (see `SESSION_NOTES.md`); until then, videos open in a new tab as fallback

## Deployment

Vercel (auto-deploys from `main`). Live at https://pmp-dashboard-one.vercel.app
