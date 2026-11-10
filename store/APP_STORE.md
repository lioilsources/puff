# App Store Connect — Puff (English U.S.)

Everything below is ready to paste into App Store Connect. Character counts are
against Apple's limits; recount after any edit.

Bundle id `com.ol1n.puff` · listing name **Puff: Squishy Relaxing Game** (was "Puff: Pressure Blast"; the plain
name "Puff" is taken; `CFBundleDisplayName` stays "Puff" on the home screen).

---

## ASO — 1.2.2 (October 2026)

App Store Connect, 12 months to 2026-10-29: 3 205 impressions (USA 2 541),
30 product page views, 12 downloads. **0.9 % of impressions open the page**
(USA 0.6 %). The problem is what search results show (icon, name, subtitle,
first screenshots), not the description. Handoff: `PUFF_ASO_PLAN.md`.

What changes, and where it comes from:

| Lever | Change | Source |
|---|---|---|
| Icon | 3 alternates in the build for a Product Page Optimization test; primary unchanged | `tool/gen_alt_icons.py` → `AppIcon-{Blast,Cloud,Shatter}` |
| Screenshots 1–3 | captioned: blast / combo / calm, 10 locales | `tool/gen_store_shots.py`, `store/appstore/captions.json` |
| App preview | 25 s, opens on a blast, no intro | `tool/gen_app_preview.sh` |
| Subtitle + keywords | already in 1.2.0, kept | below |

The primary icon (pineapple and banana on cream) has nothing to do with a
neon physics game, and it is the one thing every impression sees. The test
answers whether that costs taps; if any neon variant wins, make it primary
in the next build (`assets/icon/icon.png` + `dart run flutter_launcher_icons`).

### Name, subtitle, keywords — already in 1.2.0

Read back from App Store Connect on 2026-10-31. The name changed in
App Store Connect after this file was written; the section *App
Information* below is the 1.0 history.

| | Live (1.0.4) | 1.2.0 (waiting for review) |
|---|---|---|
| Name | `Puff: Squishy Relaxing Game` | same |
| Subtitle | `Hold, drag, release, shatter` | `Satisfying Physics Stress Toy` |
| Keywords | `physics,blast,neon,explosion,shatter` | `asmr,calm,fidget,anxiety,relief,chill,neon,shatter,explosion,blast,smash,break,destroy,offline,zen` |

1.2.0 already carries what the handoff asked for (satisfying, stress,
fidget, asmr, calm), so 1.2.2 keeps its subtitle and keywords. Do not
add `relaxing`, `squishy` or `game`: they are in the name and already
indexed. The handoff also suggested `popping` and `bubble`: left out,
Puff pops no bubbles, and a search that lands on the wrong game lowers
conversion instead of raising it. Search popularity was not measured
(that needs Apple Search Ads); after 14 days, check *Analytics → Sources →
App Store Search* and swap the weakest.

### Promotional Text (170)

Live on 1.0.4 since 2026-10-31 (141 chars). 1.0.4 has no music, so no word
about the soundtrack:

```
Hold, drag, release, and watch neon shapes shatter. A calm, satisfying physics toy for one-minute breaks. No ads, no tracking, fully offline.
```

1.2.0 has its own, set before review; keep it:

```
Hold, drag, release, shatter. A neon physics toy for one-minute stress relief — how long do you dare to hold the charge?
```

### What's New (1.2.2)

```
• A fresh look on the App Store.
• Small fixes and polish.
```

### Screenshots

