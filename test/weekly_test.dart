import 'package:puff/game/sim/environment.dart';
import 'package:puff/game/sim/modifier.dart';
import 'package:puff/game/sim/seeded_random.dart';
import 'package:puff/game/sim/weekly.dart';
import 'package:test/test.dart';

void main() {
  final launch = WeeklyChallenge.launch;

  test('launch is a Monday at midnight UTC', () {
    expect(launch.weekday, DateTime.monday);
    expect(launch.isUtc, isTrue);
    expect([launch.hour, launch.minute, launch.second], [0, 0, 0]);
  });

  test('hidden before launch unless previewed', () {
    final before = launch.subtract(const Duration(seconds: 1));
    expect(WeeklyChallenge.at(before), isNull);
    expect(WeeklyChallenge.at(before, preview: true)!.week, 0);
  });

  test('weeks turn over on Monday 00:00 UTC', () {
    expect(WeeklyChallenge.at(launch)!.week, 0);
    expect(WeeklyChallenge.at(launch.add(const Duration(days: 6, hours: 23)))!.week, 0);
    expect(WeeklyChallenge.at(launch.add(const Duration(days: 7)))!.week, 1);
    expect(WeeklyChallenge.at(launch.add(const Duration(days: 70)))!.id, 'w10');
  });

  test('the same instant gives the same week in any time zone', () {
    final utc = launch.add(const Duration(days: 9, hours: 3));
    expect(WeeklyChallenge.at(utc.toLocal())!.week, WeeklyChallenge.at(utc)!.week);
  });

  test('seed is stable and differs between weeks', () {
    final seeds = [
      for (var w = 0; w < 52; w++) WeeklyChallenge.at(launch.add(Duration(days: 7 * w)))!.seed,
    ];
    expect(seeds.toSet().length, 52);
    expect(WeeklyChallenge.at(launch)!.seed, seeds.first);
    expect(seeds.every((s) => s >= 0 && s <= 0x7FFFFFFF), isTrue);
  });

  test('every environment and modifier comes up, pairs repeat after 20 weeks', () {
    final pairs = <(EnvironmentKind, ModifierKind)>{};
    for (var w = 0; w < 20; w++) {
      final c = WeeklyChallenge.at(launch.add(Duration(days: 7 * w)))!;
      pairs.add((c.environment, c.modifier));
    }
    expect(pairs.length, 20);
    expect(pairs.map((p) => p.$1).toSet().length, EnvironmentKind.values.length);
    expect(pairs.map((p) => p.$2).toSet().length, ModifierKind.values.length);
  });

  test('time left counts down to the end of the week', () {
    final c = WeeklyChallenge.at(launch.add(const Duration(days: 2)))!;
    expect(c.timeLeft(launch.add(const Duration(days: 2))).inDays, 5);
    expect(c.timeLeft(launch.add(const Duration(days: 8))), Duration.zero);
  });

  test('reseeding restarts the spawn sequence', () {
    final r = SeededRandom();
    r.reseed(42);
    final a = [for (var i = 0; i < 5; i++) r.nextInt(1000)];
    r.reseed(42);
    final b = [for (var i = 0; i < 5; i++) r.nextInt(1000)];
    expect(a, b);
  });
}
