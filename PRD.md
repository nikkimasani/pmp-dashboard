# PRD: PMP Dashboard

## Purpose

A personal, all-in-one study companion for the PMP exam. Replaces scattered notes, spreadsheets, and video bookmarks with a single HTML file deployable on Vercel. Supports a small study group with shared progress visibility.

## Users

- **Primary:** Nikki Masani (admin) — `nikkimasani@gmail.com` / `nikki.masani@quorumsoftware.com`
- **Secondary:** Study group members who register via the login screen
- Authentication is required — the app does not load without a valid Supabase session

## Features

- **Practice Quizzes** — question bank with per-attempt scoring, history, and weak-area tracking
- **Study Plan** — progress tracker mapped to PMP exam knowledge domains
- **Video Library** — connects to a personal OneDrive folder to browse and stream PMP study videos via Graph API; scans subfolders dynamically
- **Flashcards** — key concept review
- **Notes** — freeform study notes persisted in localStorage + Supabase sync
- **XP / Progress System** — gamified XP tied to quiz completions and study plan actions
- **Start Here** — personalized daily training hub with time-aware greeting, coach briefing, and day count to exam
- **Admin Panel** — visible to admin users only; shows all study group members with streak, XP, score, plan %, and last active date

## Authentication

- Supabase Auth (email/password)
- Login/register overlay on first load; session persisted via Supabase JS SDK
- Profile setup modal on first login (name + exam date)
- Admin emails hardcoded in `ADMIN_EMAILS` array: `nikki.masani@quorumsoftware.com`, `nikkimasani@gmail.com`
- Supabase project: `sajwrezhnzqlhskkbgwc.supabase.co`

## Database Schema (Supabase)

```sql
pmp_profiles (id uuid PK → auth.users, name, role, exam_date, created_at)
pmp_user_stats (user_id uuid PK → pmp_profiles, streak, xp, overall_score, questions_done, plan_pct, last_synced)
```

RLS enabled; authenticated users can read all rows (leaderboard-style), write only their own.

## Technical Constraints

- Single `index.html` (~9,000 lines) — all CSS, HTML, and JS inline
- No build step, no npm, no framework
- `msal-browser.min.js` bundled locally for MSAL OAuth (OneDrive)
- User stats synced to Supabase every 5 min and on page focus; primary store is `localStorage`
- Exam date stored under `localStorage` key `pmp_examDate` (via `save('examDate', ...)` helper)
- OneDrive in-app streaming requires MSAL OAuth (see `SESSION_NOTES.md`); videos currently open in a new tab as fallback

## Deployment

Vercel (auto-deploys from `main`). Live at https://pmp-dashboard-one.vercel.app
