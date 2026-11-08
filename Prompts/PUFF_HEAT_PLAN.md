# PUFF — Heat (escalation) plan

Spec for Claude Code (Opus). Work phase by phase, each phase ends with a
runnable build and a DEVLOG entry, as `PUFF_PLAN.md` asks. Read
`lib/game/tuning.dart`, `lib/game/components/spawner.dart`,
`lib/game/physics/explosion.dart`, `lib/game/fx/fx_system.dart` and
`lib/game/puff_game.dart` before touching anything.

Trigger (2026-10-13): "Chtělo by to, aby to bylo časem větší maso, větší
výbuchy a tak." A run today gets *busier* (spawn interval 1.6 s → 0.45 s
over 150 s, `Spawner.interval`) but never *bigger*: shape size, metal
share, spawn speed, blast radius, impulse, particles, shake, shockwave,
flash and SFX are the same in second 10 and second 300. Everything scales
with the charge energy of one blast, nothing scales with the run.

This plan adds one number, **heat**, that rises with the run, and makes
every system that already scales with energy also scale with heat. It is a
spectacle ramp first and a danger ramp second: the player should feel the
game getting heavier, louder and more explosive before it gets harder.

---

## 0. What changes for the player

- Minute 0: exactly today's game. Nothing in the first 20 s changes, so the
  first run of a new player stays as it is (ROADMAP §5, D1 gate).
- Minute 1: shapes start arriving bigger and faster, more of them metal. A
  full-charge blast throws further and the ring on screen is wider.
- Minute 2: the first **Kolos**, a 7–8-sided polygon two to three times the
  normal size, drifts in. It needs a full blast to crack and breaks into a
  shower of fragments that break again. Blasts now shake the camera
  harder, the bloom glows hotter, the release sound has a low boom under
  it.
- Minute 3+: **Overdrive**. Kolosy every ~25 s, volleys of three to five
  shapes from one edge, blast radius +30 %, and the HUD says so.
- Tiers are announced in the HUD centre for 1.5 s when crossed
  (`HEAT II`, `HEAT III`, `OVERDRIVE`); the status line keeps the
  environment name. No new overlay, no new screen.

Not changing: the lose rule (core, 5 HP), charge timing, modifiers, the
score formula, environments, palettes, music tracks. Scores *will* inflate
with heat, see §6.

---

## 1. The heat curve

### 1.1 Definition

`lib/game/sim/heat.dart`, pure Dart, no Flame, unit-tested:

```dart
/// How far a run has escalated: 0 at the start, 1 at [fullAt] seconds,
/// up to [max] in overdrive. Every escalating knob is a lerp on this.
class HeatCurve {
  const HeatCurve({
    this.warmUp = 20,     // seconds of exactly today's game
    this.fullAt = 150,    // heat 1.0 — same point the spawn ramp ends today
    this.overdriveAt = 240,
    this.max = 1.5,
  });

  /// Smoothstep from warmUp to fullAt, then linear to max at overdriveAt.
  double at(double elapsed);

  /// 0..4: 0 below warmUp, 1 at heat>0, 2 at 0.5, 3 at 1.0, 4 in overdrive.
  int tierAt(double elapsed);
  static const tierNames = ['', 'HEAT I', 'HEAT II', 'HEAT III', 'OVERDRIVE'];
}
```

Elapsed is `PuffGame.elapsed`, which already stops in pause and resets on
`startGame`. Heat depends on elapsed only: a seeded run (`PuffGame(seed:)`,
daily challenge, `DemoDriver`) stays deterministic, and the combo surge in
§1.2 is the only other input.

First-pass timeline (tune in Phase 4):

| t | heat | tier | what the player sees |
|---|---|---|---|
| 0–20 s | 0 | – | today's game |
| 60 s | 0.3 | I | bigger shapes begin, blast ring visibly wider |
| 100 s | 0.7 | II | first Kolos, metal share up, bloom hotter |
| 150 s | 1.0 | III | full escalation, Kolos every 40 s, volleys |
| 240 s+ | 1.5 | OVERDRIVE | Kolos every 25 s, caps reached |

