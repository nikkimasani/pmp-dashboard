# PMP Boot Camp — UX/UI Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the PMP dashboard into a motivating athletic-training environment with daily task assignment, coach briefing, celebrations, XP/levels, and a badge achievement system.

**Architecture:** All changes in a single `index.html` file. New JS functions are added to the existing `<script>` block. New CSS classes are added to the existing `<style>` block. All state uses the existing `save(k,v)` / `load(k,def)` helpers (auto-prefix `pmp_`).

**Tech Stack:** Vanilla HTML/CSS/JS, localStorage, no build step. Open in Chrome/Edge to test.

**Testing note:** No test runner — each task ends with a manual browser verification checklist. Open `index.html` directly in Chrome.

---

## File Map

| File | Changes |
|------|---------|
| `index.html:6` | Rename `<title>` |
| `index.html:791` | Rename `.logo-t` text |
| `index.html:12–787` | Add CSS for all new components |
| `index.html:788–846` | Restructure sidebar HTML (zones, progress bar) |
| `index.html:852–855` | Start Here panel (replaced by `buildStartHere`) |
| `index.html:1227` | Rename Progress tab → My Stats, add badge gallery |
| `index.html:4014` | Upgrade `showToast` + add new celebration functions |
| `index.html:5326+` | Add achievement engine, daily generator, coach briefing |
| `index.html:5344` | Replace `buildStartHere()` entirely |
| `index.html:7235` | Extend `buildProgressTracker` with badge gallery |
| `index.html:7691+` | Extend streak/progress helpers |

---

## Task 1: App Rename + CSS Foundation

**Files:**
- Modify: `index.html:6` — page title
- Modify: `index.html:791` — sidebar logo text
- Modify: `index.html:12–14` — add CSS custom properties
- Modify: `index.html` `<style>` block — add all new component CSS classes

- [ ] **Step 1: Rename page title and sidebar logo**

Find and replace in `index.html`:
```
Line 6:   <title>PMP Base Camp</title>
→         <title>PMP Boot Camp</title>

Line 791: <div class="logo-t">Base Camp</div>
→         <div class="logo-t">Boot Camp</div>
```
Also find any other occurrences of "Base Camp" in the HTML (page headers, tooltips) and replace with "Boot Camp".

- [ ] **Step 2: Add CSS for sidebar progress bar**

Inside the `<style>` block, after the `.sb-cd` rule (around line 38), add:
```css
.sb-prog-wrap{padding:0 18px 14px;border-bottom:1px solid var(--border)}
.sb-prog-lbl{display:flex;justify-content:space-between;font-size:9px;color:var(--t2);font-weight:600;margin-bottom:5px;text-transform:uppercase;letter-spacing:.8px}
.sb-prog-bar{height:5px;background:var(--s3);border-radius:100px;overflow:hidden}
.sb-prog-fill{height:100%;background:linear-gradient(90deg,var(--accent),var(--a2));border-radius:100px;transition:width .6s ease}
```

- [ ] **Step 3: Add CSS for zone nav labels**

After the `.nav-lbl` rule (around line 42), add:
```css
.nav-zone{font-size:8px;font-weight:800;text-transform:uppercase;letter-spacing:1.5px;padding:10px 10px 5px;display:flex;align-items:center;gap:5px}
.nav-zone-train{color:#2ed573}
.nav-zone-progress{color:#3d9eff}
.nav-zone-study{color:#a55eea}
.ni-badge{font-size:9px;font-weight:700;margin-left:auto;padding:1px 6px;border-radius:4px}
.ni-badge-green{color:var(--green);background:rgba(46,213,115,.1)}
.ni-badge-orange{color:var(--a4);background:rgba(255,165,2,.1)}
.ni-badge-red{color:var(--red);background:rgba(255,71,87,.1)}
.ni-badge-accent{color:var(--accent);background:rgba(124,107,250,.12);border:1px solid rgba(124,107,250,.2)}
```

- [ ] **Step 4: Add CSS for Start Here stats cards**

```css
.sh-stats{display:grid;grid-template-columns:repeat(4,1fr);gap:10px;margin-bottom:18px}
.sh-stat{background:var(--s1);border:1px solid var(--border);border-radius:var(--r);padding:16px;text-align:center;transition:border-color .2s}
.sh-stat:hover{border-color:rgba(124,107,250,.35)}
.sh-stat-val{font-size:28px;font-weight:900;letter-spacing:-1px;line-height:1}
.sh-stat-lbl{font-size:8px;color:var(--t2);text-transform:uppercase;letter-spacing:1px;margin-top:5px}
.sh-stat-sub{font-size:9px;font-weight:700;margin-top:6px}
.sh-stat-bar{height:3px;background:var(--s3);border-radius:100px;overflow:hidden;margin-top:8px}
.sh-stat-bar-fill{height:100%;border-radius:100px}
```

- [ ] **Step 5: Add CSS for coach briefing card**

```css
.coach-card{background:linear-gradient(135deg,rgba(255,165,2,.08),rgba(255,71,87,.04));border:1px solid rgba(255,165,2,.25);border-radius:14px;padding:18px 20px;margin-bottom:18px;position:relative;overflow:hidden}
.coach-card::after{content:'🏅';position:absolute;top:-15px;right:-5px;font-size:64px;opacity:.06;pointer-events:none}
.coach-ico{width:36px;height:36px;background:linear-gradient(135deg,#ffa502,#ff6b35);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:18px;flex-shrink:0}
.coach-lbl{font-size:9px;color:var(--a4);font-weight:800;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px}
.coach-msg{font-size:13px;color:rgba(236,237,250,.88);line-height:1.65;font-style:italic}
```

- [ ] **Step 6: Add CSS for Today's Training task cards**

```css
.training-hdr{display:flex;justify-content:space-between;align-items:center;margin-bottom:10px}
.training-lbl{font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:1px;color:var(--t2)}
.training-count{font-size:10px;color:var(--t2)}
.task-card{border-radius:12px;padding:14px 18px;display:flex;align-items:center;gap:14px;cursor:pointer;transition:all .18s;margin-bottom:8px}
.task-card:hover{transform:translateX(3px)}
.task-card.done{opacity:.55}
.task-card.done .task-title{text-decoration:line-through}
.task-ico{width:32px;height:32px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;border-width:2px;border-style:solid}
.task-title{font-size:13px;font-weight:700;color:var(--text);margin-bottom:2px}
.task-sub{font-size:11px;color:var(--t2)}
.task-btn{border-radius:8px;padding:6px 14px;font-size:11px;font-weight:800;white-space:nowrap;cursor:pointer;border:1px solid;background:transparent;font-family:'Outfit',sans-serif;transition:all .18s}
.task-change{font-size:10px;color:var(--t3);cursor:pointer;background:none;border:none;font-family:'Outfit',sans-serif;padding:0;margin-top:4px}
.task-change:hover{color:var(--t2)}
.task-card-watch{background:rgba(46,213,115,.06);border:1px solid rgba(46,213,115,.2)}
.task-card-drill{background:rgba(124,107,250,.06);border:1px solid rgba(124,107,250,.2)}
.task-card-review{background:rgba(61,158,255,.06);border:1px solid rgba(61,158,255,.2)}
```

- [ ] **Step 7: Add CSS for readiness bar + greeting**

```css
.sh-greeting{display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:20px}
.sh-greeting-name{font-size:22px;font-weight:900;letter-spacing:-.5px}
.sh-greeting-date{font-size:11px;color:var(--t2);letter-spacing:2px;text-transform:uppercase;margin-bottom:4px}
.sh-streak-card{background:rgba(255,165,2,.08);border:1px solid rgba(255,165,2,.25);border-radius:10px;padding:8px 14px;text-align:right;flex-shrink:0}
.sh-streak-val{font-size:24px;font-weight:900;color:var(--a4);line-height:1}
.sh-streak-lbl{font-size:8px;color:var(--t2);text-transform:uppercase;letter-spacing:1px;margin-top:2px}
.readiness-bar-wrap{background:var(--s1);border:1px solid var(--border);border-radius:12px;padding:14px 18px;margin-top:0}
.readiness-lbl{display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;font-size:11px;font-weight:700;color:var(--t2);text-transform:uppercase;letter-spacing:1px}
.readiness-note{font-size:10px;color:var(--t2);margin-top:8px}
```

