# Puff — DEVLOG

Spec: `Prompts/PUFF_PLAN.md`. One entry per phase: what works, what feels
wrong, open questions.

## Environment notes

- Flutter 3.44.4 / Dart 3.12.2, Xcode 26.2. Flame 1.38.2, flame_forge2d 0.20.0,
  forge2d 0.15.1 (Box2D v3 backend: `ShapeDef`, sensor events, `overlapAabb`).
- Online `dart pub get` hangs for minutes on this machine even though pub.dev
  answers. Use `flutter run --no-pub` / `flutter test --no-pub` after an
  offline `dart pub get --offline`.
- Verification loop: iPhone 17 simulator + `xcrun simctl io booted screenshot`.

## Phase 0 — setup

Works: boots to the dark palette background with the moving test square on
the iPhone 17 simulator (Impeller/Metal). All six `.frag` files compile for
Metal, GLES, Vulkan and SkSL via impellerc, with `#include "common.glsl"`
picked up because the flutter tool passes the shader directory as include.

Gotcha: the first Xcode build hung for 15+ minutes at 0% CPU when launched
from the sandboxed tool shell (SWBBuildService died silently). Running
`flutter run` outside the sandbox builds in ~2 minutes. Documented here so
nobody chases ghosts.

Not verified: Android device/emulator run. `flutter build apk --debug` is
used as the compile check.

## Phase 1 — core loop

- Touch: `DragCallbacks` on a full-screen viewport component. Flame's
  immediate multi-drag recognizer fires `onDragStart` on pointer down when no
  other recognizer competes, so hold-without-move works. Overlays (menus) sit
  above the GameWidget and block input naturally.
- Cloud is *not* a sensor body. Box2D v3 shapes cannot be resized, so a
  growing sensor would need destroy/recreate every frame. An AABB query +
  distance check per frame gives the same "who is inside" answer for less.
- Blast follows the spec formula exactly (`sim/blast.dart`, unit tested).
  `impulseScale` 11 with `falloffPower` 1.4 gives ~7-9 m/s kicks near the
  center at full charge, which reads as violent without launching everything
  off-screen instantly.
- Lose condition: **central core** (default). Shapes spawn from all edges and
  drift toward the center, so "protect the middle" gives every blast a
  purpose. Bottom-edge escape is implemented behind `Tuning.loseRule` but
  feels arbitrary in zero-g environments.
- Overpressure: penalty 0.5 + distinct "fizzle" (hazard-colored particles,
  sputter sound, no shockwave). Feels fair: you see the rim flicker for the
  last ~25% of the hold, so it reads as your fault.

Feels wrong / open: charge curve reaches 1.0 only at overpressure, so the
"perfect" release is always a gamble. Might be better with a plateau at 90%.
Shapes inside the cloud drain charge which is a nice tension, but the drain
visual (jitter) is subtle at low energy.

## Phase 2 — environments

Vacuum (blast x1.4, no damping), Air (damping 0.4, light gravity, wind),
Water (damping 3.0, blast x0.6, slow sink), Plasma (damping 0.6, x1.15,
periodic arcs between nearby shapes). Distinct with the same input: water
makes blasts short shoves; vacuum turns them into slingshots. Background
shader switches with the environment.

## Phase 3 — fracture

Rules as specified. Fragments carry an explicit outline so any convex piece
can be re-fractured by the generic centroid fan. `maxDepth` 2. Pieces under
0.11 m circumradius become dust particles (Forge2D warns below ~0.1 m).
Body cap 200; beyond that the fracture system emits dust instead of bodies.

## Phase 4 — modifiers

All five implemented on top of the detonator (direction sign, filter,
impulse multiplier) plus a per-frame force-field pass for gravity wells.
Chain spark uses a greedy nearest-neighbor walk capped by hop distance.

## Phase 5 — rendering

- Post-process is a Flame `PostProcess` on the camera. Flame's own
  `rasterizeSubtree` does not scale by pixelRatio (content lands in the
  top-left of a DPR-sized image), so the pipeline rasterizes itself with an
  explicit `canvas.scale(pixelRatio)`.
- Background and cloud draw in world space; `FlutterFragCoord()` is in the
  draw's local space on Impeller, so rect origin/size are passed as uniforms
  in meters.
- GLES y-flip guards are in the texture-sampling shaders per Flutter docs;
  untested on a GLES-only Android device.
- Quality: low = no post-process; med = 0.75x scene, 1 blur iteration;
  high = full res, 2 iterations.

## Phase 6 — palettes

Six built-ins, JSON round-trip, picker on the main menu. Everything reads
colors at frame time so switching palettes mid-run works.

## Phase 7 — audio

