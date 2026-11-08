import 'environment.dart';
import 'modifier.dart';

/// The weekly challenge: one run setup for everybody from Monday 00:00 UTC to
/// the next Monday, with the same spawn seed, scored on its own recurring
/// leaderboard.
///
/// Everything follows from the date, so a new week needs no new build and no
/// server. The physics still depends on the player's taps and on the frame
/// rate: the seed fixes what is thrown at the core and when, not how it ends.
class WeeklyChallenge {
  const WeeklyChallenge._(this.week);

  /// First Monday of the challenge. Before it the mode stays hidden. The
  /// recurring leaderboard in App Store Connect starts at the same instant
  /// and repeats every 7 days.
  static final DateTime launch = DateTime.utc(2026, 11, 23);

  /// Recurring leaderboard, App Store Connect ID.
  static const leaderboardId = 'puff.weekly';

  /// Weeks since [launch]; 0 is the first one.
  final int week;

  /// Returns the challenge running at [now], or null before [launch].
  /// [preview] shows week 0 early, for TestFlight and screenshots.
  static WeeklyChallenge? at(DateTime now, {bool preview = false}) {
    final utc = now.toUtc();
    if (utc.isBefore(launch)) {
      return preview ? const WeeklyChallenge._(0) : null;
    }
    return WeeklyChallenge._(utc.difference(launch).inDays ~/ 7);
  }

  DateTime get start => launch.add(Duration(days: 7 * week));

  DateTime get end => start.add(const Duration(days: 7));

  /// Stable key for local bests, e.g. `w3`.
  String get id => 'w$week';

  /// Spawn seed: a 32-bit mix of the week number, so neighbouring weeks are
  /// unrelated sequences.
  int get seed {
    var x = (week + 1) * 0x9E3779B1 & 0xFFFFFFFF;
    x = ((x ^ (x >> 16)) * 0x85EBCA6B) & 0xFFFFFFFF;
    x = ((x ^ (x >> 13)) * 0xC2B2AE35) & 0xFFFFFFFF;
    return (x ^ (x >> 16)) & 0x7FFFFFFF;
  }

  /// Cycles through all four, one per week.
  EnvironmentKind get environment =>
      EnvironmentKind.values[week % EnvironmentKind.values.length];

  /// Steps by 2 through five modifiers, so the pairing with the environment
  /// only repeats after 20 weeks.
  ModifierKind get modifier =>
      ModifierKind.values[(week * 2 + 1) % ModifierKind.values.length];

  Duration timeLeft(DateTime now) {
    final left = end.difference(now.toUtc());
    return left.isNegative ? Duration.zero : left;
  }
}