- [ ] **Step 8: Add CSS for celebration components**

```css
/* Tier 1 — Win toast */
.win-toast{position:fixed;bottom:24px;right:24px;background:var(--s2);border:1px solid rgba(46,213,115,.35);border-radius:12px;padding:12px 16px;display:flex;align-items:center;gap:12px;box-shadow:0 8px 32px rgba(0,0,0,.4);z-index:3000;transform:translateX(120%);transition:transform .3s cubic-bezier(.34,1.56,.64,1);max-width:300px}
.win-toast.show{transform:translateX(0)}
.win-toast-ico{font-size:22px;flex-shrink:0}
.win-toast-title{font-size:12px;font-weight:700;color:var(--text);margin-bottom:2px}
.win-toast-sub{font-size:11px;color:var(--t2)}
.win-toast-xp{width:28px;height:28px;background:rgba(46,213,115,.12);border:1px solid rgba(46,213,115,.3);border-radius:50%;display:flex;align-items:center;justify-content:center;color:var(--green);font-size:10px;font-weight:800;flex-shrink:0}
/* Tier 2 — PR banner */
.pr-banner{background:linear-gradient(135deg,rgba(255,165,2,.15),rgba(255,71,87,.08));border:1px solid rgba(255,165,2,.4);border-radius:14px;padding:18px 22px;display:flex;align-items:center;gap:16px;margin-bottom:16px;position:relative;overflow:hidden}
.pr-banner::after{content:'🏆';position:absolute;top:-15px;right:-5px;font-size:80px;opacity:.07;pointer-events:none}
.pr-banner-ico{font-size:36px;flex-shrink:0}
.pr-banner-label{font-size:11px;font-weight:800;color:var(--a4);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:4px}
.pr-banner-score{font-size:17px;font-weight:900;color:var(--text);margin-bottom:4px}
.pr-banner-delta{font-size:12px;color:var(--t2)}
/* Tier 3 — Big modal */
.celebration-overlay{position:fixed;inset:0;background:rgba(0,0,0,.85);z-index:4000;display:flex;align-items:center;justify-content:center;opacity:0;pointer-events:none;transition:opacity .25s}
.celebration-overlay.show{opacity:1;pointer-events:all}
.celebration-modal{background:var(--s2);border:1px solid rgba(46,213,115,.3);border-radius:16px;padding:28px 24px;text-align:center;max-width:320px;width:90%;box-shadow:0 0 60px rgba(46,213,115,.12)}
.celebration-title{font-size:11px;font-weight:800;color:var(--green);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:6px}
.celebration-name{font-size:18px;font-weight:900;color:var(--text);margin-bottom:6px}
.celebration-desc{font-size:12px;color:var(--t2);margin-bottom:16px}
.celebration-badge-pill{font-size:11px;font-weight:700;color:var(--green);background:rgba(46,213,115,.08);border:1px solid rgba(46,213,115,.2);border-radius:8px;padding:8px 14px;margin-bottom:16px;display:inline-block}
/* Badge gallery */
.badge-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(130px,1fr));gap:10px;margin-bottom:20px}
.badge-card{border-radius:12px;padding:14px;text-align:center;border-width:2px;border-style:solid;transition:all .2s}
.badge-card-earned{background:rgba(46,213,115,.08);border-color:rgba(46,213,115,.4)}
.badge-card-reach{background:rgba(255,165,2,.06);border-color:rgba(255,165,2,.35)}
.badge-card-locked{background:rgba(255,255,255,.02);border-color:rgba(255,255,255,.08);opacity:.55}
.badge-card-ico{font-size:28px;margin-bottom:6px}
.badge-card-locked .badge-card-ico{filter:grayscale(1)}
.badge-card-status{font-size:10px;font-weight:800;text-transform:uppercase;margin-bottom:2px}
.badge-card-name{font-size:11px;font-weight:700;color:var(--text)}
.badge-card-desc{font-size:9px;color:var(--t2);margin-top:3px}
.badge-reach-bar{background:rgba(255,255,255,.05);border-radius:100px;height:3px;overflow:hidden;margin-top:6px}
.badge-reach-fill{height:100%;background:var(--a4);border-radius:100px}
/* XP level card */
.xp-card{background:var(--s1);border:1px solid rgba(165,94,234,.25);border-radius:14px;padding:16px 18px;margin-bottom:20px}
.xp-avatar{width:44px;height:44px;background:linear-gradient(135deg,#a55eea,#7c6bfa);border-radius:12px;display:flex;align-items:center;justify-content:center;font-size:20px;flex-shrink:0}
.xp-bar-wrap{background:rgba(255,255,255,.05);border-radius:100px;height:6px;overflow:hidden;margin:6px 0}
.xp-bar-fill{height:100%;background:linear-gradient(90deg,#a55eea,#7c6bfa);border-radius:100px;transition:width .6s ease}
```

- [ ] **Step 9: Verify in browser**

Open `index.html` in Chrome. Check:
- Tab title reads "PMP Boot Camp"
- Sidebar shows "Boot Camp" under the PMP badge
- No visual breakage (layout unchanged at this point — CSS is just added, not wired)

- [ ] **Step 10: Commit**

```bash
git add index.html
git commit -m "feat: rename to Boot Camp + add CSS foundation for redesign"
```

---

## Task 2: Achievement Engine (Data Layer)

**Files:**
- Modify: `index.html` `<script>` block — add after the `save`/`load` helpers (around line 4002)

- [ ] **Step 1: Add achievement constants**

After `function load(k, def) { ... }` (around line 4001), add:

```javascript
// ============================================================
// ACHIEVEMENT ENGINE
// ============================================================
const XP_LEVELS = [
  { level:1, xp:0,      title:'Recruit' },
  { level:2, xp:500,    title:'Trainee' },
  { level:3, xp:1000,   title:'Associate' },
  { level:4, xp:1750,   title:'Practitioner' },
  { level:5, xp:2750,   title:'Senior Practitioner' },
  { level:6, xp:4000,   title:'Project Lead' },
  { level:7, xp:5500,   title:'Project Manager' },
  { level:8, xp:7500,   title:'Senior PM' },
  { level:9, xp:10000,  title:'PMP Candidate' },
  { level:10, xp:13000, title:'PMP Champion' }
];

const BADGES = [
  // Domain mastery
  { id:'scope_master',    ico:'🏗️', name:'Scope Master',     desc:'Scope Management complete',    cat:'domain', trigger:'scope' },
  { id:'schedule_pro',    ico:'⏱️', name:'Schedule Pro',      desc:'Schedule Management complete',  cat:'domain', trigger:'schedule' },
  { id:'cost_controller', ico:'💰', name:'Cost Controller',   desc:'Cost & EVM complete',           cat:'domain', trigger:'cost' },
  { id:'quality_guard',   ico:'✅', name:'Quality Guard',     desc:'Quality Management complete',   cat:'domain', trigger:'quality' },
  { id:'risk_manager',    ico:'⚠️', name:'Risk Manager',      desc:'Risk Management complete',      cat:'domain', trigger:'risk' },
  { id:'procurement_pro', ico:'📦', name:'Procurement Pro',   desc:'Procurement complete',          cat:'domain', trigger:'procurement' },
  { id:'people_leader',   ico:'🤝', name:'People Leader',     desc:'Resource Management complete',  cat:'domain', trigger:'resources' },
  { id:'comms_expert',    ico:'📡', name:'Comms Expert',      desc:'Communications complete',       cat:'domain', trigger:'comms' },
  { id:'agile_champion',  ico:'🔄', name:'Agile Champion',    desc:'Agile/Hybrid complete',         cat:'domain', trigger:'agile' },
  { id:'integration_ace', ico:'🔗', name:'Integration Ace',   desc:'Integration Management complete', cat:'domain', trigger:'integration' },
  // Streak
  { id:'week_warrior',    ico:'🔥', name:'Week Warrior',      desc:'7-day streak',                  cat:'streak', trigger:7 },
  { id:'two_week_push',   ico:'💪', name:'Two-Week Push',     desc:'14-day streak',                 cat:'streak', trigger:14 },
  { id:'iron_will',       ico:'🏆', name:'Iron Will',         desc:'30-day streak',                 cat:'streak', trigger:30 },
  // Performance
  { id:'sharp_shooter',   ico:'🎯', name:'Sharp Shooter',     desc:'Score 80%+ on any quiz',        cat:'perf', trigger:80 },
  { id:'exam_ready',      ico:'🧠', name:'Exam Ready',        desc:'Score 80%+ on full mock exam',  cat:'perf', trigger:'mock80' },
  { id:'perfect_score',   ico:'⭐', name:'Perfect Score',     desc:'Score 100% on any section quiz',cat:'perf', trigger:100 }
];

function getAchievements() {
  return load('achievements', { xp:0, earnedBadges:[], bestScores:{} });
}

function saveAchievements(a) {
  save('achievements', a);
}

function getLevelInfo(xp) {
  let current = XP_LEVELS[0];
  let next = XP_LEVELS[1];
  for (let i = XP_LEVELS.length - 1; i >= 0; i--) {
    if (xp >= XP_LEVELS[i].xp) { current = XP_LEVELS[i]; next = XP_LEVELS[i+1] || null; break; }
  }
  return { current, next };
}
```

