# PUFF — Jukebox (soundtrack) plan

Spec for Claude Code (Opus). Work phase by phase, each phase ends with a
runnable build and a DEVLOG entry, exactly as `PUFF_PLAN.md` asks. Read
`lib/game/fx/audio.dart`, `lib/app/settings.dart`, `lib/app/overlays.dart`
and `lib/game/puff_game.dart` before touching anything; the jukebox slots
into the same listener pattern `AudioSystem` already uses.

Trigger: the first Google Play review (5★, 2026-10-12) asks for one thing —
themed background music, "inspiration could be Shatter". ROADMAP §3.3 lists
music as the missing brand element. This plan delivers it as **1.1.0**.

---

## 0. What "Shatter style" means here

Shatter (Sidhe, 2009; score by Module) is the reference: a retro-futuristic
synth soundtrack — analog arpeggios, warm pads, a driving electro beat under a
melodic lead, 80s instrumentation with modern production, one distinct theme
per world. It sits *on top of* the game instead of under it: you remember the
tune after a session.

Puff's version of that:

- **One theme per environment**, not one global loop. Vacuum, Air, Water and
  Plasma each get two tracks so a second run in the same world does not
  repeat the first one; the menu gets its own theme. The track *is* part of
  what makes an environment feel different, the same way its physics is.
- **Seamless loops** of 90–120 s. Shorter loops wear out in a game people
  play in ten-minute stretches.
- **Jukebox behaviour**: tracks rotate, the player can skip, the title of the
  track shows for a moment when it starts (HUD toast, `♪ ORBIT DECAY`). That
  is the whole "jukebox" — no playlist UI, no library screen.
- **Music ducks for the game, never the other way round.** Release blasts and
  fractures stay on top; music drops 6 dB during the pause overlay and the
  game-over screen.
- Synthesized SFX stay exactly as they are. Music is a new layer, switchable
  on its own.

Not in scope: adaptive/stem-based music that reacts to charge or combo. It
is tempting (Shatter does a little of it) and it is a second project. Leave a
hook (`JukeboxSystem.intensity`) unused rather than build it now.

---

## 1. Assets

### 1.1 Set

| id | Use | Loop | Target length |
|---|---|---|---|
| `menu` | main menu, settings | yes | 90 s |
| `vacuum_1`, `vacuum_2` | Vacuum runs | yes | 100–120 s |
| `air_1`, `air_2` | Air runs | yes | 100–120 s |
| `water_1`, `water_2` | Water runs | yes | 100–120 s |
| `plasma_1`, `plasma_2` | Plasma runs | yes | 100–120 s |
| `game_over` | sting when a run ends | no | 6 s |

Eleven files. At OGG Vorbis q6 (~190 kbps) that is roughly 20 MB on top of
today's app; acceptable, but do not go above q6 and do not ship WAV.

### 1.2 Format and the engine question — decide in Phase 1, not later

Music needs two things SFX never needed: a **gapless loop** and a
**crossfade** between two tracks (menu → environment, environment → menu,
skip). `flame_audio`'s `Bgm` can loop but owns a single player, and MP3/AAC
carry encoder priming at the file head, so the loop point clicks.

Recommended: **`flutter_soloud`** for music only. It decodes OGG Vorbis on
iOS and Android, loops sample-exact, and fades per handle, so a crossfade is
two handles and two `fadeVolume` calls. `flame_audio` keeps the SFX; the two
engines coexist, but **verify that on a device in Phase 1** — both touch the
platform audio session, and the failure mode (SFX going silent after music
starts, or the reverse) only shows up on hardware.

Fallback if the spike fails: `FlameAudio.bgm` with **AAC `.m4a`** files (iOS
does not decode OGG in `audioplayers`), accept a hard cut instead of a
crossfade, and ask the generator for tracks whose loop point lands on a
downbeat so the seam reads as a hit, not a glitch.

Whichever engine wins, the **file format is produced by the generator**, so
the decision has to land before generation starts — the generator writes
OGG by default (§1.4) and would need `format: m4a` for the fallback.

### 1.3 Prompts

