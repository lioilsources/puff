# App Store Connect — Puff (English U.S.)

Everything below is ready to paste into App Store Connect. Character counts are
against Apple's limits; recount after any edit.

Bundle id `com.ol1n.puff` · listing name **Puff: Pressure Blast** (the plain
name "Puff" is taken; `CFBundleDisplayName` stays "Puff" on the home screen).

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

### Description (4000) — 3 546 chars

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
• A separate local best score for every environment, so all four are worth going back to.
• Three quality levels for the bloom pipeline, so older devices stay smooth.
• Haptics scaled to the size of the blast, plus synthesized sound; both switchable.
• iPhone and iPad, portrait or landscape.

NO STRINGS
No account, no sign-up, no ads, no in-app purchases, no subscriptions, no tracking, no analytics — and no network code at all. Puff runs in airplane mode, and your scores never leave your device.

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
1.0.2
```

### Copyright (200)

```
2026 Oldřich Vořechovský
```

ASCII fallback if the form complains: `2026 Oldrich Vorechovsky`.

### What's New in This Version

Not shown for a first release — leave it empty for 1.0. Text for the next
update:

```
• Vacuum, air and water now have backgrounds worth looking at: nebula bands and meteors, drifting haze, surface caustics and light shafts.
• Water retuned. Shapes used to stall before they ever reached the core; blasts now carry through the viscosity instead of dying on the spot.
```

---

## App Review Information

**Sign-in required:** No — no accounts anywhere in the app.

**Contact:** Oldřich Vořechovský · oldrich.vorechovsky.jr@gmail.com

**Notes to Review**

```
Puff is a single-player offline physics game. There is no account, no login, no in-app purchase, no advertising and no network access at all — the app can be reviewed in airplane mode.

How to play: touch and hold anywhere on the playfield. A pressure cloud grows under your finger; drag it to move it. Release to detonate. Hold too long and the cloud goes into overpressure (the rim flickers) — the release then fizzles and costs points. Geometry drifts in from the edges toward the core in the middle of the screen; the run ends when a shape reaches the core.

Environment (Vacuum / Air / Water / Plasma), blast modifier, colour palette, render quality, sound and haptics are all on the main menu and in Settings. High scores are stored locally per environment (NSUserDefaults) and are never transmitted.
```

**Attachment:** none needed.

---

## App Privacy (the questionnaire)

Answer: **Data Not Collected.**

Puff has no networking code, no analytics or ad SDK, and no third-party
services. `shared_preferences` (NSUserDefaults) holds settings and the local
high scores; nothing leaves the device. There is no tracking, so no
App Tracking Transparency prompt and no `NSUserTrackingUsageDescription`.

## Export compliance

`ITSAppUsesNonExemptEncryption = false` is already in `ios/Runner/Info.plist`,
so App Store Connect will not ask again. The app uses no encryption.

## Other Connect switches

- **Third-Party Content:** No.
- **Sign in with Apple:** not used.
- **Made for Kids / Kids Category:** No (the app is 4+ but not in the Kids category).
- **Game Center:** not used (scores are local).
- **Pricing:** Free, no IAP.
- **Availability:** all territories.

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
