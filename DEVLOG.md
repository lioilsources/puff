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