How fast is a judgement call that has to be made with the phone in hand.
The spawn ramp already ends at 150 s and the game was tuned around that,
so heat 1.0 lands there too. If runs rarely reach 150 s today, pull
`fullAt` to 120 before pushing anything else.

### 1.2 Combo surge (small, optional in Phase 2)

`heat.effective = base(elapsed) + surge`, where `surge = 0.15 *
min(score.combo / 8, 1)` and decays with the combo window. A player on a
streak gets slightly bigger blasts for the streak's duration. It touches
only blast/FX scaling (§3, §4), never spawning, so it cannot make the game
harder. Skip it if it muddies the feel.

### 1.3 Tuning table

All lerps are `a + (b - a) * heat.clamp(0, 1)` unless marked `×1.5` for
overdrive. New constants go in `Tuning` next to the ones they extend, with
`Heat` in the name (`spawnMaxSizeHot`, `blastRadiusHot`, ...).

| Knob | today | heat 1.0 | overdrive (1.5) | where |
|---|---|---|---|---|
| spawn interval | 1.6 → 0.45 s | (same ramp, now `1 - heat`) | 0.4 s | `Spawner.interval` |
| shape size range | 0.26–0.50 | 0.32–0.80 | 0.35–0.90 | `Spawner.spawnOne` |
| metal chance | 0.30 | 0.45 | 0.5 | `ShapeFactory.next` (pass in) |
| spawn speed max | 1.6 | 2.3 | 2.6 | `Spawner.spawnOne` |
| Kolos interval | – | 40 s from heat ≥ 0.6 | 25 s | new, `Spawner` |
| Kolos size | – | 1.1–1.4, poly 7–8, break × size/0.4 (same rule) | 1.2–1.5 | new |
| volley (3–5 from one edge) | – | every 30 s from tier III | every 20 s | new, `Spawner` |
| blast roeMax | 4.2 | 5.2 | 5.6 | `Detonator.detonate` radius |
| blast impulseScale | 11 | 14 | 15.5 | `Detonator.detonate` multiplier |
| cloud rMax | 1.45 | 1.75 | 1.9 | `Cloud.update` |
| fracture maxDepth | 2 | 3 for shapes ≥ 0.8 m | same | `FractureSystem` |
| particles per blast | 18+70e | ×(1 + 0.6·heat) | ×1.9 | `FxSystem.onExplosion` |
| particle speed | 2.5+7e | ×(1 + 0.3·heat) | | same |
| shake trauma | 0.22+0.55e | ×(1 + 0.4·heat) | | same |
| zoom pulse threshold | e > 0.55 | e > 0.55 − 0.2·heat | | same |
| shockwave radius | 0.3+4.5e | ×(1 + 0.3·heat); second ring 0.12 s later when e·heat > 0.6 | | `Shockwave`, `FxSystem` |
| flash | 0.05+0.18e | ×(1 + 0.3·heat) | | same |
| bloomIntensity | 1.35 | 1.6 | 1.7 | `PuffPostProcess`, set per frame |
| aberration | 0.006 | 0.010 | 0.012 | same |
| release SFX | low/mid/high by e | + `release_boom.wav` layer when e·(1+heat) > 0.9 | | `AudioSystem.onExplosion` |
| haptics | heavy at e ≥ 0.7 | heavy at e ≥ 0.7 − 0.2·heat | | `HapticsSystem` |
| maxBodies | 200 | 200 | 200 | unchanged, hard cap |

Not scaled: `tOverpressure`, `drainRate`, `breakThreshold` base, core HP,
gravity, damping, music volume.

---

## 2. Phase 1 — heat exists, shapes grow (1 day)

1. `sim/heat.dart` + `test/heat_test.dart`: warm-up is exactly 0, 1.0 at
   `fullAt`, monotonic, max never exceeded, tier boundaries, determinism.