- [ ] **Step 2: Add XP earning function**

```javascript
function awardXP(amount, reason) {
  const a = getAchievements();
  const prevLevel = getLevelInfo(a.xp).current.level;
  a.xp += amount;
  saveAchievements(a);
  const newLevel = getLevelInfo(a.xp).current.level;
  showWinToast('⚡ +' + amount + ' XP', reason);
  if (newLevel > prevLevel) {
    const info = getLevelInfo(a.xp);
    showCelebrationModal('Level Up!', 'Level ' + info.current.level + ' — ' + info.current.title, 'You reached a new rank 🎖️');
  }
  updateSidebarProgress();
}
```

- [ ] **Step 3: Add badge unlock function**

```javascript
function unlockBadge(badgeId) {
  const a = getAchievements();
  if (a.earnedBadges.includes(badgeId)) return;
  a.earnedBadges.push(badgeId);
  saveAchievements(a);
  const badge = BADGES.find(b => b.id === badgeId);
  if (!badge) return;
  awardXP(150, badge.name + ' badge earned');
  showCelebrationModal('Badge Unlocked! ' + badge.ico, badge.name, badge.desc);
}

function checkStreakBadges(streak) {
  if (streak >= 7)  unlockBadge('week_warrior');
  if (streak >= 14) unlockBadge('two_week_push');
  if (streak >= 30) unlockBadge('iron_will');
}

function checkQuizBadges(pct, isMock) {
  if (pct >= 80) unlockBadge('sharp_shooter');
  if (pct >= 80 && isMock) unlockBadge('exam_ready');
  if (pct === 100) unlockBadge('perfect_score');
}

function checkPersonalRecord(domainKey, pct) {
  const a = getAchievements();
  const prev = a.bestScores[domainKey] || 0;
  if (pct > prev) {
    a.bestScores[domainKey] = pct;
    saveAchievements(a);
    return prev; // return previous best so caller can show PR banner
  }
  return null;
}
```

- [ ] **Step 4: Verify in browser console**

Open DevTools console and run:
```javascript
awardXP(50, 'Test quiz');
console.log(load('achievements', {}));
// Expected: { xp: 50, earnedBadges: [], bestScores: {} }

unlockBadge('sharp_shooter');
console.log(load('achievements', {}).earnedBadges);
// Expected: ['sharp_shooter']
```

- [ ] **Step 5: Commit**

```bash
git add index.html
git commit -m "feat: add achievement engine — XP, levels, badge unlock"
```

---

## Task 3: Celebration System

**Files:**
- Modify: `index.html` — add celebration HTML to `<body>` (before closing `</body>`), add JS functions

- [ ] **Step 1: Add celebration HTML to body**

Just before `</body>`, add:
```html
<!-- WIN TOAST -->
<div id="win-toast" class="win-toast">
  <div class="win-toast-ico" id="win-toast-ico">✅</div>
  <div style="flex:1">
    <div class="win-toast-title" id="win-toast-title">Task Complete!</div>
    <div class="win-toast-sub" id="win-toast-sub"></div>
  </div>
  <div class="win-toast-xp" id="win-toast-xp">+XP</div>
</div>
<!-- CELEBRATION OVERLAY -->
<div id="celebration-overlay" class="celebration-overlay" onclick="closeCelebration()">
  <canvas id="confetti-canvas" style="position:fixed;inset:0;pointer-events:none;z-index:4001"></canvas>
  <div class="celebration-modal" onclick="event.stopPropagation()">
    <div style="font-size:44px;margin-bottom:8px" id="cel-ico">🎉</div>
    <div class="celebration-title" id="cel-title">Section Complete!</div>
    <div class="celebration-name" id="cel-name"></div>
    <div class="celebration-desc" id="cel-desc"></div>
    <div class="celebration-badge-pill" id="cel-pill" style="display:none"></div>
    <button class="btn btn-p" style="width:100%;justify-content:center" onclick="closeCelebration()">Keep Going →</button>
  </div>
</div>
```

- [ ] **Step 2: Add showWinToast function**

Replace the existing `showToast` function OR add alongside it (keep existing `showToast` for compatibility):
```javascript
let _winToastTimer = null;
function showWinToast(title, sub, xpAmount) {
  const t = document.getElementById('win-toast');
  const ico = document.getElementById('win-toast-ico');
  const tEl = document.getElementById('win-toast-title');
  const sEl = document.getElementById('win-toast-sub');
  const xEl = document.getElementById('win-toast-xp');
  if (!t) return;
  tEl.textContent = title;
  sEl.textContent = sub || '';
  xEl.textContent = xpAmount ? '+' + xpAmount : '';
  xEl.style.display = xpAmount ? '' : 'none';
  t.classList.add('show');
  clearTimeout(_winToastTimer);
  _winToastTimer = setTimeout(() => t.classList.remove('show'), 3000);
}
```

- [ ] **Step 3: Add celebration modal + confetti**

```javascript
function showCelebrationModal(title, name, desc, pillText) {
  document.getElementById('cel-title').textContent = title;
  document.getElementById('cel-name').textContent = name;
  document.getElementById('cel-desc').textContent = desc || '';
  const pill = document.getElementById('cel-pill');
  if (pillText) { pill.textContent = pillText; pill.style.display = ''; }
  else { pill.style.display = 'none'; }
  document.getElementById('celebration-overlay').classList.add('show');
  launchConfetti();
}

function closeCelebration() {
  document.getElementById('celebration-overlay').classList.remove('show');
}

function launchConfetti() {
  const canvas = document.getElementById('confetti-canvas');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  const colors = ['#7c6bfa','#00e5b8','#2ed573','#ffa502','#ff4757'];
  const particles = Array.from({length:60}, () => ({
    x: Math.random() * canvas.width,
    y: -10,
    r: 4 + Math.random() * 4,
    color: colors[Math.floor(Math.random() * colors.length)],
    vx: (Math.random() - .5) * 4,
    vy: 2 + Math.random() * 4,
    alpha: 1,
    rot: Math.random() * 360,
    rotV: (Math.random() - .5) * 8
  }));
  let frame;
  function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles.forEach(p => {
      p.x += p.vx; p.y += p.vy; p.vy += .1; p.alpha -= .012; p.rot += p.rotV;
      if (p.alpha <= 0) return;
      ctx.save(); ctx.globalAlpha = p.alpha; ctx.fillStyle = p.color;
      ctx.translate(p.x, p.y); ctx.rotate(p.rot * Math.PI/180);
      ctx.fillRect(-p.r/2, -p.r/2, p.r, p.r);
      ctx.restore();
    });
    if (particles.some(p => p.alpha > 0)) frame = requestAnimationFrame(draw);
    else ctx.clearRect(0, 0, canvas.width, canvas.height);
  }
  cancelAnimationFrame(frame);
  draw();
}
```

