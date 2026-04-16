# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal PMP exam study dashboard for a small study group. Single-file app (`index.html`, ~9,000 lines). No build step, no npm, no framework. Requires Supabase auth to load.

**Live:** https://pmp-dashboard-one.vercel.app  
**Branch:** `main` → Vercel auto-deploys on push (~30 seconds)

## Running Locally

Open `index.html` directly in Chrome or Edge. No dev server needed. Auth will prompt for login — use a registered Supabase account.

## File Layout

Everything lives in `index.html` in this order:
1. `<style>` block — all CSS
2. HTML body — all UI
3. `<script>` block — all JavaScript

`msal-browser.min.js` is bundled locally (not CDN) — required for the OneDrive Sign In / MSAL OAuth feature.

Use **Ctrl+F** to search by section name, function name, or element ID. Sections are delimited with `===` banner comments.

## Data Storage

Primary store is browser `localStorage`. Stats are also synced to Supabase every 5 min and on page focus.

- `save('examDate', v)` / `load('examDate')` — writes/reads `localStorage` key `pmp_examDate`
- `save(k, v)` helper always prepends `pmp_` to the key
- `localStorage.removeItem('pmp_examDate')` — correct way to clear exam date directly

## Authentication (Supabase)

- **Project URL:** `https://sajwrezhnzqlhskkbgwc.supabase.co`
- **Anon key:** in `SB_KEY` constant at top of auth section
- **Admin emails:** `ADMIN_EMAILS` array — `nikki.masani@quorumsoftware.com`, `nikkimasani@gmail.com`
- Login/register overlay shown on load if no session; profile setup modal on first login
- `onAuthReady(user)` — called after sign-in; fetches profile, shows admin nav, populates sidebar user pill, syncs exam date to localStorage

### Supabase Tables

```sql
pmp_profiles  — id (uuid, FK auth.users), name, role, exam_date, created_at
pmp_user_stats — user_id (uuid, FK pmp_profiles), streak, xp, overall_score, questions_done, plan_pct, last_synced
```

RLS enabled. Auth users can read all rows, write only their own.

### Key Auth Functions

- `initAuth()` — initializes Supabase client, restores session or shows login overlay
- `doSignIn()` / `doSignUp()` — sign-in and registration handlers
- `saveProfile()` — upserts profile row; called from profile setup modal
- `syncToSupabase()` — pushes localStorage stats to `pmp_user_stats`
- `loadAdminPanel()` — joins profiles + stats, renders admin table

## OneDrive / MSAL Integration (in progress)

The Video Library tab connects to a personal OneDrive folder to browse and stream PMP study videos.

**Current blocker:** New `1drv.ms/f/c/...` sharing links require OAuth — anonymous Graph API calls return 401.
- **Path A (quick):** Change Watch/Open buttons to open the sharing URL in a new tab — code-only change, works today.
- **Path B (proper):** Full MSAL OAuth via M365 Developer Program — enables in-app streaming.

Key functions:
- `scanDynamicVideos()` — scans OneDrive subfolders for video files
- `buildMyCourses()` — renders all courses dynamically in the Video Library tab

## Deploying

```bash
git add index.html
git commit -m "describe change"
git push
```

Vercel auto-deploys on push. No manual step needed.
