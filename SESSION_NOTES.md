# PMP Dashboard — Session Notes (2026-04-14)

## What Was Done
- Fixed git email: `nikkimasani@gmail.com` (was uppercase, blocked Vercel)
- Fixed sidebar covering video modal (removed `z-index:1` from `.main`)
- Switched OneDrive API to Graph API with legacy fallback
- Added `scanDynamicVideos()` — scans all subfolders for video files (local + OneDrive)
- Added `buildMyCourses()` — shows all courses dynamically in Video Library tab
- Added auto-scan on page load if OneDrive already connected
- Added `onerror` fallback on video player (shows "Open in new tab" link)

## Current Blocker — OneDrive Videos Not Playing
**Root cause:** New `c/` format OneDrive sharing links (`1drv.ms/f/c/...`) require OAuth.  
**Errors seen:** Graph API → 401 Unauthorized, Legacy API → 400 Bad Request  
**Sharing link:** Already set to "Anyone with the link can view" — not the issue  
**Azure app registration:** Blocked for personal Microsoft accounts without Azure subscription

## Two Fix Paths (pick one next session)

### Path A — Quick workaround (code only, works today)
Change Watch/Open buttons to open OneDrive sharing URL in new tab instead of streaming inline.

### Path B — Proper fix (MSAL OAuth)
1. Join M365 Developer Program (free, no credit card): https://developer.microsoft.com/microsoft-365/dev-program
2. Sign in with nikkimasani@live.com → get free Azure tenant
3. Register app: name="PMP Dashboard", type=SPA, redirect=https://pmp-dashboard-one.vercel.app, personal accounts only
4. Share Client ID → I add MSAL.js + Sign in with Microsoft button
5. All file/video access works via Bearer token

## Key Details
- Live site: https://pmp-dashboard-one.vercel.app
- OneDrive account: nikkimasani@live.com
- PMP folder sharing link: https://1drv.ms/f/c/12dc5ef91903e837/... (saved in dashboard localStorage)
- Files also synced locally at: `C:\Users\nikki.masani\OneDrive - Quorum Business Solutions\PMP\` (cloud-only, not downloaded to disk)
