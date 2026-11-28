# Puff → Babylon.js: mapa portu

Webový klient Puffu v TypeScriptu nad Babylon.js a planck.js. Zdroj pravdy je Flutter appka v kořeni repa
(simulace v `lib/game/sim/`, konstanty v `lib/game/tuning.dart`). Plán: `DevConventions/Prompts/06-PLAN-babylon-web.md`
(vlna 2, řádek Puff), kostra ze šablony `DevConventions/templates/babylon`, vzor: Kačeny (`Kaceny/babylon`).
Stav: **F0 (audit a spike)**. Hostování: GitHub Pages repa, hra pod `/play/`, `docs/` (index, privacy, support, terms)
zůstává v kořeni. Web je demo vedle appky v obchodech (plán 06, R4): celá hra s odkazy na App Store a Google Play.

## Úrovně parity

- **P0**: diskrétní pravidla (skóre, combo, heat stupně, výběr tvaru, fraktura: kolik kusů a které jsou prach),
  shoda přes zlaté vektory z Dartu.
- **P1**: spojitá čísla simulace (energie oblaku, impuls výbuchu, geometrie tvarů a úlomků): zlaté vektory na 1e-9,
  v praxi přesně (viz Odchylky 1). Fyzika (planck.js místo Forge2D) shodu bit po bitu nedává, jen stejné chování.
- **P2**: vzhled: neonové obrysy s glow, oblak, jádro, HUD. Ne pixel po pixelu, bez Impeller shaderů.

## Vrstvy

| Složka | Obsah | Hlídá |
|---|---|---|
| `src/rules/` | čistá simulace: energie, výbuch, fraktura, skóre, heat, tvary, spawner, konstanty | ESLint: bez Babylonu, planck.js, DOM, `game/`, `ui/` |
| `src/game/` | Babylon scéna (ortografická kamera v metrech, y dolů), planck.js svět, smyčka s pevným krokem 1/60 s, vstup | — |
| `src/ui/` | DOM: HUD, konec hry s odkazy do obchodů, generovaná paleta | ESLint: bez Babylonu a `game/` |

## Mapa Dart → TS po souborech

### Čistý Dart (`lib/game/sim/` 1 516 ř., `tuning.dart` 236 ř., jen `vector_math`) → `src/rules/`

| Dart | ř. | TS | Parita | Stav |
|---|---|---|---|---|
| `tuning.dart` | 236 | `tuning.ts` + `generated/tuning.json` | P0 | F0: hodnoty dumpuje Dart, ne ručně |
| `sim/energy.dart` | 85 | `energy.ts` | P1 | F0, vektory |
| `sim/blast.dart` | 83 | `blast.ts` | P1 | F0, vektory |
| `sim/score.dart` | 89 | `score.ts` | P0 | F0, vektory |
| `sim/heat.dart` | 58 | `heat.ts` | P1 | F0, vektory |
| `sim/shapes.dart` | 178 | `shapes.ts` | P1 | F0, vektory včetně `ShapeFactory` se seedem |
| `sim/fracture.dart` | 165 | `fracture.ts` | P1 | F0, vektory (i úlomky úlomků a hloubka 3) |
| `sim/environment.dart` | 102 | `tuning.ts` (`environments` v dumpu) | P0 | F0 data; vítr F2 |
| `sim/seeded_random.dart` | 27 | `random.ts` (`gameRandom(seed)` = Dart `LcgRandom`) | — | F0 |
| `sim/modifier.dart` | 132 | `rules/modifier.ts` | P0 | F1 (tlak, imploze, magnet, studna, řetěz, plazma) |
| `sim/achievements.dart` | 144 | `rules/achievements.ts` | P0 | F3 (jen místně) |
| `sim/season.dart` | 196 | `rules/season.ts` | P0 | F3 (sezónní palety) |
| `sim/weekly.dart` | 64 | `rules/weekly.ts` | P0 | F3 (týdenní výzva = seed) |
| `sim/jukebox.dart` | 63 | `rules/jukebox.ts` | P0 | F3 |
| `sim/ripples.dart` | 60 | `rules/ripples.ts` | P1 | F2 (voda) |
| `sim/explosion_event.dart`, `fx_event.dart` | 70 | typy událostí v `game/` | — | F2 |
| `palette.dart` | 170 | `ui/generated/palette.ts` | P2 | F0, `npm run gen` čte zdroják (`dart:ui` v Dart VM neběží) |

### Flame + Forge2D (`lib/game/components`, `physics`, `fx`, `input`, `puff_game.dart`; 3 587 ř.) → `src/game/`

