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

