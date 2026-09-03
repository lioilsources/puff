import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game/fx/post_process.dart';
import '../game/palette.dart';
import '../game/sim/environment.dart';
import '../game/sim/modifier.dart';

/// Persisted player settings and local high scores (per environment).
class PuffSettings extends ChangeNotifier {
  PuffSettings._(this._prefs);

  final SharedPreferences _prefs;

  PostProcessQuality quality = PostProcessQuality.med;
  bool haptics = true;
  bool sound = true;
  bool debugOverlay = false;
  String paletteName = Palette.cyberpunk.name;
  EnvironmentKind environment = EnvironmentKind.vacuum;
  ModifierKind modifier = ModifierKind.pressure;
  final Map<EnvironmentKind, int> highScores = {};

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
    s.debugOverlay = prefs.getBool('debugOverlay') ?? false;
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
    return s;
  }

  Future<void> save() async {
    await _prefs.setString('quality', quality.name);
    await _prefs.setBool('haptics', haptics);
    await _prefs.setBool('sound', sound);
    await _prefs.setBool('debugOverlay', debugOverlay);
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