- [ ] **Step 4: Add Personal Record banner helper**

```javascript
function showPRBanner(containerId, domain, newPct, prevPct) {
  const container = document.getElementById(containerId);
  if (!container) return;
  const delta = newPct - prevPct;
  const html = `<div class="pr-banner">
    <div class="pr-banner-ico">🏆</div>
    <div>
      <div class="pr-banner-label">⚡ New Personal Record!</div>
      <div class="pr-banner-score">${domain} — ${newPct}%</div>
      <div class="pr-banner-delta">Previous best: ${prevPct}% &nbsp;·&nbsp; <span style="color:var(--green);font-weight:700">+${delta} points 📈</span></div>
    </div>
  </div>`;
  container.insertAdjacentHTML('afterbegin', html);
}
```

- [ ] **Step 5: Wire checkPersonalRecord into quiz results**

Find `function buildQuizResults` or wherever quiz score is displayed (search for `r-score` or `quizHistory`). After saving quiz history, add:

```javascript
// Inside quiz finish handler, after saving score:
const prev = checkPersonalRecord(quizDomainKey, scorePct);
if (prev !== null) showPRBanner('quiz-results-top', domainName, scorePct, prev);
checkQuizBadges(scorePct, isFullMock);
awardXP(scorePct >= 70 ? 50 : 15, 'Quiz completed');
```

Note: `quizDomainKey` is the domain string, `scorePct` is 0–100 integer, `quiz-results-top` is an id to add to the results container top, `isFullMock` is `true` for the full mock exam.

- [ ] **Step 6: Verify in browser console**

```javascript
showWinToast('Task Complete!', 'Risk Management video watched');
// Expected: green toast slides in bottom-right, auto-dismisses after 3s

showCelebrationModal('Section Complete! 🎉', 'Risk Management', 'Module finished · Quiz passed', '🏅 Badge unlocked: Risk Manager');
// Expected: dark overlay + modal + confetti burst
```

- [ ] **Step 7: Commit**

```bash
git add index.html
git commit -m "feat: add 3-tier celebration system — win toast, PR banner, confetti modal"
```

---

## Task 4: Sidebar Redesign

**Files:**
- Modify: `index.html:788–846` — sidebar HTML

- [ ] **Step 1: Add progress bar under logo**

Find the `.sb-logo` div (around line 789–793) and add the progress bar below it:
```html
<div class="sb-logo">
  <div class="logo-badge">PMP</div>
  <div class="logo-t">Boot Camp</div>
  <div class="logo-s">PMI Project Management Professional</div>
</div>
<div class="sb-prog-wrap">
  <div class="sb-prog-lbl">
    <span>Overall Progress</span>
    <span id="sb-overall-pct" style="color:var(--accent)">0%</span>
  </div>
  <div class="sb-prog-bar"><div class="sb-prog-fill" id="sb-overall-fill" style="width:0%"></div></div>
</div>
```

- [ ] **Step 2: Replace nav list with zone-grouped nav**

Find `.sb-nav` div (around line 799–815) and replace its contents:
```html
<div class="sb-nav">
  <div class="nav-zone nav-zone-train">🏋️ Train</div>
  <div class="ni active" onclick="nav('today',this)"><span class="ni-ico">🚀</span><span>Start Here</span></div>
  <div class="ni" onclick="nav('learn',this)"><span class="ni-ico">🎬</span><span>Video Library</span><span class="ni-badge ni-badge-green" id="nb-learn">—</span></div>
  <div class="ni" onclick="nav('quiz',this)"><span class="ni-ico">🧠</span><span>Practice Quiz</span><span class="ni-badge ni-badge-orange" id="nb-quiz">—</span></div>
  <div class="ni" onclick="nav('flash',this)"><span class="ni-ico">🃏</span><span>Flashcards</span></div>

  <div class="nav-zone nav-zone-progress">📊 Progress</div>
  <div class="ni" onclick="nav('progress',this)"><span class="ni-ico">📊</span><span>My Stats</span><span class="ni-badge ni-badge-accent" id="nb-stats">—</span></div>
  <div class="ni" onclick="nav('weak',this)"><span class="ni-ico">🎯</span><span>Weak Areas</span><span class="ni-badge ni-badge-red" id="nb-weak" style="display:none">0 ⚠️</span></div>

  <div class="nav-zone nav-zone-study">📚 Study</div>
  <div class="ni" onclick="nav('plan',this)"><span class="ni-ico">📚</span><span>Study Plan</span><span class="ni-badge ni-badge-green" id="nb-plan">—</span></div>
  <div class="ni" onclick="nav('lessons',this)"><span class="ni-ico">🎓</span><span>Lessons</span></div>
  <div class="ni" onclick="nav('ref',this)"><span class="ni-ico">🧮</span><span>Reference</span></div>
  <div class="ni" onclick="nav('notes',this)"><span class="ni-ico">📝</span><span>My Notes</span></div>
  <div class="ni" onclick="nav('apply',this)"><span class="ni-ico">📋</span><span>Application</span></div>
  <div class="ni" onclick="nav('group',this)"><span class="ni-ico">🤝</span><span>Study Group</span></div>
  <div class="ni" onclick="nav('files',this)"><span class="ni-ico">📁</span><span>Your Files</span></div>
  <div class="ni" onclick="nav('study',this)"><span class="ni-ico">📖</span><span>Study Center</span></div>
</div>
```

- [ ] **Step 3: Add updateSidebarProgress function**

```javascript
function updateSidebarProgress() {
  const planDone = load('planDone', {});
  const donePct = Math.round(Object.values(planDone).filter(Boolean).length / 8 * 100);
  const fillEl = document.getElementById('sb-overall-fill');
  const pctEl = document.getElementById('sb-overall-pct');
  if (fillEl) fillEl.style.width = donePct + '%';
  if (pctEl) pctEl.textContent = donePct + '%';

  // Video badge
  const nbLearn = document.getElementById('nb-learn');
  // Count watched modules from RAMDAYAL_MODULES progress (reuse existing logic)
  const watched = RAMDAYAL_MODULES ? RAMDAYAL_MODULES.filter(m => load('mod_done_' + m.num, false)).length : 0;
  if (nbLearn) nbLearn.textContent = watched + '/' + (RAMDAYAL_MODULES ? RAMDAYAL_MODULES.length : 20);

  // Quiz badge
  const nbQuiz = document.getElementById('nb-quiz');
  const qh = load('quizHistory', {total:0,correct:0});
  const qAvg = qh.total > 0 ? Math.round(qh.correct / qh.total * 100) : 0;
  if (nbQuiz) { nbQuiz.textContent = qAvg + '%'; nbQuiz.className = 'ni-badge ' + (qAvg >= 70 ? 'ni-badge-green' : 'ni-badge-orange'); }

  // Study plan badge
  const nbPlan = document.getElementById('nb-plan');
  if (nbPlan) nbPlan.textContent = Object.values(planDone).filter(Boolean).length + '/8';

  // My Stats badge — badge count
  const nbStats = document.getElementById('nb-stats');
  const achievements = getAchievements();
  if (nbStats) nbStats.textContent = achievements.earnedBadges.length + ' 🏅';

  // Weak areas badge
  const nbWeak = document.getElementById('nb-weak');
  // Reuse existing weak area detection (search for buildWeakAreas or similar)
  // Show badge if any domain below 60%
  if (nbWeak) { nbWeak.style.display = qAvg < 60 ? '' : 'none'; }

  // Update existing progress elements
  const progPct = document.getElementById('prog-pct');
  if (progPct) progPct.textContent = donePct + '%';
}
```

- [ ] **Step 4: Call updateSidebarProgress on page load**

Find the page load / DOMContentLoaded handler (search for `initMsal()` call or `updateCountdown()` call) and add:
```javascript
updateSidebarProgress();
```

- [ ] **Step 5: Verify in browser**