2. `PuffGame`: `late final HeatCurve heatCurve = const HeatCurve()`,
   `double get heat`, `int get tier`, updated from `elapsed`. A
   `--dart-define=PUFF_HEAT=1.2` override (like `PUFF_DEMO`) pins heat for
   screenshots, clips and tuning. `_clearRun` resets nothing new: heat is
   derived.
3. `Spawner`: `interval` reads `game.heat` instead of its own `_elapsed`
   (one source of truth; `_elapsed` can go). Size range, speed max and
   metal chance lerp per §1.3. `ShapeFactory.next` gets a `metalChance`
   parameter with the field as default.
4. **Kolos**: `Spawner` keeps a `_kolosCooldown`; when heat ≥ 0.6 and the
   cooldown is up and `liveShapes.length < maxBodies - 40`, spawn one
   `ShapeKind.poly` with 7–8 sides, size per table, slower (0.5–0.8 m/s),
   heavier spin. `ShapeSpec` needs nothing new: break threshold already
   scales with size, density stays 1.0 (metal Kolos would be a wall).
5. **Volley**: from tier III, every N s, 3–5 ordinary shapes from the same
   edge 0.12 s apart. Reuse `spawnOne` with an `edge:` parameter.
6. `DebugOverlay`: add `heat 0.42 tier II  kolos in 12s` to the spawn line.
7. DEVLOG entry. Runnable: play two minutes, watch shapes grow, meet a
   Kolos. Blasts are still today's, so the Kolos will feel *too* tough —
   that is Phase 2's job, note it rather than tune around it.

Guard: `Spawner.spawnOne` already returns when `shapes.length >=
maxBodies`. Keep that, and make Kolos and volley stricter (the −40 margin)
so fragments of a Kolos always have room.

## 3. Phase 2 — bigger blasts and FX (1 day)

1. `Detonator.detonate`: `radius = radiusOverride ?? Tuning.blast
   .radiusOfEffect(energy) * heatRadius`, `blastMultiplier *= heatImpulse`.
   Both read `game.heat` through two small helpers in `Tuning`
   (`blastRadiusScale(heat)`, `blastImpulseScale(heat)`) so tests can call
   them. `radiusOverride` callers (gravity well) keep their own value.
2. `Cloud.update`: `rMax` lerp. The HUD charge bar is energy-based and
   needs no change.
3. `FractureSystem`: pass `maxDepth: 3` when `shape.spec.size >= 0.8`
   (Kolos and its first-generation shards) *and* `shapes.length < 140`;
   otherwise today's 2. `FractureRules` takes depth per call already.
4. `FxSystem.onExplosion`: particles, shake, zoom, shockwave, flash per
   §1.3; second shockwave ring via `modifiers.schedule(0.12, ...)` or a
   local delayed list. `addShockwave` cap 4 → 6.
5. `PuffPostProcess`: `bloomIntensity` and `aberration` set from heat each
   frame in `FxSystem.update` (they are plain fields).
6. `HapticsSystem`: threshold shift.
7. HUD: tier toast in `_center` (currently always `''`): on tier change
   show `tierNames[tier]` for 1.5 s with the same stepped-opacity fade the
   music toast uses. Do not show it in the first 20 s (tier 0 → 1 is the
   only transition there and it is silent).
8. **Profile on the iPhone 12 mini and the Pixel 6 emulator** with
   `PUFF_HEAT=1.5` and `PUFF_DEBUG=true`: fps, bodies, particles at
   overdrive with a Kolos fracturing. DEVLOG "Not done" still lists
   on-device profiling as never done; this is where it has to happen. If
   fps drops below 50 at med quality on the 12 mini: lower particle
   multipliers first, then fracture depth, never maxBodies.
9. DEVLOG entry. Runnable: a Kolos cracks on a full blast at heat 0.7, the
   screen reacts visibly more at minute 3 than at minute 1.

