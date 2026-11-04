# Google Play Console — Puff (English U.S.)

Everything below is ready to paste into Play Console. Character counts are
against Google's limits; `python3 tool/check_play_listing.py` recounts every
block and fails on drift, so run it after any edit. The iOS counterpart is
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

**Full description** (4000) — 3 976 chars

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

IT GETS HEAVIER
The longer a run lasts, the hotter it gets: bigger shapes, faster, more metal, then volleys from one edge. Your blasts grow to match, with a wider cloud, a harder hit and a second shockwave ring. Now and then a giant polygon drifts in that a blast barely moves; crack it, and it bursts into dozens of shards. The HUD calls each step: HEAT II, HEAT III, OVERDRIVE.

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
• An original synthwave soundtrack: a theme of its own for every environment, and a button to skip to the next track.
• Haptics scaled to the size of the blast, plus synthesized sound effects. Music, sound and haptics each have their own switch.

NO STRINGS
No sign-up, no ads, no in-app purchases, no subscriptions, no tracking, no analytics. Puff plays fully offline and sends nothing anywhere.

Built with Flutter, Flame and Forge2D (Box2D v3), drawn with custom fragment shaders on Impeller. The source is public on GitHub.
```

When Play Games leaderboards are switched on (section below), put the
leaderboard bullet back and reword the last sentence of NO STRINGS.
The English text is at 3 976 of 4 000 since 1.2.0, so something has to be
trimmed to make room.

### Czech – cs-CZ (translation)

Console: *Main store listing → Manage translations → Add your own
translations → Czech – cs-CZ*. The in-game UI stays English, so the
environment, modifier and palette names and the HUD calls (HEAT II,
OVERDRIVE) are left in English here too — they are what the player sees.

**App name** (30) — 27 chars

```
Puff: Relaxační neonová hra
```

**Short description** (80) — 77 chars

```
Podrž, táhni, pusť. Neonová fyzikální hra na jeden prst, kde se tvary tříští.
```

**Full description** (4000) — 3 824 chars

```
Podrž. Táhni. Pusť.

Puff je minimalistická neonová fyzikální hra. Přitiskni prst kamkoli a pod ním začne růst tlakový mrak. Přetáhni ho tam, kde je potřeba. Pusť – a tlak rozmetá geometrii, která se z okrajů sune k jádru uprostřed obrazovky. Když k jádru dorazí jediný tvar, hra končí.

Všechno se točí kolem jedné otázky: kdy pustit?

NABÍT, PŘETLAKOVAT, LITOVAT
Čím déle držíš, tím je mrak větší a tím silněji udeří. Když přetáhneš hranici přetlaku, mrak vyšumí – žádná rázová vlna, žádné body a navíc penalizace. Okraj mraku bliká během poslední čtvrtiny nabíjení, takže přetlak je vždycky tvoje rozhodnutí, nikdy překvapení. Tvary, které do mraku vplují, zatímco ještě držíš, z něj náboj zase vysávají. Každé dlouhé podržení je tak sázka: větší výbuch, nebo vůbec nic.

Nic neběží na čas kromě tebe. Žádné nabíjení, žádná munice, žádné menu mezi tebou a dalším výbuchem.

ČTYŘI PROSTŘEDÍ, JEDNO OVLÁDÁNÍ
Stejný prst dělá v každém z nich něco jiného.
• Vacuum – nic netlumí pohyb, takže každý výbuch je prak a úlomek si drží rychlost, jakou jsi mu dal. Pásy mlhovin, tři vrstvy hvězd v paralaxe, sem tam meteor.
• Air – slabá gravitace a vítr, který se mění napříč obrazovkou a nenápadně ohýbá všechno, co vypálíš. Opar, pruhy větru, poletující prach.
• Water – výbuchy se mění v krátká postrčení, všechno pomalu klesá a začneš plánovat o dva výbuchy dopředu. Odlesky hladiny, paprsky světla, stoupající bubliny.
• Plasma – mezi blízkými tvary samy přeskakují výboje, ať střílíš, nebo ne.

TVARY SE OPRAVDU TŘÍŠTÍ
Tvary se nerozpadají na předem připravené kousky. Každý se rozštípne na konvexní střepy kolem přesného místa, kam výbuch dopadl, takže žádné dva lomy nevypadají stejně – a střepy jdou rozbít znovu. Co vyjde příliš malé, zůstane jako zářící prach. Trojúhelníky, čtverce, mnohoúhelníky a kruhy přicházejí ve dvou materiálech, neon a kov – a kov poslouchá jen některé výbuchy.

