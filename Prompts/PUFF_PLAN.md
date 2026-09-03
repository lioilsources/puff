# PUFF — Implementation Plan

Working title: **Puff**. Flutter + Flame + Forge2D, fragment shaders via `FragmentProgram` (Impeller).
Minimalist neon geometry, physics-driven, hold-to-charge / drag / release-to-detonate.

This document is the spec for Claude Code. Work phase by phase. Each phase ends with a
runnable build and a checklist. Do not skip ahead to shaders before core loop feels good.

---

## 0. Ground rules

- Target: iOS + Android, portrait, 60 fps on a mid-range phone (e.g. Pixel 6a / iPhone 12).
- Impeller only. No `--no-enable-impeller`. Verify shaders compile on both platforms early.
- Keep the game logic engine-agnostic where cheap: `lib/game/sim/` must not import Flame.
- All colors come from a `Palette` object. Never hardcode a color in a component or shader.
- Tuning constants live in `lib/game/tuning.dart` — one file, all knobs, hot-reloadable.
- Commit after every phase. Small commits, descriptive messages.
- Write a `DEVLOG.md` entry after each phase: what works, what feels wrong, open questions.

## 1. Project setup (Phase 0)

```
flutter create puff --org com.ol1n --platforms ios,android
```
Dependencies:
- `flame`, `flame_forge2d`, `flame_audio`
- `vector_math`
- `shared_preferences` (settings, unlocks)
- dev: `flutter_lints`, `test`

`pubspec.yaml` → register `shaders/*.frag` under `flutter: shaders:`.

Folder layout:
```
lib/
  main.dart
  app/            # menus, settings, palette picker (plain Flutter)
  game/
    puff_game.dart        # FlameGame + Forge2DGame
    tuning.dart
    palette.dart
    sim/                  # pure Dart: energy model, environment params, scoring
    components/           # Flame components: cloud, shapes, spawner, hud
    physics/              # contact listeners, force fields, explosion impulse
    fx/                   # shader wrappers, particle emitters, screen shake
    input/                # touch state machine
shaders/
  cloud.frag
  shockwave.frag
  bloom_extract.frag
  bloom_blur.frag
  composite.frag
  background.frag
assets/audio/
test/
```

Checklist: app boots to an empty dark screen with a moving test square. Impeller confirmed on both platforms.

## 2. Core loop — the feel (Phase 1)

Goal: hold, drag, release, things fly. Nothing else. Placeholder circles and squares. No shaders.