The generator is ACE-Step 1.5 on SPARK (AiStack `audio-music`, same stack
Kirian's soundtrack came from). It takes a tag-style prompt plus BPM and key,
returns a seed, and reproduces the file from prompt+seed, so iterate on the
prompt, keep the seed that wins.

Shared tags for the whole set — this is the brand, keep it identical across
tracks: `retro-futuristic synthwave, analog synthesizer arpeggios, warm
polysynth pads, electro drum machine, melodic synth lead, 1980s instruments
with modern clean production, neon, video game soundtrack, [instrumental],
seamless loop, no fade in, no fade out`.

Per-track layer, matching the environment description in the store listing:

| id | BPM | Key | Added tags |
|---|---|---|---|
| `menu` | 96 | A minor | `calm, hopeful, spacious, slow arpeggio, soft pulse, inviting, title screen` |
| `vacuum_1` | 104 | E minor | `weightless, wide stereo, slow sidechain pump, sparse drums, deep space, floating` |
| `vacuum_2` | 108 | C# minor | `drifting, glassy arpeggios, long reverb, distant kick, nebula, zero gravity` |
| `air_1` | 118 | D major | `bright, breezy, airy pads, light groove, uplifting, wind, open sky` |
| `air_2` | 122 | G major | `playful, bouncing bass, staccato arpeggio, clear lead, daytime, light` |
| `water_1` | 92 | F minor | `submerged, low-pass filtered, slow pulse, muffled kick, deep, calm, pressure` |
| `water_2` | 96 | Bb minor | `underwater, filtered chords, dub echo, bubbles, slow groove, heavy, tidal` |
| `plasma_1` | 128 | B minor | `energetic, driving four-on-the-floor, acid bass, electric, crackling, tense` |
| `plasma_2` | 132 | F# minor | `intense, fast arpeggio, distorted lead, lightning, high voltage, relentless` |
| `game_over` | 96 | A minor | `short sting, descending, resolve, soft landing, 6 seconds, no loop` |

Display names (shown in the HUD toast, also what the review reply can quote):
`menu` Pressure Rising · `vacuum_1` Orbit Decay · `vacuum_2` Nebula Band ·
`air_1` Updraft · `air_2` Tailwind · `water_1` Caustics · `water_2` Thermocline ·
`plasma_1` Arc Jump · `plasma_2` High Voltage.

Expect ACE-Step to return 9–19 % shorter audio than asked (measured on
Kirian); ask for 120 s to get ~100 s. The service already does loopify
(2 s head/tail crossfade), −16 LUFS normalisation and −1 dBTP limiting, so
**do not post-process on the Mac** beyond listening.

### 1.4 Generator: `tool/gen_music.py`

A manifest-driven script, the Puff-sized version of Kirian's `audiogen`.
Python with only the standard library (`urllib`, `json`, `hashlib`), run
with `python3 -I`.

- Reads `assets/audio/music/manifest.yaml` (write it by hand from §1.1 and
  §1.3; a `prompt_override` field wins over the generated prompt, as in
  Kirian's manifest, so hand-tuned prompts survive a template change).
- For every track without `sha256` (or with `--regen <id>` / `--all`):
  `POST {AISTACK_URL}/v1/audio/music` with `{prompt, duration_s, loop,
  bpm, key, instrumental: true, format: "ogg", seed?}`; poll
  `GET /v1/audio/jobs/{id}` until done; download the output; write
  `seed`, `sha256`, `measured_s`, `lufs`, `model` back into the manifest
  **after each track**, so an interrupted run resumes.
- `--dry-run` prints the prompts and calls nothing. `--qa` re-checks files on
  disk against the manifest sha256 and measured length without generating.
- `AISTACK_URL` defaults to `http://spark:8093`; `AUDIO_API_KEY` is sent
  as a bearer token when set. The service is **not always up**, and the
  thermal guard between tracks is part of the script — see §4.

Output goes to `assets/audio/music/<id>.ogg`; add `assets/audio/music/` to
`pubspec.yaml` assets. Commit the manifest with seeds; commit the OGG files
too (they are the build input, CI has no SPARK).

---

## 2. Code

### 2.1 `lib/game/fx/jukebox.dart` — `JukeboxSystem`

A Flame `Component` beside `AudioSystem`, registered in `PuffGame.onLoad`
in the same `addAll`, wired to the same listener lists. Pure Dart logic in a
small `sim`-free helper so it can be unit-tested without an engine:

```dart
class Jukebox {               // no Flame, no audio — just the rules
  Jukebox(this.random, {Map<EnvironmentKind, int>? lastPlayed});
  TrackId pickFor(EnvironmentKind env);   // alternates _1/_2, never repeats last
  TrackId next(EnvironmentKind env);      // skip: the other one
}
```

`JukeboxSystem` owns the engine handles and the rules:

| Event | Action |
|---|---|
| `onLoad` | load all tracks (soloud `loadAsset`), start `menu` if phase is menu |
| phase → `playing` | crossfade menu → `pickFor(env)` over 1.5 s; HUD toast with the title |
| phase → `paused` | duck to −6 dB (volume × 0.5) over 0.3 s |
| `paused` → `playing` | restore over 0.3 s |
| phase → `gameOver` | duck, play `game_over` sting once (not looped) |
| `gameOver` → `menu`, `playing` → `menu` | crossfade to `menu` over 1.5 s |
| `skip()` | crossfade to `next(env)` over 0.8 s, toast |
| `enabled = false` | fade out 0.5 s, stop; `true` restarts what the phase wants |
| app background / foreground | pause / resume all handles (`AppLifecycleListener` in `main.dart`, forwarded to the system) |
| another app is playing audio at launch | optional: start muted; skip unless cheap on both platforms |

Retry in the environment picker does **not** restart the track; a new run in
the same environment continues the current one. Only a change of environment
or a skip changes the track. (Shatter restarts per level; Puff's runs are
30 s long, a restart every run would be a loop of intros.)

Volume: music base level `0.55` relative to SFX `1.0`, in `tuning.dart` with
the duck factor and the fade times. No slider in 1.1.0; a MUSIC toggle only.

### 2.2 Settings and UI

- `PuffSettings.music` (`bool`, default `true`, key `music`), persisted like
  `sound`. `SOUND` keeps meaning SFX; do not fold the two.
- `SettingsOverlay`: a `MUSIC` toggle directly under `SOUND`.
- `PauseOverlay`: a `♪ NEXT TRACK` `NeonButton` under the existing ones; it
  calls `game.jukebox.skip()` and plays the click. Shown only when music is
  enabled.
- HUD toast: `Hud` gets a second text line that shows `♪ TITLE` for 3 s at
  track start, fading out, same font and glow as the multiplier line. In the
  menu overlay the same title sits in small type at the bottom (`♪ pressure
  rising`), so the menu already says "this game has music".
- `DemoDriver` / screenshot runs: music off (`PUFF_DEMO` sets `music=false`),
  the toast would land in store screenshots.

### 2.3 Lifecycle and platform

- iOS: audio session category `ambient` with mix-with-others **off** while
  the game runs; respect the silent switch for SFX *and* music (a casual game
  that overrides the mute switch gets one-star reviews).
- Android: `audio focus` — request `GAIN` on start, pause on loss, resume on
  transient loss end. `flutter_soloud` does not do this for you; check what
  `audioplayers` already does for SFX and do not fight it.
- Interruptions (call, Siri): the pause/resume handlers above cover it.

### 2.4 Tests

- `test/jukebox_test.dart`: `pickFor` alternates and never repeats the last
  track of the same environment; `next` returns the other track; the
  sequence is deterministic for a seeded `Random`.
- Manifest check in `test/`: every id in §1.1 has a file under
  `assets/audio/music/`, every file is referenced, sha256 matches.
- Existing 33 tests keep passing; `dart format` and `flutter analyze` clean.

---

## 3. Phases

**Phase 1 — Engine spike (half a day).** Add `flutter_soloud`, play one
placeholder OGG looped with a crossfade to a second one, SFX still audible,
on a real iPhone and a real Android phone (plus both simulators). Background
and foreground the app. Decide engine and format (§1.2). DEVLOG entry with
the verdict. **Blocks generation** — tell the user the format the same day.

**Phase 2 — Jukebox logic and UI (one day).** `Jukebox`, `JukeboxSystem`,
settings toggle, pause button, HUD toast, tests, with placeholder tracks
(any CC0 loop renamed to the ids; never commit placeholders).

**Phase 3 — Generation (SPARK, §4).** Write `tool/gen_music.py` and the
manifest **first** — the SPARK window is booked for **Tuesday 2026-10-13,
13:30**, and the script, `--dry-run`-checked, has to exist before it
opens. The Director starts `audio-music` at 13:30 (only if the schedule
is in `llm` mode, ComfyUI is down, ≥ 20 GiB free, < 87 °C) and sends
**"audio-music běží"** to this session — **do not generate before that
message arrives**. The container last died with exit 137, so treat the
first track as a probe; on any error from `:8093` do not restart anything
on SPARK, message the Director. Send "hotovo" when the run is over (it
stops the container and resumes its jobs). Generate the eleven tracks, listen to all of them end to end at least once,
regenerate the ones that do not fit with a new seed or an adjusted
`prompt_override`. Commit manifest and files.

**Phase 4 — Ship 1.1.0.** Update: the full description in
`store/APP_STORE.md` and `store/GOOGLE_PLAY.md` ("Haptics … plus synthesized
sound" → add an "Original synthwave soundtrack — a theme for every
environment, switchable" bullet; the NO STRINGS paragraph is unchanged,
music is local); release notes; ROADMAP §3.3 music item ticked; DEVLOG.
Privacy pages need no change. Reply to the review once the build is live
(draft in §5).

---

## 4. Generation on SPARK — constraints that are not optional

- The music service is `audio-music` (ACE-Step 1.5, port 8094, behind the
  `ai-audio` gateway on 8093). It holds 4.4 GB on the GPU and **cannot unload
  weights while the container runs**; the user's standing instruction is to
  keep `audio-music`/`audio-sfx` **off** in the daily profile.
- SPARK's current schedule is `7:comfy 13:llm`. The Director (2026-10-13)
  ruled out the ComfyUI morning (Lab batches, promo-tribute at 11:30) and
  offered the **afternoon qwen36 window, any day 13:30–24:00, ~45 min**:
  qwen36 stays up but the Director pauses its StoryTeller hint jobs for the
  duration; ~40 GiB free is enough for the 4.4 GB model. Never alongside a
  ComfyUI render (`comfyui-llm-no-overlap`).
- The Director starts and stops the container (`docker start audio-music` /
  `docker stop`, **never `docker compose down`**, never via `/ctrl/activate`)
  once the user confirms a time; send it the time, and "hotovo" when the
  run is over. Eleven tracks is ~15 min of GPU; regenerations can follow in
  the same window or the next day's.
- Gateway: `GET /v1/audio/models` on `:8093` answers without a key; the
  env var, if the POST wants one, is **`AUDIO_API_KEY`** (not
  `AISTACK_API_KEY`) — the generator reads that name and retries with it
  after a 401. Model name in the catalog: `acestep-v15-turbo` (MIT);
  `ace-step-v1-3.5b` is there too. Deploy is `~/deploy/AiStack` on `main`.
- **Thermal guard is mandatory in the generator:** between tracks read the
  last line of `~/ops/thermal.csv` on SPARK (9th column `zone_max_c`, via
  `ssh spark tail -1`): wait while ≥ 93 °C, continue below 87 °C, and stop
  if the line is older than 60 s (logger dead). Append start/end rows to
  `~/ops/thermal-events.csv` (or tell the Director, who does it at container
  start).
- Loopify on the service has not been exercised since September — listen to
  the loop point of the first track before generating the rest.
- Run the generator from the Mac (`tool/gen_music.py` against `spark:8093`);
  nothing of Puff needs to live on SPARK.

---

## 5. Review reply (Google Play, Czech, ≤ 350 chars)

Post it when 1.1.0 is live, not before:

> Díky moc! Hudba byla přesně to, co Puffu chybělo — od verze 1.1 má každé
> prostředí vlastní syntezátorové téma (a Shatter byl skutečně inspirací).
> Vypíná se zvlášť od zvuků, v pauze jde přeskočit na další skladbu. Snad
> sedne. — A+B
