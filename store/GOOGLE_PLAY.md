# Google Play Console — Puff (English U.S.)

Everything below is ready to paste into Play Console. Character counts are
against Google's limits; recount after any edit. The iOS counterpart is
`APP_STORE.md`; the description here is the same text with the Game Center and
iPhone/iPad lines taken out, because Play rejects listings that mention other
platforms or features the Android build does not have.

Package `com.ol1n.puff` · default language **English (United States) – en-US**
· organisation developer account (no closed-test requirement before
production).

---

## Main store listing

Console: *Grow users → Store presence → Main store listing*
(*Zvýšení počtu uživatelů → Přítomnost v obchodu → Hlavní záznam v obchodu*).

Play has no keyword field. Search indexes the app name, the short description
and the full description, in that order of weight — so the words that matter
are placed there on purpose.

**App name** (30) — 27 chars, as already entered in the console

```
Puff: Squishy Relaxing Game
```

The App Store listing is `Puff: Pressure Blast` (20). If the two stores should
match, that one fits here too; `Puff: Neon Physics Blast` (24) is the variant
that carries the most search terms.

**Short description** (80) — 73 chars

```
Hold, drag, release. A one-finger neon physics game where shapes shatter.
```

Alternates: `Charge a pressure cloud, let go, and watch neon shapes shatter.` (63)
· `One finger. Hold to charge, release to blast neon geometry apart.` (64)

**Full description** (4000) — 3 433 chars

```
Hold. Drag. Release.

Puff is a minimalist neon physics game. Press anywhere and a pressure cloud grows under your finger. Drag it to where it matters. Let go, and the pressure blows apart the geometry drifting in from the edges toward the core in the middle of the screen. Let one shape reach that core and the run is over.

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
• A best score for every environment, so all four are worth going back to.
• Three quality levels for the bloom pipeline, so older devices stay smooth.
• Haptics scaled to the size of the blast, plus synthesized sound; both switchable.

NO STRINGS
No sign-up, no ads, no in-app purchases, no subscriptions, no tracking, no analytics. Puff plays fully offline and sends nothing anywhere.

Built with Flutter, Flame and Forge2D (Box2D v3), drawn with custom fragment shaders on Impeller. The source is public on GitHub.
```

When Play Games leaderboards are switched on (section below), put the
leaderboard bullet back and reword the last sentence of NO STRINGS.

### Graphics

All in `store/play/`, all without alpha, all inside Play's limits.

| Slot | File | Size |
|---|---|---|
| App icon | `icon_512.png` | 512×512 |
| Feature graphic | `feature_graphic_1024x500.png` | 1024×500 |
| Phone screenshots | `screenshots/puff_1_blast.png` … `puff_6_air.png` | 1080×1920 (9:16) |

Upload order: blast → plasma → water → arctic → menu → air.

The screenshots are native Android frames, not resized iOS ones: Play refuses
anything taller than 2:1, and an iPhone frame carries the Dynamic Island.
`tool/gen_screenshots_android.sh` reshoots them from an emulator.

Tablet screenshots (7" and 10") are optional and left empty; the game is
portrait-only and the phone set is shown on tablets too.

**Video** — none.

---

## Store settings

Console: *Grow users → Store presence → Store settings*.

- **App or game:** Game
- **Category:** Arcade
- **Tags:** Arcade, Casual, Single player, Abstract, Offline (pick up to five
  from what the console offers)
- **Email:** oldrich.vorechovsky.jr@gmail.com
- **Website:** `https://lioilsources.github.io/puff/`
- **Phone:** leave empty
- **External marketing:** on

---

## App content (the declarations)

Console: *Policy and programs → App content*; the same items are the task list
under "Nastavení aplikace" on the dashboard.

| Declaration | Answer |
|---|---|
| Privacy policy | `https://lioilsources.github.io/puff/privacy.html` |
| App access | All functionality is available without special access (no login) |
| Ads | No, the app does not contain ads |
| Content rating | Questionnaire below → expected **Everyone / PEGI 3** |
| Target audience | **13–15, 16–17, 18+** (see note) |
| Data safety | No data collected, no data shared (below) |
| Advertising ID | No, the app does not use an advertising ID |
| Government app | No |
| Financial features | None |
| Health | None |
| News app | No |

**Content rating questionnaire (IARC)** — email as above, category **Game**.
Every content question is **No**: no violence (abstract geometry only), no
fear, no sexuality, no language, no controlled substances, no gambling, no
user interaction, no user-generated content, no location sharing, no digital
purchases.

**Target audience.** Puff is harmless for any age, but ticking an age group
under 13 puts the app under the Families policy (teacher-approved review,
stricter SDK rules, a separate declaration every release). The game is not
designed for children specifically, so 13+ is the accurate answer and the
cheaper one. To the follow-up "could the listing unintentionally appeal to
children?" answer **No**.

**Data safety.**

- Does your app collect or share any of the required user data types? **No**
- Is all user data encrypted in transit? not asked once the answer above is No
- Account creation / deletion: the app has no accounts

