// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get tagline => 'hold · træk · slip';

  @override
  String get play => 'SPIL';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'MILJØ';

  @override
  String get modifierTitle => 'MODIFIKATOR';

  @override
  String get paletteTitle => 'PALET';

  @override
  String get leaderboard => 'TOPLISTE';

  @override
  String get settings => 'INDSTILLINGER';

  @override
  String get paused => 'PAUSET';

  @override
  String get resume => 'FORTSÆT';

  @override
  String get restart => 'START FORFRA';

  @override
  String get nextTrack => '♪ NÆSTE NUMMER';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'SPILLET ER SLUT';

  @override
  String get newBest => 'NY REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   skubbet $displaced   knust $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'IGEN';

  @override
  String get quality => 'KVALITET';

  @override
  String get qualityLow => 'LAV';

  @override
  String get qualityMed => 'MELLEM';

  @override
  String get qualityHigh => 'HØJ';

  @override
  String get haptics => 'VIBRATION';

  @override
  String get sound => 'LYD';

  @override
  String get music => 'MUSIK';

  @override
  String get debugOverlay => 'DEBUG-OVERLAY';

  @override
  String get back => 'TILBAGE';

  @override
  String get on => 'TIL';

  @override
  String get off => 'FRA';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Luft';

  @override
  String get envWater => 'Vand';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Tryk';

  @override
  String get modImplosion => 'Implosion';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Tyngdebrønd';

  @override
  String get modChainSpark => 'Kædegnist';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Syre';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Glød';

  @override
  String get paletteArctic => 'Arktis';

  @override
  String get heatTier1 => 'VARME I';

  @override
  String get heatTier2 => 'VARME II';

  @override
  String get heatTier3 => 'VARME III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  sluppet væk $escaped/$max';
  }

  @override
  String get weekly => 'UGENTLIG UDFORDRING';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dage tilbage',
      one: '1 dag tilbage',
      zero: 'sidste dag',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ugens bedste · $score';
  }

  @override
  String get achievements => 'PRÆSTATIONER';

  @override
  String get challenges => 'UDFORDRINGER';

  @override
  String get share => 'DEL';

  @override
  String shareText(int score, String link) {
    return 'Min nye rekord i Puff: $score. Kan du slå den? $link';
  }

  @override
  String get reducedFlashes => 'FÆRRE BLIK';

  @override
  String get paletteHoliday => 'Højtid';
}