### 2.1 Input state machine (`input/touch_controller.dart`)
States: `idle → charging → released`. Single-touch only. Ignore second finger.
- `onDown(pos)` → spawn Cloud at pos, `t0 = now`.
- `onMove(pos)` → target position for Cloud (Cloud follows with lag, see 2.2).
- `onUp()` → detonate with `energy = energyCurve(now - t0)`.
- `onCancel()` → detonate at current energy (don't punish system interruptions).

### 2.2 Cloud (`components/cloud.dart`)
- Radius `r(t) = rMin + (rMax - rMin) * energyCurve(t)`.
- `energyCurve(t)`: ease-in for first 0.3 s, then near-linear, then asymptotic toward `tOverpressure`.
  Expose as a `Curve` in tuning so it can be swapped.
- Movement: Cloud position lerps toward finger with `lag = lagBase + lagPerRadius * r`. Bigger cloud = heavier.
- Cloud is a Forge2D **sensor** body (no collision response) so we know what's inside/touching it.
- Objects that overlap the cloud drain energy: `energy -= drainRate * dt` per overlapping body.
  Visual: cloud jitters when drained.
- Overpressure: if `t > tOverpressure` → self-detonate with `energy * overpressurePenalty` (e.g. 0.5) and a distinct "fizzle" effect.

### 2.3 Detonation (`physics/explosion.dart`)
On release, for every dynamic body within `radiusOfEffect(energy)`:
```
d = body.pos - cloud.pos
dist = max(|d|, rMin)
falloff = (1 - dist / radiusOfEffect)^falloffPower
impulse = normalize(d) * energy * impulseScale * falloff * environment.blastMultiplier
body.applyLinearImpulse(impulse)
body.applyAngularImpulse(torqueScale * energy * falloff * randomSign)
```
Also: mark bodies that received `impulse > breakThreshold(shape)` for fracture (Phase 3).
Detonation returns an `ExplosionEvent(pos, energy, kind)` consumed by FX and audio.

### 2.4 Shapes (`components/shape_body.dart`)
Enum `ShapeKind { tri, square, poly(n), circle }`. Each has:
- mass, restitution, friction
- `breakThreshold`
- `fractureRule` (Phase 3)
Spawner emits shapes from screen edges with random velocity toward the center. Rate ramps with time.

### 2.5 Scoring (pure Dart, `sim/score.dart`)
- Points per body displaced ∝ impulse delivered.
- Combo: shapes hitting other shapes within `comboWindow` after a blast add multiplier.
- Fracture bonus.
- Lose condition (endless mode): N shapes escape through the bottom edge / or shapes touch a "core" at screen center. Pick one, implement, note it in DEVLOG.

Checklist: it is fun to hold, drag, release for 60 seconds with placeholder graphics. Tune until yes.
Record `tuning.dart` values that felt best.

## 3. Environments (Phase 2)

`sim/environment.dart`:
```dart
class Environment {
  final double linearDamping;    // vacuum 0, air 0.4, water 3.0, plasma 0.6
  final double angularDamping;
  final double blastMultiplier;  // water 0.6, vacuum 1.4
  final double gravityY;
  final Vector2 globalWind;      // optional, sinusoidal
  final Modifier? ambientModifier; // plasma: periodic arcs
}
```
Presets: `vacuum`, `air`, `water`, `plasma`. Switchable at runtime (settings + debug key).
Environment affects both physics and (later) background shader parameters.

Checklist: all four feel distinct with the same input.

## 4. Fracture (Phase 3)

`physics/fracture.dart`:
- `tri` → 3 smaller tris (from centroid to edges).
- `square` → 4 squares or 2 rects depending on impulse angle.
- `poly(n)` → n tris around centroid; each tri may itself fracture once more (`maxDepth` in tuning).
- `circle` → never breaks.
Children inherit velocity + outward component. Cap live body count (`maxBodies` ~ 200);
beyond that, spawn lightweight non-physics **debris particles** instead (see 6.3).

Checklist: chain fractures without frame drops. Profile with `flutter run --profile`.

## 5. Modifiers (Phase 4)

`sim/modifier.dart`, all implement `applyTo(ExplosionEvent, bodies)` or a per-frame `forceField(dt)`:
- `Pressure` — default (Phase 1 logic).
- `Implosion` — negative impulse, then a delayed small outward pop.
- `Magnet` — only affects `ShapeMaterial.metal`; introduce material tag on shapes.
- `GravityWell` — persistent radial force field for `duration`, decays.
- `ChainSpark` — after blast, raycast to nearest N bodies; arc between them and apply impulse chain.
Selected modifier is a property of the current run; UI to switch comes later.

## 6. Rendering & shaders (Phase 5)

Order matters: bloom pipeline first, then cloud shader, then shockwave.

### 6.1 Render pipeline
1. Draw game world into an offscreen `ui.Image` via `PictureRecorder` (scene target, full res or 0.75x).
2. `bloom_extract.frag` → threshold bright pixels (half res).
3. `bloom_blur.frag` → two-pass separable Gaussian (quarter res, 2 iterations).
4. `composite.frag` → scene + bloom + shockwave distortion + chromatic aberration + vignette.
Implement as `fx/post_process.dart`. Provide a `PostProcessQuality {low, med, high}` knob.
Low = no bloom, just additive glow sprites.

### 6.2 Shaders (GLSL, Flutter fragment shader conventions)
- `cloud.frag` — uniforms: center, radius, energy, time, paletteAccent. Soft edge + internal
  noise swirl + pulsing rim that speeds up with energy. Near overpressure: rim flickers.
- `shockwave.frag` — ring distortion: for each active explosion (max 4, pass as uniform arrays)
  offset UV radially by `strength * gaussian(dist - ringRadius(t))`. Ring speed ∝ energy.
- `background.frag` — per-environment: vacuum = star noise, air = faint grid drifting,
  water = caustics, plasma = electric noise + occasional flash. All driven by palette.

### 6.3 Particles
Debris: custom lightweight system rendered with `Canvas.drawVertices` (one draw call).
Each particle: pos, vel, life, size, colorIndex. No per-particle Flame components.
Spark trails on fast bodies (velocity above threshold).

### 6.4 Camera
Screen shake: trauma model (`shake = trauma^2`), trauma added per explosion energy, decays.
Slight zoom-out pulse on big blasts.

Checklist: 60 fps on target device with bloom at `med` and ~150 bodies + 500 particles.

## 7. Palette system (Phase 6)

```dart
class Palette {
  final Color bg, bgAlt, primary, secondary, accent, hazard, glow;
  final String name;
}
```
- Ships with 6 built-ins (e.g. `Cyberpunk`, `Vaporwave`, `Acid`, `Mono`, `Ember`, `Arctic`).
- JSON-serializable. Palette editor screen in `app/` (later).
- Every component and every shader reads colors from the active palette at frame time.
  Shapes map `ShapeKind` → palette role. Explosion kind → role.

## 8. Audio (Phase 7)
- Charge: looping tone whose pitch rises with energy (`flame_audio` + pitch, or pre-baked 5 stages).
- Release: layered — sub thump scaled by energy + crack + tail. Water: muffled variant.
- Fracture: short glass-like tick, random pitch.
- Keep all SFX synthesized/CC0. Placeholder is fine; note in DEVLOG.

## 9. Meta & shell (Phase 8)
- Main menu, endless mode, palette picker, environment picker, modifier picker, settings (quality, haptics).
- Haptics on release scaled to energy.
- Local high score per environment. No accounts, no backend for MVP.

## 10. Testing
- Unit tests for `sim/`: energy curve monotonic, impulse falloff, score combos, fracture rules.
- Golden-free: don't snapshot-test shaders. Add a `debug` overlay with fps, body count, particle count, current tuning.

## 11. Open questions (answer in DEVLOG as you go)
- Lose condition: bottom-edge escape vs. central core? Prototype both quickly in Phase 1.
- Should cloud block projectiles (shield behavior) or only be drained by them?
- Is overpressure penalty fun or annoying? Try penalty 0.5 vs. "no penalty but random direction".

## 12. Definition of done (MVP)
Endless mode, 4 environments, 4 shape kinds with fracture, 3 modifiers, bloom + shockwave shaders,
6 palettes, audio, haptics, 60 fps on target devices, TestFlight + internal Play build.
