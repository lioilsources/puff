# Puff

Minimalist neon physics toy: **hold** to charge a pressure cloud, **drag** it
around, **release** to blast the geometry drifting toward the core.

Flutter + Flame + Forge2D (Box2D v3), fragment shaders via `FragmentProgram`
on Impeller.

## Run

```
dart pub get --offline        # or plain `flutter pub get` if pub.dev is fast for you
flutter run --no-pub -d <ios-device-or-simulator>
flutter run --no-pub --dart-define=PUFF_DEMO=true   # scripted touches for screenshots
flutter test --no-pub
dart tool/gen_sfx.dart        # regenerate the synthesized SFX
```

## Layout

- `lib/game/sim/` pure Dart: energy curve, blast math, fracture rules,
  scoring, environments, modifiers. No Flame imports, unit tested.
- `lib/game/components/` Flame components: cloud, shapes, core, spawner, HUD.
- `lib/game/physics/` detonator, fracture system, modifier system, force fields.
- `lib/game/fx/` shaders, bloom post-process, particles, arcs, shake, audio, haptics.
- `lib/app/` menus, settings, neon widgets.
- `shaders/` GLSL fragment shaders. `lib/game/tuning.dart` holds every knob.

See `DEVLOG.md` for per-phase notes, `Prompts/PUFF_PLAN.md` for the spec and
`Prompts/PUFF_MONETIZATION.md` for the monetization strategy.