## 4. Phase 3 — sound (½ day)

1. `tool/gen_sfx.dart`: add `release_boom.wav`, a 0.6 s low sine/noise
   boom (40–80 Hz sweep, soft clip), −6 dB relative to `release_high`.
2. `AudioSystem.onExplosion`: layer it under the release when
   `e * (1 + heat) > 0.9`; volume `0.5 + 0.5 * heat`. Keep water's muffled
   takes; the boom plays there too, it reads as depth.
3. Optional, only if it is one evening: `JukeboxSystem.intensity = heat`,
   mapped to a SoLoud low-pass on the music handle that opens from ~2 kHz
   at heat 0 to fully open at heat 0.5. Check `flutter_soloud`
   `BiquadResonantFilter` on a disk-streamed source first; if it is not a
   five-line change, drop it. Music following the run is not what the
   review asked for and the tracks are mastered to stand on their own.
4. DEVLOG entry.

## 5. Phase 4 — tuning and release (½–1 day)

1. Play on the phone, not the simulator. Ten runs, write down at what
   second the run ended and whether the end felt like "too many" or
   "too big". Target: median run between 120 and 240 s, Kolos seen in
   most runs, overdrive reached in some.
2. Adjust `fullAt`, Kolos interval and size first; blast scaling last
   (bigger blasts are the reward, keep them).
3. `DemoDriver` + `tool/gen_screenshots.sh`: one new store screenshot at
   `PUFF_HEAT=1.3` with a Kolos mid-fracture; the ROADMAP clip pipeline
   gets its money shot from the same define.
4. `store/APP_STORE.md`, `store/GOOGLE_PLAY.md`: one What's New line
   ("Runs escalate: bigger shapes, bigger blasts, Kolos.") and a bullet in
   the description. `ROADMAP.md` §3.1 mentions Kolos as a Sestup boss; note
   that endless now has it too.
5. Version: ship as **1.2.0**, after 1.1.0 (music) is out. 1.1.0 is
   uncommitted and still needs listening and a device test; stacking a
   balance change on top of it would mean releasing two unverified things
   at once, and the review reply in `PUFF_JUKEBOX_PLAN.md` §5 should not
   wait for this.

---

## 6. Decisions for the user

- **Scores inflate.** Points are `impulse × 12 × multiplier`; a heat-1.0
  blast delivers ~27 % more impulse per body and hits more bodies, and
  Kolos fragments add fracture bonuses. Existing Game Center / Play
  leaderboard scores become easier to beat. Options: (a) accept it, the
  boards are young and a bigger late game is exactly what they should
  reward; (b) new leaderboard IDs (`puff.endless.v2`) in both consoles,
  which is a config job that stalled 1.0.4 for 12 days. Recommendation:
  (a).
- **How fast.** The §1.1 table is a first guess. `fullAt` 150 s matches the
  existing spawn ramp; 120 s makes a casual 2-minute run see tier III. The
  user decides after Phase 4's ten runs.
- **Kolos in Vacuum.** Blast multiplier 1.4 there, 0.6 in Water. One size
  table for all environments means a Kolos is a pushover in Vacuum and a
  wall in Water. First pass: accept; Water's muffled blasts are its
  identity. If Water Kolos never cracks, scale its size by
  `1 / blastMultiplier^0.5` per environment.
- **Daily challenge / seeded runs** (ROADMAP §3.5): heat from elapsed keeps
  them deterministic. The combo surge (§1.2) adds player-driven variance
  to blast size, which is fine for a daily (the seed fixes spawns, not the
  player).

## 7. Out of scope

- Difficulty settings, assist modes, per-environment heat curves.
- Enemy types, shapes that shoot or home. Kolos is a big polygon, nothing
  more.
- Core HP changes or healing. Heat changes what comes at the core, not the
  core.
- Score rebalancing. See §6.
- Anything in `sim/` that needs Flame: heat stays pure so `test/` covers
  it.