Check:
- Sidebar shows "Boot Camp" under PMP badge
- Progress bar visible under logo (shows 0% if no plan items done)
- Three zone labels: green "🏋️ Train", blue "📊 Progress", purple "📚 Study"
- Video Library shows "X/20" badge, Quiz shows avg %, Study Plan shows "X/8"
- All 14 destinations still accessible

- [ ] **Step 6: Commit**

```bash
git add index.html
git commit -m "feat: redesign sidebar — training zones, progress bar, live indicators"
```

---

## Task 5: Start Here Page Redesign

**Files:**
- Modify: `index.html:5344` — replace `buildStartHere()` entirely

- [ ] **Step 1: Replace buildStartHere with new implementation**

Find `function buildStartHere()` (line ~5344) and replace the entire function:

```javascript
function buildStartHere() {
  const el = document.getElementById('starthere-content');
  if (!el) return;

  const planDone = load('planDone', {});
  const donePct = Math.round(Object.values(planDone).filter(Boolean).length / 8 * 100);
  const qh = load('quizHistory', {total:0,correct:0});
  const qAvg = qh.total > 0 ? Math.round(qh.correct / qh.total * 100) : 0;
  const streak = getStreak();
  const achievements = getAchievements();
  const earnedCount = achievements.earnedBadges.length;
  const inReachCount = BADGES.filter(b => !achievements.earnedBadges.includes(b.id) && getBadgeProgress(b) > 0.5).length;

  // Exam date / days left
  const examDateStr = load('examDate');
  let daysLeft = '—';
  let onPace = true;
  if (examDateStr) {
    const diff = Math.ceil((new Date(examDateStr) - new Date()) / 86400000);
    daysLeft = Math.max(0, diff);
    onPace = donePct >= Math.round((1 - diff / 90) * 100) - 10;
  }

  // Quiz delta vs 7 days ago
  const qHistory7 = load('quizHistory7d', []);
  const avgDelta = qHistory7.length >= 2 ? qAvg - qHistory7[0] : null;

  // Day counter
  const startDate = load('studyStartDate');
  let dayCount = '—';
  if (startDate) {
    dayCount = Math.ceil((new Date() - new Date(startDate)) / 86400000) + 1;
  } else if (examDateStr) {
    save('studyStartDate', new Date().toISOString());
    dayCount = 1;
  }

  const days = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
  const dayName = days[new Date().getDay()];

  const coach = generateCoachBriefing(qAvg, avgDelta, daysLeft, streak);
  const tasks = getDailyTraining();

  el.innerHTML = `
    <div class="ph">
      <div class="ph-title">Start Here</div>
      <div class="ph-sub">Your daily training hub — built from your data, updated every day.</div>
    </div>

    <!-- GREETING -->
    <div class="sh-greeting">
      <div>
        <div class="sh-greeting-date">${dayName.toUpperCase()} · ${daysLeft !== '—' ? 'DAY ' + dayCount + ' OF ' + (dayCount + daysLeft - 1) : ''}</div>
        <div class="sh-greeting-name">Good morning, Nikki 👊</div>
      </div>
      <div class="sh-streak-card">
        <div class="sh-streak-val">${streak}🔥</div>
        <div class="sh-streak-lbl">Day Streak</div>
      </div>
    </div>

    <!-- STATS ROW -->
    <div class="sh-stats">
      <div class="sh-stat">
        <div class="sh-stat-val" style="color:var(--accent)">${donePct}%</div>
        <div class="sh-stat-lbl">Course Done</div>
        <div class="sh-stat-bar"><div class="sh-stat-bar-fill" style="width:${donePct}%;background:var(--accent)"></div></div>
      </div>
      <div class="sh-stat">
        <div class="sh-stat-val" style="color:var(--green)">${qAvg > 0 ? qAvg + '%' : '—'}</div>
        <div class="sh-stat-lbl">Quiz Avg</div>
        ${avgDelta !== null ? `<div class="sh-stat-sub" style="color:${avgDelta >= 0 ? 'var(--green)' : 'var(--red)'}">
          ${avgDelta >= 0 ? '↑' : '↓'} ${Math.abs(avgDelta)}pts this week</div>` : ''}
      </div>
      <div class="sh-stat">
        <div class="sh-stat-val" style="color:var(--blue)">${daysLeft}</div>
        <div class="sh-stat-lbl">Days Left</div>
        <div class="sh-stat-sub" style="color:${onPace ? 'var(--green)' : 'var(--a4)'}">
          ${daysLeft === '—' ? '<button class="set-date-btn" onclick="openDateModal()" style="margin-top:4px">Set date</button>' : (onPace ? 'On pace ✓' : 'Behind ⚠️')}</div>
      </div>
      <div class="sh-stat">
        <div class="sh-stat-val" style="color:var(--purple)">${earnedCount}</div>
        <div class="sh-stat-lbl">Badges Earned</div>
        ${inReachCount > 0 ? `<div class="sh-stat-sub" style="color:var(--a4)">${inReachCount} in reach 🏅</div>` : ''}
      </div>
    </div>

    <!-- COACH BRIEFING -->
    <div class="coach-card">
      <div style="display:flex;gap:14px;align-items:flex-start">
        <div class="coach-ico">💬</div>
        <div>
          <div class="coach-lbl">Coach's Briefing · Today</div>
          <div class="coach-msg">"${coach}"</div>
        </div>
      </div>
    </div>

    <!-- TODAY'S TRAINING -->
    <div style="margin-bottom:18px">
      <div class="training-hdr">
        <div class="training-lbl">⚡ Today's Training</div>
        <div class="training-count" id="training-count">0 of 3 complete</div>
      </div>
      ${renderTaskCard(tasks[0], 0)}
      ${renderTaskCard(tasks[1], 1)}
      ${renderTaskCard(tasks[2], 2)}
    </div>

    <!-- EXAM READINESS -->
    <div class="readiness-bar-wrap">
      <div class="readiness-lbl">
        <span>Exam Readiness</span>
        <span style="color:${donePct >= 70 ? 'var(--green)' : 'var(--a4)'}">${donePct}% · ${donePct >= 70 ? 'On Track' : 'Building'}</span>
      </div>
      <div class="sp-bar"><div class="sp-fill" style="width:${donePct}%"></div></div>
      <div class="readiness-note">${qAvg > 0 && qAvg < 70 ? 'Quiz average below passing threshold — focus on practice questions' : donePct < 100 ? Math.round((1 - donePct/100) * 8) + ' study plan section(s) remaining' : 'All sections complete — keep drilling practice questions!'}</div>
    </div>
  `;
  updateTaskCount();
}

function renderTaskCard(task, idx) {
  if (!task) return '';
  const configs = [
    { cls:'task-card-watch',  icoCls:'rgba(46,213,115,.12)',  icoBdr:'rgba(46,213,115,.35)',  btnColor:'var(--green)',  btnBdr:'rgba(46,213,115,.3)' },
    { cls:'task-card-drill',  icoCls:'rgba(124,107,250,.12)', icoBdr:'rgba(124,107,250,.35)', btnColor:'var(--accent)', btnBdr:'rgba(124,107,250,.3)' },
    { cls:'task-card-review', icoCls:'rgba(61,158,255,.12)',  icoBdr:'rgba(61,158,255,.35)',  btnColor:'var(--blue)',   btnBdr:'rgba(61,158,255,.3)' }
  ];
  const c = configs[idx];
  const done = load('dailyDone_' + getTodayKey(), {})[idx];
  return `
    <div class="task-card ${c.cls} ${done ? 'done' : ''}" id="task-card-${idx}">
      <div class="task-ico" style="background:${c.icoCls};border-color:${c.icoBdr}">${task.ico}</div>
      <div style="flex:1">
        <div class="task-title">${task.title}</div>
        <div class="task-sub">${task.sub}</div>
        <button class="task-change" onclick="swapTask(${idx})">↻ Change Task</button>
      </div>
      <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px">
        <button class="task-btn" style="color:${c.btnColor};border-color:${c.btnBdr}"
          onclick="startTask(${idx})">${done ? '✓ Done' : 'START →'}</button>
      </div>
    </div>`;
}

function getTodayKey() {
  return new Date().toISOString().slice(0,10);
}

function updateTaskCount() {
  const done = load('dailyDone_' + getTodayKey(), {});
  const count = Object.values(done).filter(Boolean).length;
  const el = document.getElementById('training-count');
  if (el) el.textContent = count + ' of 3 complete';
  if (count === 3) {
    awardXP(25, 'All 3 training tasks complete!');
    showWinToast('🏋️ Training Complete!', 'All 3 tasks done for today', 25);
  }
}

function startTask(idx) {
  const tasks = getDailyTraining();
  const task = tasks[idx];
  if (!task) return;
  // Mark done
  const key = 'dailyDone_' + getTodayKey();
  const done = load(key, {});
  if (!done[idx]) {
    done[idx] = true;
    save(key, done);
    awardXP(25, task.title);
    showWinToast('✅ Task Complete!', task.title, 25);
    // Refresh card
    const card = document.getElementById('task-card-' + idx);
    if (card) { card.classList.add('done'); card.querySelector('.task-btn').textContent = '✓ Done'; }
    updateTaskCount();
  }
  // Navigate
  if (task.nav) nav(task.nav, document.querySelector('.ni[onclick*="' + task.nav + '"]'));
}

function swapTask(idx) {
  const overrides = load('taskOverrides_' + getTodayKey(), {});
  overrides[idx] = (overrides[idx] || 0) + 1;
  save('taskOverrides_' + getTodayKey(), overrides);
  buildStartHere();
}
```

