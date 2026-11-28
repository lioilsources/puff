// The checks every app copies from ol1n_telemetry (README "Testovací sada")
// plus the game's own hooks: screens and runs.

import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:ol1n_telemetry/ol1n_telemetry.dart';
import 'package:ol1n_telemetry/testing.dart';
import 'package:puff/app/telemetry.dart';
import 'package:puff/game/palette.dart';
import 'package:puff/game/physics/modifiers.dart';
import 'package:puff/game/puff_game.dart';
import 'package:puff/game/sim/environment.dart';
import 'package:puff/game/sim/score.dart';
import 'package:puff/game/sim/weekly.dart';

/// Just the state [PuffTelemetry] reads.
class _FakeGame implements PuffGame {
  @override
  WeeklyChallenge? weekly;
  @override
  Environment environment = Environment.byKind(EnvironmentKind.water);
  @override
  late final ModifierSystem modifiers = ModifierSystem(math.Random());
  @override
  Palette palette = Palette.vaporwave;
  @override
  int maxTier = 0;
  @override
  final ScoreModel score = ScoreModel(
    pointsPerImpulse: 1,
    comboWindow: 1,
    comboStep: 1,
    maxMultiplier: 1,
    fractureBonus: 1,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('docs/telemetry.md lists exactly the dictionary', () {
    expect(
      telemetryDocProblems(puffDictionary, File('docs/telemetry.md').readAsStringSync()),
      isEmpty,
    );
  });

  test('no property is free text', () {
    expect(telemetryDictionaryProblems(puffDictionary), isEmpty);
  });

  test('app version matches pubspec.yaml', () {
    expect(
      telemetryVersionProblems(kAppVersion, File('pubspec.yaml').readAsStringSync()),
      isEmpty,
    );
  });

  test('the code sends only dictionary events, and every one of them', () {
    expect(telemetryTrackCallProblems(puffDictionary), isEmpty);
  });

  test('no key, no network', () async {
    expect(await telemetryNoKeyProblems(puffDictionary), isEmpty);
  }, skip: const bool.fromEnvironment('TELEMETRY_DEBUG'));

  test('off means nothing', () async {
    expect(await telemetryOffProblems(puffDictionary), isEmpty);
  });

  test('every palette the game ships has an id', () {
    for (final p in [...Palette.builtIns, Palette.holiday]) {
      expect(paletteId(p), isNot('other'), reason: p.name);
    }
  });

  group('game hooks', () {
    late PuffTelemetry hooks;
    late _FakeGame game;

    setUp(() async {
      Telemetry.resetForTest();
      await Telemetry.init(
        app: kTelemetryApp,
        appVersion: kAppVersion,
        dictionary: puffDictionary,
        store: MemoryTelemetryStore(),
        lang: () => 'en',
        pauseProps: () => {'runs': 0},
        sink: FakeSink(),
        startTimer: false,
        observeLifecycle: false,
      );
      hooks = PuffTelemetry();
      game = _FakeGame();
    });

    tearDown(Telemetry.resetForTest);

    List<String> names() => [for (final e in Telemetry.debugQueue) e.name];
    TelemetryEvent last(String name) =>
        Telemetry.debugQueue.lastWhere((e) => e.name == name);

    test('screens follow the game state', () {
      hooks.screenChanged(GameScreen.menu);
      hooks.screenChanged(GameScreen.settings);
      expect(Telemetry.debugScreen, 'settings');
      expect(last('screen_leave').props['screen'], 'menu');
    });

    test('a run played to the end activates once', () {
      hooks.screenChanged(GameScreen.menu);
      hooks.runStarted(game, GamePhase.menu);
      game
        ..maxTier = 3
        ..score.score = 1200;
      hooks.runEnded(game, RunEnd.death);
      hooks.runStarted(game, GamePhase.gameOver);
      hooks.runEnded(game, RunEnd.death);

      expect(names().where((n) => n == 'activation'), hasLength(1));
      final start = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_start');
      expect(start.props, containsPair('env', 'water'));
      expect(start.props, containsPair('palette', 'vaporwave'));
      expect(start.props, containsPair('mode', 'free'));
      expect(last('run_start').props['from'], 'result');
      final end = Telemetry.debugQueue.firstWhere((e) => e.name == 'run_end');
      expect(end.props, containsPair('result', 'death'));
      expect(end.props, containsPair('cause', 'core'));
      expect(end.props, containsPair('level', 3));
      expect(end.props, containsPair('score', 1200));
      expect(hooks.runs, 2);
    });

    test('leaving a run is not an activation', () {
      hooks.runStarted(game, GamePhase.menu);
      hooks.runEnded(game, RunEnd.menu);
      game.weekly = WeeklyChallenge.at(DateTime.utc(2026, 11, 1), preview: true);
      hooks.runStarted(game, GamePhase.menu);
      hooks.runEnded(game, RunEnd.restart);

      expect(names(), isNot(contains('activation')));
      expect(last('run_end').props, containsPair('result', 'restart'));
      expect(last('run_end').props, containsPair('cause', 'none'));
      expect(last('run_start').props, containsPair('mode', 'weekly'));
      expect(names(), contains('feature_use'));
    });

    test('an end without a start sends nothing', () {
      hooks.runEnded(game, RunEnd.menu);
      expect(names(), isNot(contains('run_end')));
    });
  });
}