ČÍM DÉLE, TÍM TĚŽŠÍ
Čím déle hra trvá, tím víc se rozpálí: větší a rychlejší tvary, víc kovu, pak salvy z jednoho okraje. Výbuchy rostou s nimi – širší mrak, silnější úder a druhý prstenec rázové vlny. Občas připluje obří mnohoúhelník, kterým výbuch skoro nepohne; rozbij ho a rozletí se na desítky střepů. HUD ohlásí každý stupeň: HEAT II, HEAT III, OVERDRIVE.

PĚT MODIFIKÁTORŮ, KTERÉ OHÝBAJÍ PRAVIDLA
• Pressure – obyčejný výbuch směrem ven.
• Implosion – vtáhne všechno dovnitř, pak malé prásknutí.
• Magnet – reagují jen kovové tvary, zato pořádně.
• Gravity well – zanechá slábnoucí přitažlivé pole, které působí i po zhasnutí záblesku.
• Chain spark – výboje přeskakují z tvaru na tvar k nejbližším sousedům.

BODUJ ZA ŘETĚZOVKU
Body dostáváš za každý tvar, kterým výbuch skutečně pohne, a bonus za každý, který se rozbije. Tvary, které pak narážejí do sebe, drží kombo naživu: každá srážka prodlouží okno a zvedne násobič až na čtyřnásobek, takže dobře mířený výbuch vydělává ještě dlouho po záblesku. Dobře umístit mrak se vyplatí víc než ho nabít po okraj.

STAČÍ VZÍT DO RUKY
• Jeden prst, žádný tutoriál, hra začne vteřinu po spuštění.
• Šest neonových palet – Cyberpunk, Vaporwave, Acid, Mono, Ember, Arctic – přepínatelných i během hry.
• Nejlepší skóre pro každé prostředí, takže stojí za to vracet se do všech čtyř.
• Tři úrovně kvality bloomu, aby i starší zařízení běžela plynule.
• Původní synthwave soundtrack: vlastní téma pro každé prostředí a tlačítko pro přeskočení na další skladbu.
• Vibrace podle velikosti výbuchu a syntetizované zvukové efekty. Hudba, zvuky i vibrace mají každý svůj vypínač.

BEZ HÁČKŮ
Žádná registrace, žádné reklamy, žádné nákupy v aplikaci, žádné předplatné, žádné sledování, žádná analytika. Puff funguje zcela offline a nikam nic neposílá.