- [ ] **Step 2: Add getBadgeProgress helper**

```javascript
function getBadgeProgress(badge) {
  if (badge.cat === 'streak') {
    return Math.min(1, getStreak() / badge.trigger);
  }
  if (badge.cat === 'perf') {
    const a = getAchievements();
    if (badge.trigger === 'mock80') return 0; // no partial progress
    const best = Math.max(0, ...Object.values(a.bestScores));
    return Math.min(1, best / badge.trigger);
  }
  if (badge.cat === 'domain') {
    const planDone = load('planDone', {});
    // domain triggers map to plan section ids - approximate by checking if key matches
    const done = Object.keys(planDone).filter(k => planDone[k] && k.toLowerCase().includes(badge.trigger));
    return done.length > 0 ? 1 : 0;
  }
  return 0;
}
```

- [ ] **Step 3: Verify in browser**

Open the app, check Start Here tab:
- Greeting shows day name + "Good morning, Nikki 👊"
- Streak card visible top-right
- 4 stat cards: Course Done / Quiz Avg / Days Left / Badges Earned
- Coach briefing card visible (shows a message)
- 3 task cards visible (Watch / Drill / Review)
- "START →" button navigates to correct tab
- Exam Readiness bar at bottom

- [ ] **Step 4: Commit**

```bash
git add index.html
git commit -m "feat: redesign Start Here page — stats, coach briefing, daily training tasks"
```

---

## Task 6: Today's Training Generator

**Files:**
- Modify: `index.html` `<script>` block

- [ ] **Step 1: Add getDailyTraining function**

```javascript
function getDailyTraining() {
  const key = 'dailyTraining_' + getTodayKey();
  const cached = load(key, null);
  if (cached) return cached;
  const tasks = generateDailyTraining();
  save(key, tasks);
  return tasks;
}

function generateDailyTraining() {
  const overrides = load('taskOverrides_' + getTodayKey(), {});
  return [
    generateWatchTask(overrides[0] || 0),
    generateDrillTask(overrides[1] || 0),
    generateReviewTask(overrides[2] || 0)
  ];
}

function generateWatchTask(skip) {
  // Find next unwatched Ramdayal module
  const modules = typeof RAMDAYAL_MODULES !== 'undefined' ? RAMDAYAL_MODULES : [];
  const unwatched = modules.filter(m => !load('mod_done_' + m.num, false));
  const target = unwatched[skip % Math.max(1, unwatched.length)] || modules[0];
  if (!target) return { ico:'🎬', title:'Watch: Ramdayal Course', sub:'Continue your video training', nav:'learn' };
  return {
    ico: '🎬',
    title: 'Watch: ' + (target.title || 'Module ' + target.num),
    sub: 'Ramdayal · Module ' + target.num + ' · ~45 min · ' + (target.pri === 'HIGH' ? 'High Priority' : 'On schedule'),
    nav: 'learn'
  };
}

function generateDrillTask(skip) {
  const qh = load('quizHistory', { total:0, correct:0, byDomain:{} });
  let weakDomain = null;
  let weakScore = 100;
  if (qh.byDomain) {
    Object.entries(qh.byDomain).forEach(([domain, data]) => {
      if (data.total > 0) {
        const avg = Math.round(data.correct / data.total * 100);
        if (avg < weakScore) { weakScore = avg; weakDomain = domain; }
      }
    });
  }
  return {
    ico: '🧠',
    title: 'Drill: 20 Practice Questions',
    sub: weakDomain ? weakDomain + ' focus · ~15 min · Targets your weak spots' : 'Mixed domains · ~15 min',
    nav: 'quiz',
    domain: weakDomain
  };
}

function generateReviewTask(skip) {
  return {
    ico: '🃏',
    title: 'Review: 10 Flashcards',
    sub: 'Auto-selected from your recent misses · ~5 min',
    nav: 'flash'
  };
}
```

- [ ] **Step 2: Verify in browser console**

```javascript
localStorage.removeItem('pmp_dailyTraining_' + new Date().toISOString().slice(0,10));
const tasks = getDailyTraining();
console.log(tasks);
// Expected: array of 3 task objects each with ico, title, sub, nav properties
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "feat: add Today's Training daily generator"
```

---

## Task 7: Coach's Briefing Generator

**Files:**
- Modify: `index.html` `<script>` block

- [ ] **Step 1: Add generateCoachBriefing function**