Every sound is synthesized by `tool/gen_sfx.dart` (pure Dart WAV writer).
Charge tone uses five pre-baked seamless loops rather than pitch shifting
(audioplayers' rate control is platform-inconsistent). Placeholder quality,
but coherent.

## Phase 8 — shell

Main menu / pause / game over / settings overlays, haptics scaled by energy,
local high score per environment via shared_preferences. No accounts.

## Not done

- TestFlight / internal Play upload (needs signing + store credentials).
- On-device profiling on Pixel 6a / iPhone 12 class hardware. The wireless
  iPhone 12 mini was visible to `flutter devices` but not used for a
  profile run yet.

## Verification log (2026-09-03)

- iPhone 17 simulator (Impeller/Metal): menu, HUD pause button, game over
  overlay with persisted "NEW BEST", star-field background, cloud shader
  (soft body + rim), bloom on strokes, particle bursts, fractured square
  shards with spark trails, all seen in screenshots driven by `PUFF_DEMO`.
- 22 unit tests + 8 fracture/modifier tests pass (`flutter test --no-pub`).
- Android: `flutter build apk --debug --no-pub` succeeds (compile check
  only; no Android device/emulator run).
- First tuning pass from watching the demo: combo was exploding to x5 in a
  few seconds because Forge2D reports each contact to both bodies and
  resting fragments re-trigger contacts. Now each pair is counted once and a
  hit needs 2 m/s relative speed; multiplier step 0.15, cap x4.
- iPhone 12 mini (wireless, iOS 26.6): `flutter run --profile` compiled
  (AOT + shaders, 194 s) and installed `com.ol1n.puff` 1.0.0, built with
  `PUFF_DEMO` + `PUFF_DEBUG` so the fps overlay is on. Launch via Xcode
  automation stalled (needs the "control Xcode" permission prompt) and
  `devicectl` could not launch it because the phone was locked. Unlock the
  phone and open Puff to watch the demo with the fps counter; no numbers
  recorded yet.

## Release build on device (2026-09-03)

- Local Flutter checkout had been hard-reset to 3.41.6 (Dart 3.11.4), below
  the `^3.12.2` SDK constraint, so `pub get` and the Xcode build both failed
  (the missing `FlutterGeneratedPluginSwiftPackage` was a symptom). Reset the
  SDK back to `ad70ec4` = 3.44.4, the revision `.metadata` records.
- `flutter build ios --release`: automatic signing with team P82HWPG7FN,
  `Runner.app` 18.1 MB. No `PUFF_DEMO` / `PUFF_DEBUG` this time, so it is the
  plain game with no fps overlay.
- Installed `com.ol1n.puff` 1.0.0 (build 1) on the cabled iPhone 12 mini and
  launched it with `xcrun devicectl device process launch` — the Xcode
  automation stall from the profile run does not happen over the cable.
- 33 unit tests pass on 3.44.4.

## Store pipeline (2026-09-04)

Wired up against the `Distribution` repo's template.

- **Icon.** New pineapple/banana artwork. The source is 478x556 Display P3
  with paper grain and a grey vignette baked into the bottom-right corner, so
  `tool/gen_icon.py` converts it to sRGB, drops the vignette, collapses every
  cream tone (background, the pineapple's outline and its lattice) to one flat
  `#ECDCC8`, and centres it on a square. Flattening matters: padding a
  textured background out to a square leaves a visible seam. Output is a
  1024x1024 opaque master plus a 60% foreground for the Android adaptive
  safe zone; `flutter_launcher_icons` fans them out.
  - `flutter_launcher_icons` 0.14.4 also rewrites
    `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` from `YES`
    to `AppIcon` in `project.pbxproj` — a naive sed hitting the wrong key,
    since `ASSETCATALOG_COMPILER_APPICON_NAME` was already correct. Reverted;
    re-check after every icon regeneration.
- **Android signing.** `android/app/build.gradle.kts` still had the Flutter
  template signing release with the *debug* key, which Play rejects. Now it
  reads `android/key.properties` when present (written by CI from the
  Bitwarden-backed secrets) and falls back to debug for local dev.
- **Workflows.** `align-project.sh` generated `ci.yml`, `release-ios.yml`,
  `release-android.yml` (tag `v*` / manual), `ios/ExportOptions.plist`, and
  set `ITSAppUsesNonExemptEncryption=false`. iOS Release signing is now
  Manual with a `CI_PROFILE_NAME` placeholder that CI swaps for the real
  profile UUID — so a *local* `flutter build ios --release` no longer works
  until the App Store profile exists. Debug/Profile stay automatic, so
  `flutter run` on a device is unaffected.
- **Not done, needs credentials:** App ID + provisioning profile, the App
  Store Connect app record, Play Console app + first manual AAB, and
  `setup-gh-secrets.sh` (Bitwarden vault is locked).

## Store name (2026-09-04)

App Store Connect rejects "Puff" — the name is taken (closest published
matches: "Puff." by Frosty Pop Games and "Puff Up" by Voodoo, both Games).

Only the *listing* name has to be unique; `CFBundleDisplayName` does not. So
the store listing is **"Puff: Pressure Blast"** while the app stays "Puff" on
the home screen, in `lib/main.dart` and on ol1n.now. No published app uses
that string. Fallbacks if App Store Connect still refuses it (names can be
reserved without ever shipping, and those are invisible from outside):
"Puff: Neon Pressure", "Puff: Pressure Physics".

Fixed in passing: the Android manifest label was the lowercase Flutter
template default `puff`, so Android showed a different name than iOS.

## Store screenshots (2026-09-04)

`tool/gen_screenshots.sh` drives the simulator and dumps frames; the six
keepers live in ol1n.now under `apps/puff/screenshots/raw/mobile/`, and
`make screenshots` there produces the exact store sizes.

- iPhone 17 Pro Max is native 1320x2868, which *is* the App Store 6.9" size,
  so nothing is upscaled. 6.7" and Play phone are downscales of the same
  frames.
- The machine had the iOS 26.5 runtime but zero simulator devices, so the
  script creates the device if it is missing.
- **cfprefsd caches NSUserDefaults inside the simulator.** Writing the app's
  container plist while the simulator is booted does nothing — the app is
  handed the stale value. Two capture rounds were wasted before this showed
  up: every frame said `VACUUM` no matter what the plist said, and the
  palette never changed either. Shut the simulator down, write the plist,
  boot it again. `xcrun simctl spawn <udid> defaults write <bundle> ...` is
  also a dead end; it misses the app's sandboxed domain entirely.
- The demo driver leaves the menu after ~4 s, so the menu frame has to be
  grabbed before that; gameplay frames start ~7 s in.

## 1.0.0 in TestFlight (2026-09-04)

Build 2 uploaded and VALID in App Store Connect under "Puff: Pressure Blast".

Two template assumptions broke the first tagged run:

- **`pod install` is unconditional in the golden workflow.** This project
  resolves its iOS plugins through Swift Package Manager, so there is no
  `ios/Podfile` and the iOS job died before it compiled anything. The step is
  now guarded by `[ -f Podfile ]`, which is a no-op for CocoaPods projects —
  worth pushing back into `Distribution/workflows`.
- **The Firebase App Distribution step has no guard.** `FIREBASE_ANDROID_APP_ID`
  is unset (Puff is not registered in Firebase), so the action failed and
  reddened the Android job *after* it had already built, signed and attached
  a working AAB and APK to the release. Now skipped when the id is empty.

The `v1.0.0` tag still points at `c54e832`, the commit before those fixes;
the retag was blocked locally, so the IPA reached TestFlight through a
`workflow_dispatch` run on master instead. That path skips only the
"attach IPA to GitHub Release" step — the TestFlight upload is not gated on
the ref. The GitHub Release therefore carries the Android artifacts but no
IPA. Move the tag to `386cdd5` or later and re-push if that matters.

## Environment backgrounds (2026-09-06)

`background.frag` had all four branches from the start, but only plasma was
worth looking at — air was a flat grid, water's caustics were invisible, vacuum
was a plain star field. Vacuum now gets a nebula band, three parallax star
layers with diffraction spikes and an occasional meteor; air gets haze banks,
per-row wind streaks and dust; water gets surface caustics, light shafts and
rising bubbles. Plasma is untouched.

- **`patch` is a reserved word in GLSL ES.** A local named that compiles
  nowhere. Caught in the browser preview, not by anything in the Flutter
  toolchain until the shader was actually built.
- **Caustic frequencies are in radians per `q` unit, and `q.x` only spans the
  aspect ratio (~0.46 in portrait).** `sin(q.x * 13.0)` is *one cycle* across
  the screen, i.e. big smooth blobs, which is why the original caustics read as
  nothing at all. They needed ~40.
- Bubbles had to be dimmed and shrunk after seeing them in-game: at full
  strength a bubble ring looks exactly like a circle body you are supposed to
  pop.
- `uWind` is new: the air background drifts with the same wind the physics
  applies, normalised to -1..1 in `BackgroundLayer`.

Iterating on the shader through the simulator is far too slow. Inlining
`common.glsl`, dropping the `#version`/`#include` lines and defining
`FlutterFragCoord()` in terms of `gl_FragCoord` makes the file run unchanged in
a WebGL2 page, which headless Chrome will screenshot in a second or two.
`flutter build bundle` is the quick check that impellerc still accepts it.

## 1.0.1 / 1.0.2 (2026-09-06)

`v1.0.1` shipped the environment backgrounds, `v1.0.2` the water retune. Both
released green on iOS and Android.

- **The Android release workflow had never run since 386cdd5.**
  `if: ${{ secrets.FIREBASE_ANDROID_APP_ID != '' }}` is not legal — the secrets
  context is unavailable in a step-level `if`, so GitHub rejects the whole file
  and reports a zero-job failed run for *any* push, tag filters included. The
  guard now reads a job-level env var. Worth pushing back into
  `Distribution/workflows` along with the Podfile fix; the same pattern is the
  obvious way to write it and it silently disables the workflow.
- The v1.0.1 tag had to be moved onto the fixed commit for the Android half to
  build, so the GitHub Release carries an IPA, an AAB and an APK.
- **Water was unplayable, and it was tuning rather than rendering.**
  `linearDamping: 3.0` consumed a spawn velocity of ~1.15 m/s within 40 cm, and
  gravity 0.35 against that damping is a terminal speed of 0.12 m/s — 80 seconds
  to cross the screen. Shapes stalled at the edge, nothing reached the core, and
  blast fragments stopped where they were born. 1.0 / 0.9 keeps water clearly
  viscous next to air (0.4 / 1.2) and took a demo run from 18 points to 81.

## 1.0.3 — water ripples (2026-09-06)

A blast in water leaves an expanding ring: the background shader draws the
crests and bends the caustics under them, and the front rocks the shapes it
sweeps past.

- The rings live in `sim/ripples.dart`, not in `BackgroundLayer`, because the
  physics needs them too. `EnvironmentForces` ages them and applies the nudge;
  the renderer only reads.
- `q` space is the reason the uniforms stay simple: `q = vec2(uv.x * aspect,
  uv.y)` works out to `(world - rect.topLeft) / rect.height` on *both* axes, so
  a centre in metres and a radius in metres divide by the same number.
- The first attempt looked like a shooting target. A ripple wants a *narrow*
  packet: gaussian 90 → 420, crest wavelength 95 → 150, amplitude down to a
  fifth. Three or four thin circles, gone in 2.6 s.
- The body nudge is `-sin(pi * offset / width)` across the front, which pulls a
  shape toward the oncoming crest and pushes it out behind — it sways and stays
  put. A one-directional push would have blown the shapes outward.
- `liveShapes` allocates a fresh list on every read; the nudge walks it once for
  all three rings rather than once per ring.

## Game Center leaderboards (2026-09-06)

Four leaderboards, one per environment — scores differ by an order of magnitude
between vacuum and water, so a single table would just rank environments.
`lib/app/game_center.dart` wraps `games_services` 5.3.0; the menu and game-over
screens grow a LEADERBOARD button, and every finished run is submitted (Game
Center keeps the best of what it is sent, so local bests are not the gate).

**Before the next release this needs three things done by hand, or the iOS job
will fail to sign:**

1. Apple Developer portal → App ID `com.ol1n.puff` → enable **Game Center**.
2. Regenerate the App Store distribution provisioning profile and replace the
   `IOS_PROVISION_PROFILE_BASE64` secret. The archive now carries
   `com.apple.developer.game-center` (`ios/Runner/Runner.entitlements`) and
   `xcodebuild -exportArchive` rejects a profile that does not grant it.
3. App Store Connect → Puff → Game Center → create four **classic** leaderboards,
   integer score, high-to-low, with IDs exactly:
   `puff.vacuum`, `puff.air`, `puff.water`, `puff.plasma`.
   The ids are built in `GameCenter.leaderboardId`.

Notes from wiring it up:

- **`games_services` 5.3.0 supports Swift Package Manager** (added in 5.1.0), so
  no Podfile came back — the SPM setup survives. It does require Flutter 3.44 /
  Dart 3.12, which is exactly what this project pins.
- **The deployment target had to go from iOS 13 to iOS 14**, the plugin's floor.
- Availability is driven by the `GameAuth.player` *stream*, not by a one-shot
  check after `signIn()`. Authentication finishes well after that future
  resolves, and a player can sign in from iOS Settings mid-session; a one-shot
  check leaves the button hidden until the next launch.
- Everything degrades silently: no Game Center on Android, the player may
  decline, submission may fail offline. The button is simply absent and the
  local high scores carry on. Verified in the simulator, where GameKit fails
  with `GKErrorDomain Code=3` and the app is none the wiser.
- The simulator cannot verify the signed-in half. That needs a sandbox Game
  Center account on a real device with a provisioned build.
