# Puff

<!-- Max 80 řádků. Co se nevejde, jde do docs/ a sem jeden odkaz. Veřejné repo: žádné LAN IP, domovské cesty, ID. -->

## Účel
Minimalistická neonová fyzikální hračka (Flutter + Flame + Forge2D, fragment shadery na Impelleru) pro iOS a Android.

## Build a test
```
flutter pub get
flutter analyze --no-fatal-infos   # gate (CI)
flutter test                       # gate (CI)
flutter run -d <device>
flutter run --dart-define=PUFF_DEMO=true   # skriptované dotyky pro screenshoty
dart tool/gen_sfx.dart             # přegenerovat syntetizované SFX
```
CI: `.github/workflows/ci.yml` (analyze, test, debug build Android + iOS). Release: tag `v*` spustí `release-ios.yml` (TestFlight) a `release-android.yml`.

## Mapa
- `lib/game/sim/` čistý Dart (energie, výbuch, fraktura, skóre), bez Flame, unit testy.
- `lib/game/components/`, `physics/`, `fx/`, `input/` Flame komponenty, fyzika, efekty, vstup.
- `lib/game/tuning.dart` všechny ladicí konstanty.
- `lib/app/` menu, nastavení, widgety. `lib/l10n/` lokalizace (ARB).
- `shaders/` GLSL fragment shadery. `store/` texty pro App Store a Google Play.
- `docs/` GitHub Pages (privacy, support, terms).

## Invarianty
- `lib/game/sim/` neimportuje Flame.

## Kam dál
README.md, DEVLOG.md (poznámky po fázích), ROADMAP.md, `Prompts/PUFF_PLAN.md` (spec) a další plány v `Prompts/`.
