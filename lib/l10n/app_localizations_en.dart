// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tagline => 'hold · drag · release';

  @override
  String get play => 'PLAY';

  @override
  String bestScore(int score) {
    return 'best · $score';
  }

  @override
  String get environmentTitle => 'ENVIRONMENT';

  @override
  String get modifierTitle => 'MODIFIER';

  @override
  String get paletteTitle => 'PALETTE';

  @override
  String get leaderboard => 'LEADERBOARD';

  @override
  String get settings => 'SETTINGS';

  @override
  String get paused => 'PAUSED';

  @override
  String get resume => 'RESUME';

  @override
  String get restart => 'RESTART';

  @override
  String get nextTrack => '♪ NEXT TRACK';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'GAME OVER';

  @override
  String get newBest => 'NEW BEST';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   displaced $displaced   broken $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · ${seconds}s';
  }

  @override
  String get again => 'AGAIN';

  @override
  String get quality => 'QUALITY';

  @override
  String get qualityLow => 'LOW';

  @override
  String get qualityMed => 'MED';

  @override
  String get qualityHigh => 'HIGH';

  @override
  String get haptics => 'HAPTICS';

  @override
  String get sound => 'SOUND';

  @override
  String get music => 'MUSIC';

  @override
  String get debugOverlay => 'DEBUG OVERLAY';

  @override
  String get back => 'BACK';

  @override
  String get on => 'ON';

  @override
  String get off => 'OFF';

  @override
  String get envVacuum => 'Vacuum';

  @override
  String get envAir => 'Air';

  @override
  String get envWater => 'Water';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Pressure';

  @override
  String get modImplosion => 'Implosion';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Gravity well';

  @override
  String get modChainSpark => 'Chain spark';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Ember';

  @override
  String get paletteArctic => 'Arctic';

  @override
  String get heatTier1 => 'HEAT I';

  @override
  String get heatTier2 => 'HEAT II';

  @override
  String get heatTier3 => 'HEAT III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  escaped $escaped/$max';
  }
}