`python3 tool/gen_store_shots.py` → `build/store_shots/<locale>/` (1320x2868,
the 6.9" size; smaller iPhones are scaled from it). Upload them as
**positions 1–3** in front of the existing en-US set; keep the rest. en-GB,
en-CA and en-AU get the en-US captions, de-DE, fr-FR, es-MX, pt-BR, ja and
ko their own. iPad keeps the current uncaptioned set: there are no raw iPad
frames in the repo (`DEVICE_TYPE=…iPad-Pro-13-inch… ./tool/gen_screenshots.sh`
shoots them; then add an iPad canvas to the generator).

A locale without its own screenshots falls back to the primary language
(en-US), so the other nine app languages show English captions, which is
still better than the current uncaptioned frames.

### App preview

`./tool/gen_app_preview.sh` from a normal terminal → look at
`build/app_preview/frames/`, pick the frame just before a big release and
re-cut with `CUT_ONLY=1 START=<seconds>`. Upload
`puff_preview_886x1920.mp4` to en-US, iPhone 6.9". Poster frame: the blast.

### Release order

1. Promotional text: done on 1.0.4 (2026-10-31).
2. Tag `v1.2.2` → CI uploads the build with the alternate icons.
3. New version 1.2.2 in App Store Connect (after 1.2.0 is out of review):
   that build, screenshots, preview, What's New → submit. Subtitle and
   keywords carry over from 1.2.0.
4. Once 1.2.2 is live: *Product Page Optimization → Create test* →
   treatments Blast, Cloud, Shatter (icon) and the captioned set
   (screenshots), 100 % of traffic, all localizations. Run it at least
   14 days.
5. Done when the test runs with ≥ 2 treatments and US page views /
   impressions reach ≥ 3 % (*Analytics → Metrics*, storefront USA; leave
   Czechia out, those are friends).

---

## App Information (once per app)

**Name** (30) — 20 chars

```
Puff: Pressure Blast
```

Fallbacks if the name is refused: `Puff: Neon Pressure`, `Puff: Pressure Physics`.

**Subtitle** (30) — 28 chars

```
Hold, drag, release, shatter
```

Alternates: `Neon pressure physics toy` (25) · `One finger. Every blast.` (24)

**Privacy Policy URL**

```
https://lioilsources.github.io/puff/privacy.html
```

**Category** — Primary: Games → Arcade · Secondary: Games → Action

**Age rating** — 4+. No objectionable content of any kind: no violence toward
characters (abstract geometry only), no gambling, no user-generated content,
no web browsing, no ads, no data collection.

**Content rights** — Contains no third-party content.

---

## Version 1.0 metadata (the page in the screenshot)

### Promotional Text (170) — 166 chars

```
Four environments, five blast modifiers and shapes that break into real shards. Every round asks one question: how long do you dare hold the charge before you let go?
```

### Description (4000) — 3 746 chars

```
Hold. Drag. Release.

Puff is a minimalist neon physics toy. Press anywhere and a pressure cloud grows under your finger. Drag it to where it matters. Let go, and the pressure blows apart the geometry drifting in from the edges toward the core in the middle of the screen. Let one shape reach that core and the run is over.

It all comes down to one question: when do you release?

CHARGE, OVERPRESSURE, REGRET
The longer you hold, the wider the cloud grows and the harder it hits. Hold past the overpressure line and it fizzles instead — no shockwave, no points, and a penalty on top. The rim flickers through the last quarter of the charge, so an overcharge is always your own call and never a surprise. Shapes that drift into the cloud while you are still holding drain the charge back out of it, which turns every long hold into a bet: a bigger blast, or nothing at all.

Nothing is on a timer except you. No cooldown, no ammo, no menu between you and the next release.

FOUR ENVIRONMENTS, ONE CONTROL
The same finger does something different in each of them.
• Vacuum — nothing is damped, so every blast is a slingshot and a shard keeps whatever speed you gave it. Nebula bands, three parallax star layers, the odd meteor.
• Air — light gravity and a wind that shifts across the screen and quietly bends everything you fire. Haze banks, wind streaks, drifting dust.
• Water — blasts become short shoves, everything sinks slowly, and you end up planning two releases ahead. Surface caustics, light shafts, rising bubbles.
• Plasma — arcs jump between nearby shapes on their own, whether you fire or not.

THINGS ACTUALLY SHATTER
Shapes do not fall apart into pre-baked pieces. Each one splits into convex shards around the exact point the blast landed, so no two breaks look alike, and those shards can be shattered again. Whatever comes out too small is left behind as glowing dust. Triangles, squares, polygons and circles arrive in two materials, neon and metal — and metal only listens to some of your blasts.

FIVE MODIFIERS THAT BEND THE RULES
• Pressure — a plain outward blast.
• Implosion — pulls everything inward, then a small pop.
• Magnet — only metal shapes react, but hard.
• Gravity well — leaves a decaying attractor behind that keeps working after the flash is gone.
• Chain spark — arcs jump from shape to shape along the nearest neighbours.

SCORE THE PILE-UP
You score for every shape a blast actually moves, plus a bonus for each one that breaks. Shapes then thrown into each other keep a combo alive: every collision extends the window and pushes the multiplier up to four times, so a well-aimed release keeps paying out long after the flash. Positioning the cloud beats charging it to the brim.

MADE TO BE PICKED UP
• One finger, no tutorial to sit through, a run starts a second after launch.
• Six neon palettes — Cyberpunk, Vaporwave, Acid, Mono, Ember, Arctic — switchable mid-run.
• A best score and a Game Center leaderboard for every environment, so all four are worth going back to.
• Three quality levels for the bloom pipeline, so older devices stay smooth.
• An original synthwave soundtrack: a theme of its own for every environment, and a button to skip to the next track.
• Haptics scaled to the size of the blast, plus synthesized sound effects. Music, sound and haptics each have their own switch.
• iPhone and iPad, portrait or landscape.

NO STRINGS
No sign-up, no ads, no in-app purchases, no subscriptions, no tracking, no analytics. Puff plays fully in airplane mode; the only thing it ever sends is your score to Game Center, and only when you are signed in to it.

Built with Flutter, Flame and Forge2D (Box2D v3), drawn with custom fragment shaders on Impeller. The source is public on GitHub.
```

### Keywords (100) — 96 chars

```
physics,blast,neon,explosion,shatter,destruction,minimal,one touch,arcade,reflex,timing,relaxing
```

Notes: never repeat the app name or the category ("games"), never use spaces
after commas — Apple counts them. Words already in Name/Subtitle
(pressure, hold, drag, release) are indexed anyway and are left out here.

### Support URL

```
https://lioilsources.github.io/puff/support.html
```

### Marketing URL

```
https://lioilsources.github.io/puff/
```

(Alternative, if you prefer the portfolio site: `https://olin.now/apps/puff`.)

### Version

```
1.0.4
```

### Copyright (200)

```
2026 Oldřich Vořechovský
```

ASCII fallback if the form complains: `2026 Oldrich Vorechovsky`.

### What's New in This Version

For 1.1.0:

```
• Music. Every environment now has its own synthwave theme, the menu has one too, and a run ends on a short sting. The title of a track shows for a moment when it starts; NEXT TRACK on the pause screen skips to the other one.
• MUSIC has its own switch in Settings, separate from SOUND.
• Sound and music now follow the silent switch.
```

For 1.0.4:

```
• Game Center leaderboards, one for each environment. Every finished run is posted; tap LEADERBOARD on the menu or after a run to see where you stand.
• Blasts in water now leave expanding ripples that bend the light and rock the shapes they pass.
```

Drop the ripple line if 1.0.3 already went live with its own notes.

---

## App Review Information

**Sign-in required:** No — no accounts anywhere in the app.

**Contact:** Oldřich Vořechovský · business@olin.now

**Notes to Review**

```
Puff is a single-player physics game. It has no account of its own, no login, no in-app purchase and no advertising, and it is fully playable in airplane mode.

Game Center: when the device is signed in to Game Center, Puff authenticates silently at launch and posts the score of every finished run to the leaderboard of the current environment (four boards: Vacuum, Air, Water, Plasma). A LEADERBOARD button then appears on the main menu and on the game-over screen and opens that board. Without a Game Center account the button is hidden and nothing else changes.

How to play: touch and hold anywhere on the playfield. A pressure cloud grows under your finger; drag it to move it. Release to detonate. Hold too long and the cloud goes into overpressure (the rim flickers) — the release then fizzles and costs points. Geometry drifts in from the edges toward the core in the middle of the screen; the run ends when a shape reaches the core.

Environment (Vacuum / Air / Water / Plasma), blast modifier, colour palette, render quality, sound and haptics are all on the main menu and in Settings. High scores are stored locally per environment (NSUserDefaults); the only data that leaves the device is the score sent to Game Center.
```

**Attachment:** none needed.

---

## App Privacy (the questionnaire)

Answer: **Data Not Collected.**

Puff has no analytics or ad SDK and no server of its own.
`shared_preferences` (NSUserDefaults) holds settings and the local high scores.
The one thing that leaves the device is a score handed to GameKit when the
player is signed in to Game Center. Apple runs that service under its own
privacy policy and Puff receives no player data back (it only opens the system
leaderboard UI), so it is not data the developer collects. There is no
tracking, so no App Tracking Transparency prompt and no
`NSUserTrackingUsageDescription`.

## Export compliance

`ITSAppUsesNonExemptEncryption = false` is already in `ios/Runner/Info.plist`,
so App Store Connect will not ask again. The app uses no encryption.

## Other Connect switches

- **Third-Party Content:** No.
- **Sign in with Apple:** not used.
- **Made for Kids / Kids Category:** No (the app is 4+ but not in the Kids category).
- **Game Center:** on since 1.0.4 — see below.
- **Pricing:** Free, no IAP.
- **Availability:** all territories.

---

## Game Center (new in 1.0.4)

**1. Create the leaderboards** — App Store Connect → Puff → Game Center →
Leaderboards → **+** → **Classic Leaderboard**, four times (if asked, a single
game, not a group). The IDs must match `GameCenter.leaderboardId` exactly: a
misspelled board never receives a score and nothing reports an error.

| Reference name | Leaderboard ID | Display name (English U.S.) |
|---|---|---|
| Vacuum | `puff.vacuum` | Vacuum |
| Air | `puff.air` | Air |
| Water | `puff.water` | Water |
| Plasma | `puff.plasma` | Plasma |

Same settings on all four:

- Score format type: **Integer**
- Submit scores: **Best Score**
- Sort order: **High to Low**
- Score range: leave empty
- Localization English (U.S.): the display name above, score format
  **Integer**, no suffix; the image is optional.

**2. Attach them to the version** — on the 1.0.4 version page, section
**Game Center**: switch it on and add all four leaderboards. Boards that are not
part of a submitted version stay *Not Live* — they work in the sandbox, players
never see them.

---

## Screenshots

Required set is already generated — see `tool/gen_screenshots.sh` and
`apps/puff/screenshots/` in the `ol1n.now` repo (`make screenshots` produces
the exact store sizes). 6.9" (1320×2868) is native from the iPhone 17 Pro Max
simulator; 6.7" is a downscale of the same frames.

Order to upload: blast → implosion → plasma → menu → water → air.

---

## GitHub Pages (the support / marketing / terms site)

The pages live in `docs/` in this repo: `index.html` (marketing), `support.html`,
`privacy.html`, `terms.html`, plus `style.css`, `icon.png` and `shots/`.
Same structure as Kiran, in Puff's own Cyberpunk palette.

To publish, commit `docs/` to `master` and switch Pages on once:

```
gh api -X POST repos/lioilsources/puff/pages \
  -f 'source[branch]=master' -f 'source[path]=/docs'
```

(or Settings → Pages → Source: *Deploy from a branch* → `master` / `/docs`).
The site then answers at `https://lioilsources.github.io/puff/` within a
minute or two — verify all four URLs load before submitting, App Review does
open them.

The App Store links in `index.html` are placeholders
(`apps.apple.com/app/puff-pressure-blast`); replace them with the real
product URL once the app is live.

---

## 1.3.0 — App Store Connect checklist

Everything here is typed into App Store Connect by hand; the build only
reports to these IDs. A misspelled ID fails silently, exactly as with the
leaderboards above. Nothing goes to review until Ol1n says so.

### Achievements (Game Center → Achievements → +)

IDs must match `AchievementId` in `lib/game/sim/achievements.dart`. All are
**not hidden**, **not achievable more than once**. 735 points of the 1 000
allowed, so later ones still fit. English (U.S.) texts below; the image
(512×512) is required by ASC; any neon icon will do.

| Achievement ID | Title | Points | Pre-earned description | Earned description |
|---|---|---|---|---|
| `puff.ach.first_run` | First Puff | 10 | Finish your first run. | You finished your first run. |
| `puff.ach.combo_x4` | Maxed Out | 50 | Push the combo multiplier to x4. | You pushed the multiplier to x4. |
| `puff.ach.combo_40` | Chain Reaction | 100 | Reach a 40-hit combo. | You chained 40 hits. |
| `puff.ach.perfect_release` | Perfect Pressure | 25 | Release a fully charged cloud without overcharging it. | Full charge, no overpressure. |
| `puff.ach.heat_3` | Heat III | 50 | Last until HEAT III. | You lasted until HEAT III. |
| `puff.ach.overdrive` | Overdrive | 100 | Last until OVERDRIVE. | You reached OVERDRIVE. |
| `puff.ach.untouchable` | Untouchable | 75 | Keep the core untouched for the first 60 seconds. | 60 seconds without a scratch. |
| `puff.ach.shatter_50` | Shatterer | 50 | Break 50 shapes in one run. | 50 shapes broken in one run. |
| `puff.ach.all_environments` | World Tour | 50 | Finish a run in Vacuum, Air, Water and Plasma. | You played all four environments. |
| `puff.ach.all_modifiers` | Toolkit | 50 | Finish a run with every modifier. | You used every modifier. |
| `puff.ach.all_palettes` | Color Theory | 25 | Finish runs in six different palettes. | Six palettes played. |
| `puff.ach.runs_10` | Regular | 25 | Finish 10 runs. | 10 runs finished. |
| `puff.ach.runs_50` | Devoted | 75 | Finish 50 runs. | 50 runs finished. |
| `puff.ach.weekly` | Weekly Contender | 50 | Finish a weekly challenge run. | You took on the weekly challenge. |

Achievements are evaluated when a run ends. Unlocks earned while signed out
are kept on the device and reported at the next sign-in.

### Weekly leaderboard (Leaderboards → + → Recurring Leaderboard)

| Field | Value |
|---|---|
| Reference name | Weekly |
| Leaderboard ID | `puff.weekly` |
| Start | **23 Nov 2026, 00:00 UTC** (Monday; `WeeklyChallenge.launch`) |
| Duration / restarts every | 1 week |
| Score format, submit, sort | Integer, Best Score, High to Low |
| Display name (en-US) | Weekly Challenge |

The week's environment, modifier and spawn seed follow from the date alone;
no build or config is needed per week. Before the start date the menu hides
the challenge (TestFlight builds can show it early with
`--dart-define=PUFF_WEEKLY=true`). The remote config can switch it off
(`"weekly": false`).

### Challenges (Game Center → Challenges, iOS 26+)

Challenges sit on top of existing leaderboards; the scores the game already
submits count, the app only shows a **CHALLENGES** button once ASC has at
least one definition. Suggested definitions, each **repeatable**, durations
1 day / 3 days / 1 week:

| Challenge ID | Leaderboard | Title |
|---|---|---|
| `puff.challenge.vacuum` | `puff.vacuum` | Vacuum Showdown |
| `puff.challenge.plasma` | `puff.plasma` | Plasma Showdown |
| `puff.challenge.weekly` | `puff.weekly` | Weekly Showdown |

Then attach the leaderboards, achievements and challenges to the 1.3.0
version (section Game Center), as with 1.0.4.

### Game activities (optional, iOS 26+)

A game activity opens Puff from the Games app or from an In-App Event
straight into a run. The app reads the activity's properties:

| Property | Values | Effect |
|---|---|---|
| `mode` | `weekly` | plays this week's challenge |
| `environment` | `vacuum`, `air`, `water`, `plasma` | free run in that environment |
| `modifier` | `pressure`, `implosion`, `magnet`, `gravityWell`, `chainSpark` | and with that modifier |

The run's score is reported back on the activity when it ends.

### In-App Events — deep links

| Link | What it does |
|---|---|
| `puff://event/weekly` | starts this week's challenge (menu if none) |
| `puff://play` | starts a run with the player's setup |
| `puff://palette/holiday` | selects a palette (if in season) and opens the menu |
| `puff://event/<anything>` | opens the menu |

### Product Page Optimization — icon test

Since build 17 of 1.3.0 (8 Nov 2026) the primary icon is D4, the gravity
well spiral, on iOS, Android and the Play listing (`tool/gen_primary_icon.sh`).
The pineapple it replaced stays in the build as `AppIcon-Pineapple`. The
other alternates were picked in the icon picker on 7 Nov 2026, in Ol1n's
order of priority (drawings in `tool/icon_designs.html`,
rendered by `tool/gen_picked_icons.sh`):

| # | Pick | Icon set | Drawing |
|---|---|---|---|
| 1 | B4 | `AppIcon-Flash` | white-yellow starburst flash |
| 2 | C4 | `AppIcon-Halves` | circle split into magenta and cyan halves |
| — | D4 | primary `AppIcon` | cyan gravity-well spiral, yellow core |
| — | — | `AppIcon-Pineapple` | the old pineapple and banana |
| 4 | E3 | `AppIcon-Wordmark` | "puff" in neon |
| 5 | G3 | `AppIcon-Orbit` | four shapes orbiting a core |
| 6 | H3 | `AppIcon-Charged` | magenta ring with arcs |
| 7 | F4 | `AppIcon-Pulse` | dashed yellow pulse rings |
| 8 | A3 | `AppIcon-Waves` | cyan pressure waves |

Product Page Optimization → Create Test → Icon: original plus up to three
treatments. First round: Flash, Halves, Wordmark against the spiral; add
Pineapple if the old icon should be checked once more. Blast, Cloud and Shatter from 1.2.2 are gone, so start the
test on 1.3.0, not on 1.2.3. Play experiments take the 512 px copies in
`store/play/icon_tests/`.

### Accessibility labels (App Information → Accessibility)

| Feature | Claim | Why |
|---|---|---|
| Dark Interface | **Yes** | The whole game is dark; there is no light screen. |
| Reduced Motion | **Yes** | With the system's Reduce Motion (or Settings → REDUCED FLASHES) flashes, shake and aberration drop to 30 % and zoom pulses are off. |
| Sufficient Contrast | Check first | Neon on near-black; claim it only after measuring the dimmer menu text (11–12 pt captions at 70–80 % alpha) in every palette. |
| VoiceOver, Voice Control | No | The playfield is a canvas without accessible elements. |
| Larger Text | No | The menus use fixed sizes. |
| Differentiate Without Color Alone | No | Not claimed: palettes are told apart by colour. |
| Captions, Audio Descriptions | No | No dialogue or video content. |

### Share links

The share text links to
`https://apps.apple.com/app/id6808586613?ct=share&pt=<token>`. Fill in
`ShareLinks.providerToken` in `lib/app/share_card.dart` (App Analytics →
Campaigns shows the provider token); until then the link goes without `pt`
and campaign attribution does not work.

### Remote config

App Privacy stays **Data Not Collected** only while the server keeps nothing
from these requests beyond what it needs to answer them (Apple counts data
kept "longer than necessary to service the request"). Check the olin.now
access logs: if they keep IP addresses, either turn that off for
`/apps/puff/` or answer the questionnaire accordingly. The privacy policy
(`docs/privacy.html`, Network access) says the request shows the IP address
and nothing else.

`store/remote_config.json` goes to `https://olin.now/apps/puff/config.json`
(the `RemoteConfig.url` constant). Optional: without it the built-in dates
apply (Holiday palette 1 Dec – 6 Jan). It can switch the weekly challenge or
a season off and add dated palettes without a build.