| Dart | ř. | TS | Stav |
|---|---|---|---|
| `puff_game.dart` | 587 | `game/main.ts` (běh, výbuch, jádro, konec) | F0 bez menu, pauzy, modifikátorů a FX |
| `components/spawner.dart` | 208 | `rules/spawner.ts` (čistý) | F0 běžné spawny; Kolos a salvy F2 |
| `components/shape_body.dart` | 194 | `game/physics.ts` + `game/scene.ts` | F0 (obrys, kovový vnitřní obrys, záblesk) |
| `components/cloud.dart` | 157 | `game/main.ts` (nabíjení, odsávání, zpoždění) + `scene.ts` | F0; shader oblaku F2 |
| `components/core.dart` | 86 | `physics.ts` (senzor) + `scene.ts` | F0 |
| `components/hud.dart` | 174 | `ui/hud.ts` | F0 základ (skóre, combo, životy, tlak); heat toast F2 |
| `components/background.dart` | 93 | `scene.ts` | F2 |
| `components/touch_layer.dart`, `input/touch_controller.dart` | 106 | `main.ts` (pointer events) | F0 |
| `components/debug_overlay.dart` | 70 | `?debug` | F0 jen FPS |
| `physics/explosion.dart` | 89 | `main.ts` `detonate()` | F0 |
| `physics/fracture.dart` | 112 | `main.ts` `fractures()` | F0 (bez rozpočtu těl a prachových částic) |
| `physics/force_fields.dart`, `modifiers.dart` | 273 | `game/fields.ts` | F1–F2 |
| `fx/*` (částice, rázová vlna, shake, bloom, aberace, oblouky) | 1 362 | `game/fx.ts` | F2: glow layer už v F0, zbytek postprocess Babylonu |
| `fx/audio.dart`, `fx/jukebox.dart` | 445 | Web Audio | F3 |
| `fx/haptics.dart` | 64 | `navigator.vibrate`, kde je | F3 |
| `input/demo_driver.dart` | 76 | `?demo` | F2 (videa) |

### Flutter UI a služby (`lib/app/`, `main.dart`; 1 851 ř.) → `src/ui/`

| Dart | ř. | Web |
|---|---|---|
| `app/overlays.dart` | 494 | menu, pauza, konec hry: F2 |
| `app/settings.dart` | 189 | `localStorage` (kvalita, zvuk, hudba, klidný režim): F2 |
| `app/theme.dart` | 252 | CSS proměnné z palety: F2 |
| `app/deep_link.dart` | 63 | URL parametry (`?seed`, `?env`): F0 částečně |
| `app/share_card.dart` | 178 | Web Share API / stažení PNG: F3 |
| `app/game_center.dart` | 305 | **vypouští se** (Game Center / Play Games na webu nejsou), jen místní rekord |
| `app/review_policy.dart` | 26 | **vypouští se** (in_app_review) |
| `app/remote_config.dart` | 51 | **vypouští se** v F0; rozhodnout v F3 |
| `l10n/` (15 jazyků ARB) | — | F3, texty z ARB |

## Zlaté vektory

`dart run tool/dump_vectors.dart` (z kořene repa, po `flutter pub get`). CI job `golden` je přegeneruje a porovná
`babylon/test/golden/` a `babylon/src/rules/generated/` bajt po bajtu.

| Soubor | Co pokrývá |
|---|---|
| `blast.json` | 80 výbuchů: uvnitř i mimo dosah, tělo ve středu, vlastní poloměr, obrácený směr |
| `energy.json` | 12 nabíjení s náhodným `dt` a odsáváním těly: energie, přetlak, výsledná energie |
| `fracture.json` | 24 tvarů z továrny a jejich první úlomky, impuls podél os i šikmo, hloubka 2 a 3 |
| `heat.json` | heat po 2,5 s do 300 s: stupeň, škála poloměru a impulsu výbuchu, `heatLerp` |
| `score.json` | 12 časových os s výbuchy, impulsy, zásahy a frakturami: skóre, combo, násobič |
| `shapes.json` | 8 × 12 tvarů z `ShapeFactory` se seedem: spec, vrcholy, plocha, těžiště |
| `generated/tuning.json` | konstanty z `Tuning` a prostředí (TS je importuje) |

## Funkce

Jedna řádka na funkci = jedno video (plán 06, kap. 5a). Id funkce = `?demo=<id>` (F2).

