import 'package:flutter/widgets.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/palette.dart';
import '../game/puff_game.dart';
import '../game/sim/environment.dart';
import '../game/sim/modifier.dart';
import '../game/tuning.dart';
import '../l10n/app_localizations.dart';

/// The app version this build reports; `test/telemetry_test.dart` keeps it
/// equal to `version:` in `pubspec.yaml`.
const kAppVersion = '1.3.0';

/// Id of the app in StoreMetrics `apps.yaml`.
const kTelemetryApp = 'puff';

/// Tester build: `--dart-define=TESTER=true`.
const kTesterBuild = bool.fromEnvironment('TESTER');

/// Palettes as reported: the built-ins and the seasonal ones the app ships.
/// A palette added by the remote config reports `other`.
final kPaletteIds = {
  for (final p in [...Palette.builtIns, Palette.holiday]) p.name.toLowerCase(),
};

String paletteId(Palette p) {
  final id = p.name.toLowerCase();
  return kPaletteIds.contains(id) ? id : 'other';
}

/// The one event dictionary of Puff, mirrored in `docs/telemetry.md`.
final puffDictionary = TelemetryDictionary(
  appVersion: kAppVersion,
  languages: {
    for (final l in AppLocalizations.supportedLocales) telemetryLocaleId(l),
  },
  screens: {for (final s in GameScreen.values) s.name},
  features: {
    'environment',
    'modifier',
    'palette',
    'weekly',
    'leaderboard',
    'achievements',
    'challenges',
    'share',
    'next_track',
    'quality',
    'reduced_flashes',
  },
  sessionPause: {'runs': const IntProp(100000)},
  events: {
    'menu_ready': {'ms': const IntProp(600000)},
    ...TelemetryDictionary.flow(
      'run',
      results: {for (final r in RunEnd.values) r.name},
      start: {
        'mode': const EnumProp({'free', 'weekly'}),
        'from': const EnumProp({'menu', 'result', 'pause'}),
        'env': EnumProp({for (final e in EnvironmentKind.values) e.name}),
        'modifier': EnumProp({for (final m in ModifierKind.values) m.name}),
        'palette': EnumProp({...kPaletteIds, 'other'}),
      },
      end: {
        'mode': const EnumProp({'free', 'weekly'}),
        'level': const IntProp(10),
        'cause': const EnumProp({'core', 'escape', 'none'}),
        'score': const IntProp(),
        'combo': const IntProp(100000),
      },
    ),
  },
);

/// [TelemetryStore] over the SharedPreferences the app already keeps.
class PrefsTelemetryStore implements TelemetryStore {
  PrefsTelemetryStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> read(String key) async => _prefs.getString(key);

  @override
  Future<void> write(String key, String value) => _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

/// The app's locale as reported in `lang`; set by the widget layer.
String telemetryLang = 'en';

void setTelemetryLocale(Locale locale) {
  final id = telemetryLocaleId(locale);
  telemetryLang = puffDictionary.languages.contains(id)
      ? id
      : telemetryLocaleId(Locale(locale.languageCode));
}

/// Turns game screens and runs into events. Measuring never steers the game:
/// nothing here is read back by it.
class PuffTelemetry implements PuffObserver {
  TelemetryFlow? _run;
  int runs = 0;

  @override
  void screenChanged(GameScreen screen) => Telemetry.screen(screen.name);

  @override
  void runStarted(PuffGame game, GamePhase from) {
    runs++;
    final weekly = game.weekly != null;
    if (weekly) {
      Telemetry.feature('weekly');
    }
    _run = Telemetry.flow(
      'run',
      {
        'mode': weekly ? 'weekly' : 'free',
        'from': switch (from) {
          GamePhase.gameOver => 'result',
          GamePhase.playing || GamePhase.paused => 'pause',
          GamePhase.menu => 'menu',
        },
        'env': game.environment.kind.name,
        'modifier': game.modifiers.spec.kind.name,
        'palette': paletteId(game.palette),
      },
      // A run left in the background ends with these if the app never
      // comes back.
      () => _endProps(game, over: false),
    );
  }

  @override
  void runEnded(PuffGame game, RunEnd end) {
    final run = _run;
    _run = null;
    if (run == null || run.ended) {
      return;
    }
    run.end(end.name, _endProps(game, over: end == RunEnd.death));
    if (end == RunEnd.death) {
      // The first run played to the end is the first real use.
      Telemetry.activation();
    }
  }

  Map<String, Object> _endProps(PuffGame game, {required bool over}) => {
    'mode': game.weekly != null ? 'weekly' : 'free',
    'level': game.maxTier.clamp(0, 10),
    'cause': !over
        ? 'none'
        : switch (Tuning.loseRule) {
            LoseRule.core => 'core',
            LoseRule.bottomEscape => 'escape',
          },
    'score': game.score.score.clamp(0, 1000000000),
    'combo': game.score.bestCombo.clamp(0, 100000),
  };
}
