import 'package:puff/game/sim/achievements.dart';
import 'package:puff/game/sim/environment.dart';
import 'package:puff/game/sim/modifier.dart';
import 'package:test/test.dart';

RunRecord run({
  EnvironmentKind env = EnvironmentKind.vacuum,
  ModifierKind mod = ModifierKind.pressure,
  String palette = 'Cyberpunk',
  int bestCombo = 0,
  int maxTier = 0,
  double seconds = 30,
  int fractures = 0,
  int perfect = 0,
  double? coreHit = 10,
  bool weekly = false,
}) => RunRecord(
  environment: env,
  modifier: mod,
  palette: palette,
  score: 100,
  bestCombo: bestCombo,
  maxTier: maxTier,
  seconds: seconds,
  fractures: fractures,
  perfectReleases: perfect,
  firstCoreHitAt: coreHit,
  weekly: weekly,
);

void main() {
  const rules = AchievementRules(comboStep: 0.15, paletteCount: 6);

  test('x4 multiplier needs a combo of 20 at step 0.15', () {
    expect(rules.comboForX4, 20);
  });

  test('a plain first run only unlocks the first run', () {
    final p = AchievementProgress();
    expect(rules.record(run(), p), [AchievementId.firstRun]);
    expect(rules.record(run(), p), isEmpty);
  });

  test('run feats', () {
    final p = AchievementProgress();
    final got = rules.record(
      run(bestCombo: 40, maxTier: 4, seconds: 260, fractures: 60, perfect: 1, coreHit: 75, weekly: true),
      p,
    );
    expect(got, containsAll([
      AchievementId.comboX4,
      AchievementId.combo40,
      AchievementId.perfectRelease,
      AchievementId.heat3,
      AchievementId.overdrive,
      AchievementId.untouchable,
      AchievementId.shatter50,
      AchievementId.weekly,
    ]));
  });

  test('untouchable needs 60 s with no core hit before them', () {
    expect(rules.record(run(seconds: 59, coreHit: null), AchievementProgress()),
        isNot(contains(AchievementId.untouchable)));
    expect(rules.record(run(seconds: 90, coreHit: 59.9), AchievementProgress()),
        isNot(contains(AchievementId.untouchable)));
    expect(rules.record(run(seconds: 90, coreHit: null), AchievementProgress()),
        contains(AchievementId.untouchable));
  });

  test('collections build up over runs', () {
    final p = AchievementProgress();
    final all = <AchievementId>[];
    for (final e in EnvironmentKind.values) {
      all.addAll(rules.record(run(env: e), p));
    }
    expect(all, contains(AchievementId.allEnvironments));
    for (final m in ModifierKind.values) {
      all.addAll(rules.record(run(mod: m), p));
    }
    expect(all, contains(AchievementId.allModifiers));
    for (final name in ['A', 'B', 'C', 'D', 'E']) {
      all.addAll(rules.record(run(palette: name), p));
    }
    expect(all, contains(AchievementId.allPalettes));
    expect(all, contains(AchievementId.runs10));
    expect(all, isNot(contains(AchievementId.runs50)));
  });

  test('perfect release: nearly full, not overpressured', () {
    expect(AchievementRules.isPerfect(0.96, overpressured: false), isTrue);
    expect(AchievementRules.isPerfect(0.96, overpressured: true), isFalse);
    expect(AchievementRules.isPerfect(0.9, overpressured: false), isFalse);
  });

  test('IDs are unique and fit App Store Connect', () {
    final ids = AchievementId.values.map((a) => a.id).toList();
    expect(ids.toSet().length, ids.length);
    expect(ids.length, inInclusiveRange(10, 15));
    for (final id in ids) {
      expect(id, matches(RegExp(r'^[a-z0-9._]{1,100}$')));
    }
  });
}