| Id | Funkce | W | F |
|---|---|---|---|
| `hold` | podrž: oblak roste, tlak stoupá | | |
| `release` | pusť: výbuch rozmetá tvary, body za impuls | | |
| `drag` | táhni: oblak jde za prstem se zpožděním podle velikosti | | |
| `overpressure` | držíš moc dlouho: přetlak, oblak vybuchne slabě sám | | |
| `drain` | tvary uvnitř oblaku mu ujídají tlak | | |
| `fracture` | silný zásah tvar rozbije, úlomky se dají rozbít znovu | | |
| `combo` | srážky tvarů po výbuchu zvedají combo | | |
| `core` | tvar, který doletí k jádru, ubere život | | |
| `heat` | běh se rozpaluje: víc, větších a rychlejších tvarů, Kolos, salvy | | |
| `modifiers` | tlak, imploze, magnet, studna, řetěz, plazma | | |
| `environments` | vakuum, vzduch, voda, plazma | | |
| `palettes` | sedm neonových palet | | |
| `weekly` | týdenní výzva: stejné spawny pro všechny | | |
| `web-play` | odkaz z olin.now → hraje se za pár vteřin | | |

## Co se na webu vypouští

- **Game Center / Play Games** (`games_services`): žebříčky a achievementy obchodů. Na webu jen místní rekord.
- **Hodnocení v obchodě** (`in_app_review`).
- **Shadery Impelleru** (`shaders/*.frag`): bloom, aberace, rázová vlna a oblak se v F2 přepíšou na postprocess
  Babylonu (glow layer je už v F0). Kód GLSL je podobný, ale Flutter `FragmentProgram` se nekopíruje.
- **Nákupy**: Puff v `pubspec.yaml` žádné nemá (plán 06 uvádí IAP omylem). Web je celá hra zdarma s odkazy do
  obchodů na konci běhu.

## Assety

| Co | Velikost | Web |
|---|---|---|
| `assets/audio/music/` (10 skladeb OGG) | 24 MB | F3, až po prvním snímku, jedna skladba podle prostředí |
| `assets/audio/*.wav` (21 SFX) | 1,2 MB | F3, po prvním snímku |
| `assets/icon/` | 6,9 MB | ne (PWA ikona v F4 z `docs/icon.png`) |
| `shaders/` | 32 kB | ne, přepis v F2 |
| tvary, oblak, jádro | kód | F0, výchozí |

`npm run assets` kopíruje před buildem, v gitu je jen Flutter kopie. F0 nekopíruje nic.

## Měření F0 (lokálně, 24. 11. 2026)

Chromium headless, viewport 430×932, mediány ze 3 běhů, statický server bez komprese.
Pomalá síť = 4 Mbit/s, RTT 100 ms, CPU ×4. Flutter web = `flutter build web --release` v zahozené kopii
(repo nemá platformu web).

| | Flutter web | Babylon spike |
|---|---|---|
| Build | 68 MB (z toho 24 MB hudba, 36 MB CanvasKit/Skwasm) | 1,8 MB (gzip 0,43 MB) |
| Přeneseno do 1. snímku | 4,5 MB | 1,5 MB (gzip ≈ 0,4 MB) |
| 1. snímek, rychlá síť | 0,49 s | 0,08 s |
| 1. snímek, pomalá síť + CPU ×4 | 10,3 s | 3,2 s |

GitHub Pages posílá gzip, takže na Pages bude Babylon stahovat zhruba čtvrtinu. Měření na telefonu a FPS zbývá.

## Odchylky

1. **float32 vektory:** `Vector2` z `vector_math` ukládá `Float32List`. Každý zápis (`Vector2(…)`, `-`, `+`, `*`, `/`)
   se v Dartu zaokrouhlí na float32, aritmetika mezi tím je double, a `v / s` je `v * (1 / s)`. TS to dělá
   stejně přes `Math.fround` (`rules/vec.ts`). Zlaté vektory sedí napoprvé.
2. **Fyzika:** planck.js místo Forge2D. Obojí je Box2D se stejnými jednotkami, tělesy a impulsy, ale krok solveru
   není bit po bitu stejný. Pevný krok 1/60 s místo Flame `dt` za snímek (strop 1/30 s zůstává).
3. **Náhoda:** `SeededRandom` nad `dart:math` se nekopíruje. Web bere `gameRandom(seed)` (stejný LCG jako dump),
   `?seed=` dává opakovatelné spawny. Hra bez seedu bere `Math.random`.
4. **Paleta** se čte ze zdrojáku `palette.dart` (`dart:ui` v Dart VM nejde spustit), ne z dumpu. Hlídá ji `config-sync`.
5. **Spawner** je ve Flutteru Flame komponenta; web ho má jako čistou třídu v `rules/`, která vrací požadavky
   na spawn. Pořadí náhodných tahů je stejné jako v Dartu.
6. **Kořen repa:** Flutter appka je v kořeni (jako u Kačen), Pages jsou dnes legacy z `master:/docs`.