Postaveno na Flutteru, Flame a Forge2D (Box2D v3), vykresleno vlastními fragment shadery na Impelleru. Zdrojový kód je veřejně na GitHubu.
```

### Graphics

All in `store/play/`, all without alpha, all inside Play's limits.

| Slot | File | Size |
|---|---|---|
| App icon | `icon_512.png` | 512×512 |
| Feature graphic | `feature_graphic_1024x500.png` | 1024×500 |
| Phone screenshots | `screenshots/puff_1_blast.png` … `puff_6_air.png` | 1080×1920 (9:16) |
| 7" and 10" tablet screenshots | `tablet/puff_1_blast.png` … `puff_6_air.png` (same set in both slots) | 1600×2560 (10:16) |

Upload order: blast → plasma → water → arctic → menu → air.

The screenshots are native Android frames, not resized iOS ones: Play refuses
anything taller than 2:1, and an iPhone frame carries the Dynamic Island.
`tool/gen_screenshots_android.sh` reshoots them from an emulator.

Tablet screenshots are optional. Puff is portrait-only and draws the same
scene at any width, so `tool/play_tablet_shots.py` puts each phone frame on a
10:16 canvas whose margins are the same frame blurred and darkened. They are
the phone shots, honestly framed, not tablet captures: good enough to fill the
slots, not enough for a "designed for tablets" claim. For native frames, run
`gen_screenshots_android.sh` with `wm size 1600x2560` on a tablet AVD.

The phone shots predate 1.2.0 (no HEAT tier or giant polygon on screen). They
are still accurate; a reshoot with `--dart-define=PUFF_HEAT=1.3` would show
off the new escalation.

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
in Play's sense because nothing leaves it. With no Play Games IDs filled in,
`games_services` is linked but idle.

Re-checked against the 1.2.0 release APK (versionCode 11) on 2026-10-15 with
`aapt2 dump badging`: the merged manifest requests **no permissions at all**
apart from AndroidX's own `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` — not
even `INTERNET`. The only SDK added since 1.0.4 is `flutter_soloud` (native
audio: SoLoud, Ogg/Vorbis/Opus/FLAC), which plays bundled files and has no
network or data path. No IAP, no ads. The "no data collected" answer stands.

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
produces `+1` (pubspec says `1.2.0+1`) and Play will refuse it.

| Tag | versionCode (run #) | On Play |
|---|---|---|
| v1.0.4 | 9 | production 2026-10-12 → 2026-10-27, replaced by 1.2.1 |
| v1.0.5 | 10 | not uploaded (paperwork + inert leaderboards only) |
| v1.1.0 | — | **never tagged**, so no AAB exists; Jukebox ships inside 1.2.0 |
| v1.2.0 | 11 | never reached production; superseded by 1.2.1 |
| v1.2.1 | 12 | **production since 2026-10-27** — Jukebox, Heat, UI localization |

Until 2026-10-27 Play still served 1.0.4 while the App Store already had the Jukebox, which
is why Android players had no music. The next AAB must come from CI with a
versionCode above 12.

1.2.1 (tagged on `eaeadba`, the UI localization merge) checked on the
release APK: `com.ol1n.puff`, versionName 1.2.1, versionCode 12; the AAB
carries all ten OGG tracks and `libflutter_soloud_plugin.so` for arm64-v8a,
armeabi-v7a and x86_64. Play Console reports 178 countries and 19 420
supported devices. The 1.2.0 APK, for reference: versionName 1.2.0,
versionCode 11, minSdk 24, targetSdk 36, signed by `CN=Puff, OU=Mobile,
O=lioilsources` (SHA-256 `b438c162…a7b6`). Play App Signing re-signs it; the
upload key must be the one the console lists under *App integrity → Upload
key certificate* — same CI secret as 1.0.4, so it should match.

AAB is 82 MB (the 1.1.0 soundtrack is 24 MB of OGG), well under Play's
200 MB base-module limit; per-device downloads are smaller.

**Shipping 1.2.0 (an update, not a first release)**

1. `gh release download v1.2.0 -p app-release.aab` (or the Release page).
2. *Test and release → Testing → Internal testing → Create new release* →
   upload the AAB → release name `1.2.0` → paste the notes below (en-US and
   cs-CZ) → *Save and publish*. No review on internal.
3. Install from the internal track on a real phone and play to OVERDRIVE at
   least once (≈4 min) — 1.2.0's heat tuning has never been played on a
   device, and a giant polygon cracking into 72 shards under overdrive
   particles has not been profiled. Listen for the music under the blasts.
4. Check the pre-launch report for crashes/ANRs (`flutter_soloud` is new
   native code on every ABI).
5. *Production → Create new release → Add from library* → pick versionCode
   11 → same name and notes → staged rollout 20 % is the cheap safety net
   (raise to 100 % after a day without crashes in *Android vitals*) → *Send
   for review*.
6. Listing (independent of the binary, can go in the same review): paste the
   updated EN full description (new IT GETS HEAVIER section), add the cs-CZ
   translation, upload the tablet set. *Publishing overview* sends listing
   and release together.

**Release name**

```
1.2.0
```

**Release notes for 1.2.0** (500 per language). Production has 1.0.4, so
these cover the Jukebox from 1.1.0 as well.

en-US — 392 chars

```
<en-US>
Runs now escalate. The longer you last, the hotter it gets: bigger shapes, more metal, volleys from one edge, and blasts that hit harder to match. HEAT II, HEAT III, then OVERDRIVE. Watch for the giant polygon that has to be cracked, not pushed.
Music too: a synthwave theme for every environment, NEXT TRACK on the pause screen and its own MUSIC switch in Settings. Thanks for asking for it!
</en-US>
```

cs-CZ — 383 chars

```
<cs-CZ>
Hra teď graduje. Čím déle vydržíte, tím víc se rozpálí: větší tvary, víc kovu, salvy z jednoho okraje a výbuchy, které udeří silněji. HEAT II, HEAT III a nakonec OVERDRIVE. Pozor na obří mnohoúhelník – ten se musí rozbít, odfouknout nejde.
Nově i hudba: vlastní synthwave téma pro každé prostředí, NEXT TRACK v pauze a samostatný přepínač MUSIC v nastavení. Díky, že jste o ni psali!
</cs-CZ>
```

**Release notes for 1.1.0** — never shipped (no v1.1.0 tag), superseded by
1.2.0 above; kept for the record. (500, en-US) — 328 chars

```
<en-US>
Music! Every environment now has its own synthwave theme, and so does the menu.
• The title of a track shows for a moment when it starts.
• NEXT TRACK on the pause screen skips to the other one.
• MUSIC has its own switch in Settings, separate from SOUND.
Thanks to the first reviewer on Google Play, who asked for exactly this.
</en-US>
```

**Release notes for 1.0.4** — release name `1.0.4`, the first production
release (500, en-US)

```
<en-US>
First release on Google Play.
• Four environments — Vacuum, Air, Water, Plasma — each with its own physics.
• Five blast modifiers and six neon palettes.
• Shapes shatter into real shards around the point of impact.
• No ads, no purchases, no tracking. Plays fully offline.
</en-US>
```

**Order used for the first release (1.0.4), for reference**

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
