# Puff v prohlížeči (Babylon.js)

Webová verze hry: <https://lioilsources.github.io/puff/play/> (po přepnutí GitHub Pages na Actions).
Je to port Flutter aplikace (kořen repa) do TypeScriptu nad Babylon.js 9 (WebGL2) a planck.js (Box2D, jako Forge2D).
Kód je v `babylon/`, mapa portu, paritní úrovně a odchylky jsou v
[`babylon/PORT.md`](https://github.com/lioilsources/puff/blob/master/babylon/PORT.md).

## Spuštění

```bash
cd babylon
npm ci
npm run dev      # http://localhost:5173
npm run gate     # lint + testy + build, totéž běží v CI
```

Deep linky: `?seed=<n>` opakovatelné spawny, `?env=vacuum|air|water|plasma`, `?palette=<id>`, `?debug` FPS.
Ovládání: podrž prst nebo myš, táhni, pusť.

## Vrstvy

| Složka | Obsah |
|---|---|
| `src/rules/` | čistá simulace (energie, výbuch, fraktura, skóre, heat, spawner), bez Babylonu, planck.js a DOM, hlídá ESLint |
| `src/game/` | Babylon scéna, planck.js svět, herní smyčka s pevným krokem, vstup |
| `src/ui/` | DOM: HUD, konec hry s odkazy do obchodů |

## Jedna pravda: Flutter

- Konstanty: `dart run tool/dump_vectors.dart` (z kořene repa) zapíše `lib/game/tuning.dart` do
  `babylon/src/rules/generated/tuning.json` a výstupy `lib/game/sim/` do `babylon/test/golden/`; Vitest je přehraje.
  CI job `golden` je přegeneruje a porovná. Kdo změní simulaci v Dartu, spustí nástroj a commitne výsledky.
- Barvy: `npm run gen` čte `lib/game/palette.dart` (`dart:ui` v Dart VM neběží), test hlídá rozjezd.

## Nasazení

Workflow `.github/workflows/web.yml`: při push do `master` postaví `babylon/`, zkopíruje `docs/` do kořene a hru
pod `/play/`. Nasazuje, jen když je zdroj Pages „GitHub Actions“; dokud repo servíruje `docs/` z větve, deploy se
přeskočí a dnešní web běží beze změny. Na olin.now pak vede na hru pole `play:` v `apps/puff/meta.md`.
