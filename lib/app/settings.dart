import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/fx/post_process.dart';
import '../game/palette.dart';
import '../game/sim/achievements.dart';
import '../game/sim/environment.dart';
import '../game/sim/modifier.dart';

/// Persisted player settings and local high scores (per environment).
class PuffSettings extends ChangeNotifier {
  PuffSettings._(this._prefs);

  final SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  PostProcessQuality quality = PostProcessQuality.med;
  bool haptics = true;
  bool sound = true;
  bool music = true;
  bool debugOverlay = false;

  /// Weaker flashes, shake and screen-wide pulses. Also on whenever the
  /// system asks to reduce motion; this switch is for players who want it
  /// without changing the whole phone.
  bool reducedFlashes = false;
  String paletteName = Palette.cyberpunk.name;
  EnvironmentKind environment = EnvironmentKind.vacuum;
  ModifierKind modifier = ModifierKind.pressure;
  final Map<EnvironmentKind, int> highScores = {};

  /// Launches so far, this one included.
  int session = 0;

  /// App version that last asked for a rating.
  String? lastReviewVersion;

  /// Best score per weekly challenge, keyed by [WeeklyChallenge.id].
  final Map<String, int> weeklyBests = {};

  late final AchievementProgress achievements;

  /// Tips bought on this device. Any tip makes the player a [supporter].
  int tips = 0;

  bool get supporter => tips > 0;

  /// Achievement IDs Game Center has accepted. Unlocks earned while signed
  /// out wait here until the next sign-in.
  final Set<String> reportedAchievements = {};

  Palette get palette => Palette.byName(paletteName);

  static Future<PuffSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final s = PuffSettings._(prefs);
    s.quality = PostProcessQuality.values.byNameOr(
      prefs.getString('quality'),
      PostProcessQuality.med,
    );
    s.haptics = prefs.getBool('haptics') ?? true;
    s.sound = prefs.getBool('sound') ?? true;
    s.music = prefs.getBool('music') ?? true;
    s.debugOverlay = prefs.getBool('debugOverlay') ?? false;
    s.reducedFlashes = prefs.getBool('reducedFlashes') ?? false;
    s.session = (prefs.getInt('session') ?? 0) + 1;
    await prefs.setInt('session', s.session);
    s.lastReviewVersion = prefs.getString('lastReviewVersion');
    s.tips = prefs.getInt('tips') ?? 0;
    final weekly = prefs.getString('weeklyBest');
    if (weekly != null) {
      // Only the current week matters; one entry is kept.
      final i = weekly.indexOf(':');
      if (i > 0) {
        s.weeklyBests[weekly.substring(0, i)] = int.tryParse(weekly.substring(i + 1)) ?? 0;
      }
    }
    s.achievements = AchievementProgress(
      runs: prefs.getInt('runs') ?? 0,
      environments: (prefs.getStringList('playedEnvironments') ?? const []).toSet(),
      modifiers: (prefs.getStringList('playedModifiers') ?? const []).toSet(),
      palettes: (prefs.getStringList('playedPalettes') ?? const []).toSet(),
      unlocked: (prefs.getStringList('achievements') ?? const []).toSet(),
    );
    s.reportedAchievements.addAll(prefs.getStringList('reportedAchievements') ?? const []);
    s.paletteName = prefs.getString('palette') ?? Palette.cyberpunk.name;
    s.environment = EnvironmentKind.values.byNameOr(
      prefs.getString('environment'),
      EnvironmentKind.vacuum,
    );
    s.modifier = ModifierKind.values.byNameOr(
      prefs.getString('modifier'),
      ModifierKind.pressure,
    );
    for (final env in EnvironmentKind.values) {
      s.highScores[env] = prefs.getInt('highScore_${env.name}') ?? 0;
    }
    // Scripted preview recordings pick the scene at build time:
    // `--dart-define=PUFF_ENV=water --dart-define=PUFF_PALETTE=Vaporwave
    // --dart-define=PUFF_MODIFIER=gravityWell`. Nothing is saved.
    const env = String.fromEnvironment('PUFF_ENV');
    const palette = String.fromEnvironment('PUFF_PALETTE');
    const modifier = String.fromEnvironment('PUFF_MODIFIER');
    if (env.isNotEmpty) {
      s.environment = EnvironmentKind.values.byNameOr(env, s.environment);
    }
    if (palette.isNotEmpty) {
      s.paletteName = palette;
    }
    if (modifier.isNotEmpty) {
      s.modifier = ModifierKind.values.byNameOr(modifier, s.modifier);
    }
    return s;
  }

  Future<void> save() async {
    await _prefs.setString('quality', quality.name);
    await _prefs.setBool('haptics', haptics);
    await _prefs.setBool('sound', sound);
    await _prefs.setBool('music', music);
    await _prefs.setBool('debugOverlay', debugOverlay);
    await _prefs.setBool('reducedFlashes', reducedFlashes);
    await _prefs.setString('palette', paletteName);
    await _prefs.setString('environment', environment.name);
    await _prefs.setString('modifier', modifier.name);
  }

  void update(void Function(PuffSettings s) edit) {
    edit(this);
    notifyListeners();
    save();
  }

  int highScoreFor(EnvironmentKind env) => highScores[env] ?? 0;

  int weeklyBestFor(String weekId) => weeklyBests[weekId] ?? 0;

  /// Returns true when [score] is a new best for the week [weekId].
  Future<bool> submitWeekly(String weekId, int score) async {
    if (score <= weeklyBestFor(weekId)) {
      return false;
    }
    weeklyBests
      ..clear()
      ..[weekId] = score;
    await _prefs.setString('weeklyBest', '$weekId:$score');
    notifyListeners();
    return true;
  }

  Future<void> saveAchievements() async {
    final a = achievements;
    await _prefs.setInt('runs', a.runs);
    await _prefs.setStringList('playedEnvironments', a.environments.toList());
    await _prefs.setStringList('playedModifiers', a.modifiers.toList());
    await _prefs.setStringList('playedPalettes', a.palettes.toList());
    await _prefs.setStringList('achievements', a.unlocked.toList());
  }

  Future<void> markReported(Iterable<String> ids) async {
    reportedAchievements.addAll(ids);
    await _prefs.setStringList('reportedAchievements', reportedAchievements.toList());
  }

  Future<void> addTip() async {
    tips++;
    await _prefs.setInt('tips', tips);
    notifyListeners();
  }

  Future<void> markReviewAsked(String version) async {
    lastReviewVersion = version;
    await _prefs.setString('lastReviewVersion', version);
  }

  /// Returns true when [score] is a new best for [env].
  Future<bool> submitScore(EnvironmentKind env, int score) async {
    if (score <= highScoreFor(env)) {
      return false;
    }
    highScores[env] = score;
    await _prefs.setInt('highScore_${env.name}', score);
    notifyListeners();
    return true;
  }
}

extension _ByNameOr<T extends Enum> on List<T> {
  T byNameOr(String? name, T fallback) {
    if (name == null) {
      return fallback;
    }
    for (final v in this) {
      if (v.name == name) {
        return v;
      }
    }
    return fallback;
  }
}