Puff has no analytics or ad SDK and no server of its own. `shared_preferences`
keeps settings and local high scores on the device; that is not "collection"
in Play's sense because nothing leaves it. The Android build never calls the
network: with no Play Games IDs filled in, `games_services` is linked but
idle. Its Play Services dependency may still merge the
`INTERNET` permission into the release manifest; that does not change the
answer, the form is about data, not permissions.

Revisit this form the day Play Games Services, telemetry or IAP ship.

---

## Release

**First upload is manual.** Take `app-release.aab` from the GitHub Release the
`release-android` workflow publishes on every `v*` tag. Upload it under
*Test and release → Testing → Internal testing → Create new release* and
accept **Play App Signing** when asked: Google then holds the app signing key
and the keystore in the CI secrets becomes the *upload key*. Keep a copy of
that keystore outside GitHub — losing it means a support ticket, not a lost
app, but it still costs days.

`versionCode` is the workflow run number (`1.0.4` → 9), so it only ever goes
up as long as every upload comes from CI. A local `flutter build appbundle`
produces `+1` and Play will refuse it.

**Order that wastes no time**

1. Internal testing: testers list with your own address, upload the AAB,
   publish. No review; installable within minutes.
2. Play the build on a real phone, all four environments and all three quality
   levels. The fragment shaders are the Android-specific risk; the emulator
   renders them correctly, a cheap Mali or Adreno phone is the real test.
3. Read the **pre-launch report** the internal release triggers (crashes,
   ANRs, screenshots from a handful of real devices).
4. Fill in App content, Store settings and the Main store listing above.
5. *Production → Create new release → Add from library* (reuse the same AAB),
   choose countries (all), send for review. First review usually takes a few
   days.

**Release name**

```
1.0.4
```

**Release notes** (500, en-US)

```
<en-US>
First release on Google Play.
• Four environments — Vacuum, Air, Water, Plasma — each with its own physics.
• Five blast modifiers and six neon palettes.
• Shapes shatter into real shards around the point of impact.
• No ads, no purchases, no tracking. Plays fully offline.
</en-US>
```

**Pricing** — Free. A free app can never be turned into a paid one on Play, so
this is final; IAP can still be added later.

**Countries** — all.

---

## Play Games leaderboards (prepared, switched off)

The code is in place and inert: while `games-ids.xml` and
`_androidLeaderboardIds` are empty, the Android build has no leaderboards and
behaves exactly like 1.0.4. Filling in five values switches it on.

**1. Create the Play Games project** — Console → *Grow users → Play Games
Services → Setup and management → Configuration*. Choose "No, my game doesn't
use Google APIs", create the project, then **Add credential → Android** and
create the OAuth client it asks for with package `com.ol1n.puff` and the
**SHA-1 of the app signing key** (*Test and release → App integrity → App
signing*; available once the first AAB is uploaded). Use the *app signing*
certificate, not the upload one: Google re-signs the AAB, and a client made
for the upload key signs in from a sideloaded build but fails for everyone who
installs from Play. Add a second credential with the upload SHA-1 if locally
built release APKs should sign in too.

**2. Create four leaderboards** — *Play Games Services → Leaderboards*:

| Name | Format | Ordering | Tamper protection |
|---|---|---|---|
| Vacuum | Numeric, 0 decimals | Larger is better | on |
| Air | same | same | same |
| Water | same | same | same |
| Plasma | same | same | same |

Each needs an icon (512×512; `store/play/icon_512.png` will do).

**3. Paste the IDs**

- Project ID (digits) → `android/app/src/main/res/values/games-ids.xml`,
  string `game_services_project_id`.
- The four leaderboard IDs (`CgkI…`) → `_androidLeaderboardIds` in
  `lib/app/game_center.dart`.

"Get resources" on the Leaderboards page lists all five at once.

**4. Publish** — Play Games projects start in *testing*: only accounts listed
under *Testers* can sign in. *Review and publish* makes it live for everyone;
do it with the release that carries the IDs, not before.

**How it behaves on Android.** Play Games attempts its own sign-in at launch
and Puff only listens for the result — it never raises the sign-in dialog by
itself. The LEADERBOARD button is always shown; tapping it signed out prompts
once, then opens the board. Scores are posted only while signed in.

**When this ships, also update**

- the full description: put back `• A best score and a leaderboard for every
  environment…` and reword NO STRINGS ("the only thing it ever sends is your
  score to Google Play Games, and only when you are signed in to it");
- `docs/privacy.html`, which names Game Center as the only third party;
- Data safety — Google's guidance treats Play Games Services as Google's own
  collection, but re-read the form's help text at that point.

---

## Known differences from iOS

- **No leaderboards yet.** Prepared but switched off, see the section above.
  Nothing in the listing promises them.
- **Font.** The UI asks for the generic `monospace` family, so Android and
  iOS each render their own platform face. Cosmetic.
- **Target API.** Flutter 3.44.4 builds against `targetSdk` 36, which meets
  Play's current requirement.