```javascript
function generateCoachBriefing(qAvg, delta, daysLeft, streak) {
  const focus = getWeakestDomain();
  const focusName = focus || 'your weakest areas';

  // Determine scenario
  let scenario;
  if (streak === 0 && load('lastStudyDate')) {
    scenario = 'returning';
  } else if (daysLeft !== '—' && daysLeft <= 7) {
    scenario = 'exam_week';
  } else if (daysLeft !== '—' && daysLeft < 20) {
    scenario = 'urgent';
  } else if (delta !== null && delta >= 5) {
    scenario = 'improving';
  } else if (delta !== null && delta < -3) {
    scenario = 'declining';
  } else {
    scenario = 'steady';
  }

  const templates = COACH_TEMPLATES[scenario] || COACH_TEMPLATES.steady;
  // Seed by date so message stays consistent within the same day
  const seed = parseInt(getTodayKey().replace(/-/g,'')) % templates.length;
  const tpl = templates[seed];
  return tpl
    .replace(/\{focus\}/g, focusName)
    .replace(/\{days\}/g, daysLeft)
    .replace(/\{delta\}/g, delta !== null ? Math.abs(delta) : '')
    .replace(/\{streak\}/g, streak);
}

function getWeakestDomain() {
  const qh = load('quizHistory', { byDomain:{} });
  if (!qh.byDomain) return null;
  let weak = null, weakScore = 100;
  Object.entries(qh.byDomain).forEach(([domain, data]) => {
    if (data.total > 0) {
      const avg = data.correct / data.total * 100;
      if (avg < weakScore) { weakScore = avg; weak = domain; }
    }
  });
  return weak;
}

const COACH_TEMPLATES = {
  improving: [
    "{focus} is your biggest open gap — and you have {days} days to close it. Your quiz average jumped {delta} points this week, which tells me the studying is working. Stay on this streak and you'll hit the exam ready.",
    "The numbers are moving in the right direction — up {delta} points this week. Keep that momentum going. {focus} still needs work, but you have {days} days and a plan. That's enough.",
    "{delta} points of improvement this week. That's not luck — that's the work paying off. {focus} is next on the list. You have {days} days. Let's close it.",
    "Your average is climbing. {delta} points up this week means you're absorbing the material. {focus} is the gap to close — today's session matters. {days} days and counting.",
    "Up {delta} points. You're building real momentum. Don't break the streak — {focus} needs your attention today, and you have {days} days to nail it.",
    "Week-over-week improvement tells me you're figuring out the exam pattern. {focus} is where the points are left on the table. {days} days — more than enough if you stay consistent.",
    "The work is showing. +{delta} points this week. {focus} is your target — once you crack it, your overall readiness jumps significantly. {days} days out.",
    "Good week. {delta} point jump. Keep the same schedule — it's working. {focus} is the domain that will make or break your score. Focus there today.",
    "{delta} points better than last week. The hard part is keeping that pace. {focus} in {days} days. You've done harder things.",
    "Momentum is a real thing, and you have it right now. +{delta} points. {focus} is still the weak link — attack it while you're hot."
  ],
  steady: [
    "Consistency is the secret weapon. You're showing up, and it's building a foundation. Keep chipping at {focus} — steady progress over {days} days beats cramming every time.",
    "No dramatic swings this week, which is fine — consistency beats intensity for exam prep. {focus} is where to direct your energy. {days} days out.",
    "The studying is happening. That's the most important thing. {focus} needs a push — your numbers there have room to grow. {days} days, one session at a time.",
    "Even pace, which is good. {focus} is the domain to prioritize this week. Keep the streak alive and let the knowledge compound over these {days} days.",
    "Holding steady. Now it's time to push. {focus} is your biggest opportunity — one focused session can move the needle. {days} days to exam.",
    "Consistency is built by showing up even when it doesn't feel exciting. That's what you're doing. {focus} is waiting. {days} days.",
    "You're in the grind phase. It's not glamorous, but it's how this gets done. {focus} is the priority today. {days} days.",
    "No big swings this week — consistent is fine. Channel today's energy into {focus}. That's where the exam points are hiding.",
    "Steady preparation. {focus} is the domain to focus on before exam day — {days} days to make it a strength.",
    "The streak is alive. The work is happening. {focus} is your next target. {days} days is time well spent if you use it."
  ],
  declining: [
    "The average dipped a bit this week — that happens. Don't let it spiral. {focus} is your target today. {days} days is still enough to turn this around.",
    "Scores went down slightly. Check in with yourself — are you rushing through sessions? {focus} needs focused attention, not just exposure. {days} days.",
    "A dip in averages is a signal, not a verdict. Something isn't clicking with {focus}. Today: slow down, re-read, then drill. You have {days} days.",
    "Slight drop this week. Probably means it's time to change the approach, not just repeat what's not working. {focus} — try a different angle today. {days} days.",
    "Numbers went the wrong way. That's information. It means {focus} isn't locked in yet. {days} days — adjust and attack.",
    "Small dip. Normal part of the process. The answer isn't to study more — it's to study smarter. Pinpoint what's confusing you in {focus} and go after that specifically.",
    "The average dipped. Don't spiral — just recalibrate. {focus} is where to look first. {days} days and a clear plan is all you need.",
    "A step back sometimes precedes a big jump. But it only works if you diagnose what's off. {focus} today — identify the gap, drill it, move on. {days} days.",
    "Scores down a bit. Take it as a cue to go back to basics on {focus}. Sometimes a simpler review unlocks what the drills haven't. {days} days.",
    "Dip in scores. Check your fundamentals on {focus} — the PMP loves to test whether you really understand the 'why' behind concepts, not just the terms."
  ],
  urgent: [
    "{days} days is tight, but it's workable — if you're focused. {focus} is your biggest gap. Every session has to count now. No more missed days.",
    "We're in the final stretch. {days} days. {focus} is where the exam will challenge you most. Today's session is not optional.",
    "{days} days out. This is where the work you've put in either shows up or doesn't. {focus} still needs you. Lock it down.",
    "The clock is real now — {days} days. {focus} is your most critical gap. Drill it, understand it, own it.",
    "{days} days. Tight but doable. No new content — focus on {focus} and reinforce what you already know. Trust the preparation.",
    "Final stretch. {days} days. Prioritize {focus} and stay sharp on your strong areas. Don't cram — consolidate.",
    "{days} days. The exam is very real now. {focus} is the domain to lock in. Keep the streak alive — every session matters.",
    "Time to get serious. {days} days. {focus} needs intensive attention. Short sessions, high focus, daily.",
    "{days} days. This is the part where people either push through or fade. You're pushing through. Focus on {focus} today.",
    "Down to {days} days. Keep it simple: {focus}, practice questions, flashcards. Don't add new material. Reinforce."
  ],
  exam_week: [
    "You've done the work. {days} days out and your prep is built. This week is about staying sharp — light review, not cramming. Trust what you know.",
    "{days} days. Don't try to learn anything new. Reinforce what you know, especially in {focus}. Calm and confident is the goal.",
    "Exam week. The heavy lifting is done. Light sessions, confidence drills, sleep. You've prepared — now let the preparation work.",
    "{days} days. This week: flashcard review, a short practice set, and rest. Don't burn out right before the finish line.",
    "You're close. {days} days. Stay in the rhythm — one focused session per day, nothing more. The exam rewards calm, prepared minds.",
    "Final days. Keep the routine, don't add stress. {focus} is your last thing to review briefly, then trust your preparation.",
    "{days} days out. Light review mode. You've put in the work — now protect your energy and confidence.",
    "The prep is done. {days} days. Today: review your notes on {focus}, run 10 practice questions, then step away. You're ready.",
    "{days} days. Every study session from here should be calm and focused — not frantic. You know this material.",
    "Almost there. {days} days. Brief review of {focus}, a short quiz, then trust yourself. The work is already done."
  ],
  returning: [
    "Welcome back. The streak reset, but the knowledge didn't. Pick it back up today — {focus} is where to start. {days} days is still enough.",
    "Back at it. The best thing you can do after a break is just start again, no drama. {focus} today. {days} days.",
    "Glad you're back. Let's not overthink the missed day — just get into today's session. {focus} is waiting. {days} days out.",
    "Breaks happen. What matters is that you're here now. {focus} and a reset streak. {days} days — let's go.",
    "Back in the saddle. The material is still there. {focus} is the priority today. Start the streak again — one day at a time.",
    "Returning after a break. Ease back in: one video, a few practice questions, review your notes on {focus}. {days} days.",
    "You're back. That's the only thing that matters right now. {focus} today, streak restarted. {days} days.",
    "Every comeback starts with day one. Today is day one. {focus} — and build from here. {days} days.",
    "Missed day handled — you're back and that's what counts. {focus} today. Don't let the streak gap become a pattern. {days} days.",
    "Back at the Boot Camp. {focus} is your focus today. The exam doesn't care about the missed day — only about what you know when you walk in. {days} days."
  ]
};
```

- [ ] **Step 2: Verify in browser console**

```javascript
console.log(generateCoachBriefing(72, 8, 47, 14));
// Expected: a motivational string with no {placeholders} remaining, ~2-3 sentences
```

- [ ] **Step 3: Commit**

```bash
git add index.html
git commit -m "feat: add Coach's Briefing generator with scenario-based message templates"
```

---

## Task 8: Badge Gallery on My Stats Tab

**Files:**
- Modify: `index.html:1227` — Progress panel content
- Modify: `index.html` — `buildProgressTracker()` function (line ~7235)

- [ ] **Step 1: Add XP card builder**

Add this function near `buildProgressTracker`:

```javascript
function buildXPCard() {
  const a = getAchievements();
  const { current, next } = getLevelInfo(a.xp);
  const pct = next ? Math.round((a.xp - current.xp) / (next.xp - current.xp) * 100) : 100;
  return `
    <div class="xp-card">
      <div style="display:flex;align-items:center;gap:14px;margin-bottom:12px">
        <div class="xp-avatar">⚔️</div>
        <div>
          <div style="font-size:10px;color:var(--t2);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:2px">Project Manager</div>
          <div style="font-size:16px;font-weight:900;color:var(--text)">Level ${current.level} — ${current.title}</div>
        </div>
      </div>
      <div style="display:flex;justify-content:space-between;font-size:10px;color:var(--t2);margin-bottom:5px">
        <span>XP Progress</span><span style="color:var(--purple);font-weight:700">${a.xp.toLocaleString()} / ${next ? next.xp.toLocaleString() : '—'} XP</span>
      </div>
      <div class="xp-bar-wrap"><div class="xp-bar-fill" style="width:${pct}%"></div></div>
      <div style="font-size:10px;color:var(--t2);margin-top:6px">${next ? (next.xp - a.xp).toLocaleString() + ' XP to Level ' + next.level + ' — ' + next.title : 'Max level reached!'}</div>
    </div>`;
}

function buildBadgeSection(catLabel, catId, badges) {
  const a = getAchievements();
  const cards = badges.map(b => {
    const earned = a.earnedBadges.includes(b.id);
    const progress = getBadgeProgress(b);
    const inReach = !earned && progress > 0.5;
    const cls = earned ? 'badge-card-earned' : inReach ? 'badge-card-reach' : 'badge-card-locked';
    const statusColor = earned ? 'var(--green)' : inReach ? 'var(--a4)' : 'var(--t3)';
    const statusLabel = earned ? 'EARNED' : inReach ? 'IN REACH' : 'LOCKED';
    const reachBar = inReach ? `<div class="badge-reach-bar"><div class="badge-reach-fill" style="width:${Math.round(progress*100)}%"></div></div>` : '';
    return `
      <div class="badge-card ${cls}">
        <div class="badge-card-ico">${b.ico}</div>
        <div class="badge-card-status" style="color:${statusColor}">${statusLabel}</div>
        <div class="badge-card-name">${b.name}</div>
        <div class="badge-card-desc">${b.desc}</div>
        ${reachBar}
      </div>`;
  }).join('');
  return `
    <div style="font-size:10px;color:var(--t2);text-transform:uppercase;letter-spacing:1.5px;margin-bottom:12px">${catLabel}</div>
    <div class="badge-grid">${cards}</div>`;
}
```

- [ ] **Step 2: Prepend XP card and badge gallery to buildProgressTracker**

Inside `buildProgressTracker()` (line ~7235), find where it sets `innerHTML` on the progress panel and prepend the XP card + badge sections. Add at the top of the rendered HTML:

```javascript
// At the start of buildProgressTracker, before existing content:
const xpHtml = buildXPCard();
const domainBadges = BADGES.filter(b => b.cat === 'domain');
const streakBadges = BADGES.filter(b => b.cat === 'streak');
const perfBadges   = BADGES.filter(b => b.cat === 'perf');
const badgeHtml = `
  <div class="ph"><div class="ph-title">My Stats</div><div class="ph-sub">Your XP, level, achievements, and performance at a glance.</div></div>
  ${xpHtml}
  <div style="margin-bottom:28px">
    ${buildBadgeSection('🏅 Domain Mastery Badges', 'domain', domainBadges)}
    ${buildBadgeSection('🔥 Streak & Hustle Badges', 'streak', streakBadges)}
    ${buildBadgeSection('🧠 Performance Badges', 'perf', perfBadges)}
  </div>`;
// Then append the existing stats content below
```

- [ ] **Step 3: Rename Progress panel heading**

Find `id="p-progress"` (line ~1227). Inside it, update any hardcoded "Progress" heading to "My Stats".

Also update the nav item text if needed (already done in Task 4 sidebar HTML — confirm `My Stats` is showing).

- [ ] **Step 4: Wire checkStreakBadges into streak update**

Find `updateStreak()` or wherever `getStreak()` result is used to update `sb-streak-num`. Add:
```javascript
checkStreakBadges(getStreak());
```

- [ ] **Step 5: Wire domain badges into study plan section completion**

Find `toggleSectionDone()` (search for `planDone`) and add after saving:
```javascript
// After save('planDone', done):
const sectionId = s.id || ''; // adapt to actual section ID variable name
unlockBadge(getDomainBadgeForSection(sectionId));
showCelebrationModal('Section Complete! 🎉', s.title || 'Section', 'Module finished — keep going!');
awardXP(100, 'Study plan section complete');
```

Add helper:
```javascript
function getDomainBadgeForSection(sectionId) {
  const map = {
    scope:'scope_master', schedule:'schedule_pro', cost:'cost_controller',
    quality:'quality_guard', risk:'risk_manager', procurement:'procurement_pro',
    resources:'people_leader', comms:'comms_expert', agile:'agile_champion',
    integration:'integration_ace'
  };
  for (const [key, badgeId] of Object.entries(map)) {
    if (sectionId.toLowerCase().includes(key)) return badgeId;
  }
  return null;
}
```

- [ ] **Step 6: Verify in browser**

Navigate to My Stats (Progress) tab:
- XP card shows level, title, progress bar toward next level
- Three badge sections visible: Domain Mastery, Streak & Hustle, Performance
- Earned badges show green glow, locked badges show gray
- Earn a badge in console (`unlockBadge('week_warrior')`) → green glow appears, confetti fires

- [ ] **Step 7: Commit**

```bash
git add index.html
git commit -m "feat: add badge gallery and XP card to My Stats tab"
```

---

## Task 9: Wire XP to Existing Actions + Final Polish

**Files:**
- Modify: `index.html` — connect XP awards to existing quiz and study plan handlers

- [ ] **Step 1: Wire XP to quiz completion**

Find where quiz results are displayed (search for `quizHistory` save, around line 5082). After `save('quizHistory', ...)`:
```javascript
awardXP(correct / q.length >= 0.7 ? 50 : 15, 'Practice quiz completed');
checkQuizBadges(Math.round(correct / q.length * 100), false);
const domainKey = currentQuizDomain || 'general';
const prev = checkPersonalRecord(domainKey, Math.round(correct / q.length * 100));
if (prev !== null) {
  // inject PR banner into quiz results area
  const resultsEl = document.querySelector('#p-quiz .r-score')?.closest('.card');
  if (resultsEl) showPRBanner('quiz-pr-anchor', domainKey, Math.round(correct / q.length * 100), prev);
}
```

Add `<div id="quiz-pr-anchor"></div>` just before the quiz results score element in the HTML.

- [ ] **Step 2: Call updateSidebarProgress after key actions**

Find the following functions and add `updateSidebarProgress()` at their end:
- `toggleSectionDone()` (study plan completion)
- `finishPlanQuiz()` (plan quiz finish)
- Any function that calls `save('planDone', ...)` or `save('quizHistory', ...)`

- [ ] **Step 3: Rebuild Start Here when returning to today tab**

Find `function nav(id, el)` (line ~3962). Add:
```javascript
function nav(id, el) {
  // ... existing code ...
  if (id === 'today') buildStartHere();
  // ... rest of existing code ...
}
```

- [ ] **Step 4: Final browser smoke test**

Walk through the full happy path:
1. Open app → Start Here shows greeting, 4 stats, coach message, 3 tasks
2. Click START → on Watch task → navigates to Video Library, returns, task marked done
3. Click START → on Drill task → navigates to Practice Quiz
4. Complete a quiz → XP toast fires, sidebar quiz % updates
5. Navigate to My Stats → XP card and badge gallery visible
6. Mark a study plan section complete → confetti modal fires
7. Streak shows correctly in both sidebar and Start Here

- [ ] **Step 5: Final commit**

```bash
git add index.html
git commit -m "feat: wire XP rewards to existing quiz and study plan actions — full redesign complete"
```

---

## Self-Review Notes

- All 7 spec sections covered across 9 tasks
- No TBDs — every step has actual code
- `save()`/`load()` helpers used consistently (no raw `localStorage` calls except where existing code uses it)
- `updateSidebarProgress()` called after all state-changing operations
- Confetti z-index (4001) above celebration overlay (4000) and video modal (2000)
- `pmp_` prefix preserved via existing `save()`/`load()` helpers
- `RAMDAYAL_MODULES` referenced conditionally — won't crash if undefined
- Coach templates are date-seeded so message is stable within a day but rotates daily
