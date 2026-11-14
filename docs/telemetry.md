# Anonymous gameplay statistics

Puff sends a small set of anonymous gameplay events through
[`ol1n_telemetry`](https://github.com/lioilsources/Ol1nTelemetry) so the
owner can see what new players do in their first session, how long runs
last, which settings and modes get used, and when players stop. This file is
the **event dictionary**: the constant `puffDictionary`
(`lib/app/telemetry.dart`) and this document list exactly the same events
and properties, and `test/telemetry_test.dart` fails when they drift apart.

Adding an event or a property is a change to the privacy policy
(`docs/privacy.html`) and to the store privacy answers. Ask the owner first,
and change the dictionary at most once per release.

## Rules

The rules of `ol1n_telemetry` apply unchanged (see its README):

- **No persistent identifier.** No install, device or advertising id. Each
  session gets a random 128-bit id that lives in memory; unsent events in the
  offline queue carry it and are deleted once sent.
- **Cohorts are computed on the device.** Only bands leave it.
- **Only enums, bands and numbers.** No free text, no player name, no device
  model. Environment, modifier and palette ids are catalogue constants; a
  palette added later by the remote config reports `other`.
- **No key, no network.** Without `TELEMETRY_KEY` and an `https`
  `TELEMETRY_HOST` nothing is recorded or sent, and the settings switch is
  hidden. Local builds, forks and tests are silent.
- **The game never waits**, **off wipes the queue at once**, and
  **measuring never steers the game**: nothing in the game reads anything
  back. The game only reports to `PuffObserver` (`lib/game/puff_game.dart`).
- The queue lives in the app's own `shared_preferences` under `telemetry_*`
  keys (`PrefsTelemetryStore`).

## Screens

A game has no routes; `Telemetry.screen()` follows the game state:
`menu` (main menu), `play` (a run on screen), `pause` (pause menu),
`result` (game over), `settings` (settings on top of the menu or the pause
menu).

## Runs

A run is the flow `run_start` / `run_end`, with the names shared by all ol1n
games (plan §6.3): `result`, `secs`, `level`, `cause`.

- `run_start` when a run begins: from the menu, AGAIN on the result screen,
  RESTART in the pause menu, a deep link or a Game Center activity.
- `run_end` when it ends: `death` (the core gave out; the run was played to
  the end), `restart` (restarted from the pause menu, or replaced by a run
  from a link), `menu` (left to the main menu), `background` (the app went to
  the background mid-run and the process never came back; parked by the
  package with the values at the time of the pause).
- `level` is the highest heat tier reached (0–4, OVERDRIVE is 4).

## Activation

The first run played to the end on this install (`run_end` with
`result: death`). Once per install.

## Features

Used by `feature_snapshot` (3rd, 6th and 11th session) to tell which parts of
the game experienced players actually touch:

| Feature | When |
|---|---|
| `environment` | an environment picked in the menu |
| `modifier` | a modifier picked in the menu |
| `palette` | a palette picked in the menu |
| `weekly` | a weekly challenge run started |
| `leaderboard` | the leaderboard opened (menu or result screen) |
| `achievements` | the achievements opened |
| `challenges` | Game Center challenges opened |
| `share` | a new best shared |
| `next_track` | NEXT TRACK in the pause menu |
| `quality` | the effects quality changed |
| `reduced_flashes` | REDUCED FLASHES switched on |

There are no error states the player sees and nothing locked in this
version, so `error_shown` and `locked_tap` are not in the dictionary.

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kAppVersion`, checked against `pubspec.yaml`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's resolved language: `ar`, `cs`, `de`, `en`, `es`, `fr`, `it`, `ja`, `ko`, `nl`, `pt`, `ru`, `tr`, `zh`, `zh_Hant` |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` (played before measuring began) |
| `first_session` | bool | the very first session of a new install |
| `tester` | bool | tester build (`--dart-define=TESTER=true`) |

## Events

Each event answers a question from the plan (`DevConventions`
`Prompts/04-PLAN-analytika.md` §1).

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.
*New player: what happens after the first launch; do they come back.*

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |
| `session_band_first` | bool | the first session of this install in its `session_band` |
| `days_band_first` | bool | the first session of this install in its `days_band` |
| `campaign` | campaign | optional; QR campaign of a new install, `^[a-z0-9-]{1,24}$` (not sent by Puff yet) |

### `screen_view`

A game screen appeared. *First-session funnel; where players go.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | `menu`, `play`, `pause`, `result`, `settings`, `other` |
| `prev` | enum | the previous screen, or `none` |

### `screen_leave`

A game screen was left. *How long players stay on each screen.*

| Property | Type | Values |
|---|---|---|
| `screen` | enum | as in `screen_view` |
| `secs` | int | foreground seconds on the screen |
| `actions` | int | app events and feature uses during the stay |

### `session_pause`

The app went to the background or is closing. Sent at once.
*When and where players stop; how much time a session takes.*

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session |
| `screen` | enum | the screen at the time, or `none` |
| `screen_secs` | int | foreground seconds on that screen |
| `runs` | int | runs started this session |

### `activation`

The first run played to the end on this install. Once per install.
*New player: how fast they reach the first real game.*

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds since this session's `app_open` |

### `feature_use`

The first use of a feature in a session (see Features).
*Experienced player: what they use.*

| Property | Type | Values |
|---|---|---|
| `feature` | enum | `environment`, `modifier`, `palette`, `weekly`, `leaderboard`, `achievements`, `challenges`, `share`, `next_track`, `quality`, `reduced_flashes` |

### `feature_snapshot`

After `app_open` of the 3rd, 6th and 11th session: which features this
install has ever used. *Experienced player: what they never use.*

| Property | Type | Values |
|---|---|---|
| `f_environment` | bool | environment picked |
| `f_modifier` | bool | modifier picked |
| `f_palette` | bool | palette picked |
| `f_weekly` | bool | weekly challenge played |
| `f_leaderboard` | bool | leaderboard opened |
| `f_achievements` | bool | achievements opened |
| `f_challenges` | bool | challenges opened |
| `f_share` | bool | best shared |
| `f_next_track` | bool | track skipped |
| `f_quality` | bool | quality changed |
| `f_reduced_flashes` | bool | reduced flashes switched on |
| `features_used` | int | how many of them |

### `menu_ready`

The main menu is usable (game, shaders and audio loaded). Once per launch.
*Load time: does a slow start lose new players.*

| Property | Type | Values |
|---|---|---|
| `ms` | int | milliseconds since the process started, up to 600000 |

### `run_start`

A run begins. *Funnel from menu to play; which modes and setups are played.*

| Property | Type | Values |
|---|---|---|
| `mode` | enum | `free`, `weekly` |
| `from` | enum | `menu` (main menu, link or activity), `result` (AGAIN), `pause` (RESTART, or a link mid-run) |
| `env` | enum | `vacuum`, `air`, `water`, `plasma` |
| `modifier` | enum | `pressure`, `implosion`, `magnet`, `gravityWell`, `chainSpark` |
| `palette` | enum | `cyberpunk`, `vaporwave`, `acid`, `mono`, `ember`, `arctic`, `holiday`, `other` |

### `run_end`

The run ends. *Where players struggle: how long runs last, how far they get,
how often they give up.*

| Property | Type | Values |
|---|---|---|
| `result` | enum | `death`, `restart`, `menu`, `background`; `ok`, `cancel`, `error` exist in every flow and are unused |
| `secs` | int | foreground seconds of the run |
| `mode` | enum | `free`, `weekly` |
| `level` | int | highest heat tier reached, `0`–`4` |
| `cause` | enum | what ended a `death`: `core` (the core lost its last hit point), `escape` (too many shapes escaped, unused lose rule); `none` otherwise |
| `score` | int | final score |
| `combo` | int | best combo of the run |

## Reading the data

`store-metrics report puff` on JODA (tester builds excluded). Useful cuts:

1. First-session funnel: `app_open` → `menu_ready` → `run_start` →
   `activation` → second session (`session_band_first` with band `2`).
2. Where sessions end: the last `session_pause` per session by `screen`
   and `active_secs`.
3. Runs: `run_end` by `result`, median `secs` and `level`, by `env` ×
   `modifier` of the matching `run_start`, split by `session_band`.
4. Feature adoption: `feature_snapshot` at the 6th and 11th session.
5. Load time: `menu_ready.ms` p50/p90 by `platform`.

## Build and checking by hand

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | the app key at the receiver; empty → nothing is sent |
| `TELEMETRY_HOST` | the receiver, `https`; empty → nothing is sent |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them |
| `TESTER` | `true` marks the build as a tester build |

The release workflows (`release-ios`, `release-android`) pass the key and
host from the GitHub secrets of the same names; an absent secret makes a
silent build. The key and the receiver address never go into this public
repository.

```bash
flutter run --profile --dart-define=TELEMETRY_DEBUG=true
```

prints one event per line; play one full run and compare with this file.
