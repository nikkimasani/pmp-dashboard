# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal PMP exam study dashboard. Single-file app (`index.html`, ~7,200 lines). No build step, no npm, no server required.

**Live:** https://pmp-dashboard-one.vercel.app  
**Branch:** `main` → Vercel auto-deploys on push (~30 seconds)

## Running Locally

Open `index.html` directly in Chrome or Edge. No dev server needed.

## File Layout

Everything lives in `index.html` in this order:
1. `<style>` block — all CSS
2. HTML body — all UI
3. `<script>` block — all JavaScript

`msal-browser.min.js` is bundled locally (not CDN) — required for the OneDrive Sign In / MSAL OAuth feature.

Use **Ctrl+F** to search by section name, function name, or element ID. Sections are delimited with `===` banner comments.

## Data Storage

All state lives in browser `localStorage` — no backend, no cross-device sync:
- Quiz scores and history
- Study plan progress
- User settings and OneDrive credentials

## OneDrive / MSAL Integration (in progress)

The Video Library tab connects to a personal OneDrive folder to browse and stream PMP study videos. MSAL.js is loaded from the local `msal-browser.min.js`.

**Current blocker:** New `1drv.ms/f/c/...` sharing links require OAuth — anonymous Graph API calls return 401. See `SESSION_NOTES.md` for the full context and two fix paths:
- **Path A (quick):** Change Watch/Open buttons to open the sharing URL in a new tab instead of streaming inline — works today, code-only change.
- **Path B (proper):** Full MSAL OAuth via M365 Developer Program — enables in-app streaming.

Key functions related to OneDrive:
- `scanDynamicVideos()` — scans OneDrive subfolders for video files
- `buildMyCourses()` — renders all courses dynamically in the Video Library tab
- OneDrive folder link + credentials stored in `localStorage` (set by user in UI, not hardcoded)

## Deploying

```bash
git add index.html
git commit -m "describe change"
git push
```

Vercel auto-deploys on push. No manual step needed.
