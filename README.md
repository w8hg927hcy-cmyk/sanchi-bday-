# 🌙 Mochi & Moonlight — Birthday Website

A 7-screen interactive birthday surprise. Single `index.html` (CSS + JS inline, no build step, no libraries), plus `config.js` for optional cloud settings.

```
MochiMoonlight_Birthday_Complete/
├─ index.html          ← the whole website
├─ config.js           ← Supabase URL + key (empty = cloud off)
├─ supabase/setup.sql  ← one-time database + storage + security setup
└─ README.md
```

Screens: System Alert → Appreciation → Apology.exe → Moon & Shayari → Roast → **Birthday reveal** (emerald/gold, procedurally drawn snakes, cake, confetti, photo + video) → Goodbye (no replay button).

---

## 1. Run locally

```bash
cd MochiMoonlight_Birthday_Complete
python3 -m http.server 8000
```
Open http://localhost:8000 (visitor view) or http://localhost:8000/?edit=1 (creator view).
Double-clicking `index.html` also works, but a local server is closer to the real thing.

## 2. Deploy on GitHub Pages
1. Create a GitHub repo (e.g. `mochi-moonlight`), upload `index.html`, `config.js`, `README.md`, `supabase/`.
2. Repo → **Settings → Pages** → Source: *Deploy from a branch* → `main` / `/ (root)` → Save.
3. After ~1 minute your link is `https://YOUR-USERNAME.github.io/mochi-moonlight/`. That is the link you send her.
4. Your creator link is the same URL + `?edit=1`.

The page has `noindex` so search engines won't list it. Google Fonts are loaded from the web (with safe fallbacks if blocked).

## 3. Supabase setup (needed so she sees YOUR photo/video)
Without this the site works fully, but photo/video **cannot be saved** and tracking is **off**. Browser storage can't share files between phones, so a real cloud is required. Supabase's free tier is enough.

1. Sign up at https://supabase.com → **New project** (any name/region, save the DB password).
2. **Authentication → Users → Add user → Create new user**: enter *your* email + a strong password, tick *Auto Confirm User*.
3. **Authentication → Sign In / Providers (or Settings)** → turn **OFF "Allow new users to sign up"**. This stops strangers creating accounts.
4. Open `supabase/setup.sql`, replace every `YOUR_EMAIL_HERE` with the email from step 2, paste into **SQL Editor → Run**. This creates the table, the public `birthday-media` bucket, and rules so *only that email* can upload/replace/delete.
5. **Project Settings → API**: copy the **Project URL** and the **anon / publishable** key into `config.js`:
   ```js
   window.MOCHI_CONFIG = { supabaseUrl: "https://xxxx.supabase.co", supabaseAnonKey: "eyJ… or sb_publishable_…", bucket: "birthday-media" };
   ```
   The anon/publishable key is meant to be public. **Never** put the `service_role`/secret key in this file.
6. Commit `config.js` to GitHub.

### Upload from your phone
1. Open `https://…/?edit=1` → tap **Jump to birthday** (top pill / bottom pill).
2. Scroll to the **Creator panel** → sign in with your email + password.
3. Photo: **Choose photo** → preview → adjust zoom/position (or drag) → **Save photo**.
4. Video: **Choose video** → preview → **Save video** (progress bar shown).
5. Open the normal link (no `?edit=1`) in a private tab to see exactly what she'll see.

**Size limit:** this site imposes none, but Supabase's **Free plan allows 50 MB per file**. If the server rejects a file you'll see that exact reason. Fix: compress the video (WhatsApp/CapCut export at 720p–1080p) or upgrade and raise the limit in *Storage → Settings*. Free storage totals ~1 GB — check Supabase's pricing page for current numbers.

**Video format:** export **MP4 (H.264)**. iPhone `.MOV` (HEVC) can fail on some Android phones; the creator panel warns you if your browser can't play it.

## 4. Completion tracking (anonymous)
Only two events are stored, each as *event name + server timestamp*: `session_started` and `final_reached` (birthday screen opened). No IP, location, user agent, or click data is saved by the site. (Supabase's own infrastructure logs are outside the site's control.) Creator mode never logs events. To see counts: sign in on `?edit=1` (shown in the creator panel) or open **Table Editor → birthday_events**. If `config.js` is empty, **tracking is not active**.

## 5. What works now vs. needs backend

| Feature | No Supabase | With Supabase |
|---|---|---|
| All 7 screens, animations, snakes, confetti, roast game, cake | ✅ | ✅ |
| Shayari with proper line breaks | ✅ | ✅ |
| Creator mode: pick, preview, crop/zoom, replace/remove (in your browser) | ✅ preview only | ✅ |
| **Saving** photo/video so she sees it | ❌ (clearly labelled "not configured") | ✅ |
| Visitor sees your media on her phone | ❌ (media blocks hidden) | ✅ |
| Only you can upload (login + row/storage policies) | n/a | ✅ |
| Completion tracking | ❌ inactive | ✅ |

Visitors without saved media see a finished page (media cards simply don't appear).

## 6. Customising
All text is plain HTML in `index.html`. The shayari lives in `<p id="shayari">`, one `<span class="line">` per line.
