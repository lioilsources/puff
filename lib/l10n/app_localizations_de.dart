// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get tagline => 'halten · ziehen · loslassen';

  @override
  String get play => 'SPIELEN';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'UMGEBUNG';

  @override
  String get modifierTitle => 'MODIFIKATOR';

  @override
  String get paletteTitle => 'PALETTE';

  @override
  String get leaderboard => 'BESTENLISTE';

  @override
  String get settings => 'EINSTELLUNGEN';

  @override
  String get paused => 'PAUSE';

  @override
  String get resume => 'WEITER';

  @override
  String get restart => 'NEUSTART';

  @override
  String get nextTrack => '♪ NÄCHSTER TITEL';

  @override
  String get menu => 'MENÜ';

  @override
  String get gameOver => 'SPIEL VORBEI';

  @override
  String get newBest => 'NEUER REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   verschoben $displaced   zerbrochen $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'NOCHMAL';

  @override
  String get quality => 'QUALITÄT';

  @override
  String get qualityLow => 'NIEDRIG';

  @override
  String get qualityMed => 'MITTEL';

  @override
  String get qualityHigh => 'HOCH';

  @override
  String get haptics => 'VIBRATION';

  @override
  String get sound => 'SOUND';

  @override
  String get music => 'MUSIK';

  @override
  String get debugOverlay => 'DEBUG-OVERLAY';

  @override
  String get back => 'ZURÜCK';

  @override
  String get on => 'AN';

  @override
  String get off => 'AUS';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Luft';

  @override
  String get envWater => 'Wasser';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Druck';

  @override
  String get modImplosion => 'Implosion';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Schwerkraftsenke';

  @override
  String get modChainSpark => 'Kettenfunke';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Glut';

  @override
  String get paletteArctic => 'Arktis';

  @override
  String get heatTier1 => 'HITZE I';

  @override
  String get heatTier2 => 'HITZE II';

  @override
  String get heatTier3 => 'HITZE III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  entkommen $escaped/$max';
  }
}
