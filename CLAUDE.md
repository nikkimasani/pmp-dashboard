# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal PMP exam study dashboard. Single-file app (`index.html`, ~7,200 lines). No build step, no npm, no server required.

## Running Locally

Open `index.html` directly in Chrome or Edge. No dev server needed.

## File Layout

Everything lives in `index.html`:
1. `<style>` block — all CSS
2. HTML body — all UI
3. `<script>` block — all JavaScript

Use **Ctrl+F** to search for section names, function names, or IDs. Sections are marked with comments — search for `===` or a section keyword to jump to the right area.

## Data Storage

All state lives in browser `localStorage` — no backend, no sync across devices:
- Quiz scores and history
- Study plan progress
- Any user settings

Clearing browser data clears all progress.

## Deploying

No git repo is set up yet. Two options:

**Netlify Drop (fastest):** Drag `index.html` onto https://app.netlify.com/drop — live in ~10 seconds.

**GitHub Pages (permanent URL):**
1. Create repo `pmp-dashboard` at https://github.com/new (Public)
2. Upload `index.html`
3. Settings → Pages → Deploy from branch → `main` / root
4. URL: `https://nikkimasani.github.io/pmp-dashboard`

See `HOW_TO_DEPLOY.txt` for step-by-step instructions.
