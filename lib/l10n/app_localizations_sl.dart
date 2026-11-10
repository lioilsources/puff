// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get tagline => 'drži · povleci · spusti';

  @override
  String get play => 'IGRAJ';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'OKOLJE';

  @override
  String get modifierTitle => 'MODIFIKATOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'LESTVICA';

  @override
  String get settings => 'NASTAVITVE';

  @override
  String get paused => 'PAVZA';

  @override
  String get resume => 'NADALJUJ';

  @override
  String get restart => 'ZNOVA';

  @override
  String get nextTrack => '♪ NASLEDNJA SKLADBA';

  @override
  String get menu => 'MENI';

  @override
  String get gameOver => 'KONEC IGRE';

  @override
  String get newBest => 'NOV REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   premaknjeno $displaced   razbito $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'ŠE ENKRAT';

  @override
  String get quality => 'KAKOVOST';

  @override
  String get qualityLow => 'NIZKA';

  @override
  String get qualityMed => 'SREDNJA';

  @override
  String get qualityHigh => 'VISOKA';

  @override
  String get haptics => 'VIBRIRANJE';

  @override
  String get sound => 'ZVOK';

  @override
  String get music => 'GLASBA';

  @override
  String get debugOverlay => 'PRIKAZ ZA ODPRAVLJANJE NAPAK';

  @override
  String get back => 'NAZAJ';

  @override
  String get on => 'VKLOP';

  @override
  String get off => 'IZKLOP';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Zrak';

  @override
  String get envWater => 'Voda';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Tlak';

  @override
  String get modImplosion => 'Implozija';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Gravitacijski vodnjak';

  @override
  String get modChainSpark => 'Verižna iskra';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Kislina';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Žerjavica';

  @override
  String get paletteArctic => 'Arktika';

  @override
  String get heatTier1 => 'VROČINA I';

  @override
  String get heatTier2 => 'VROČINA II';

  @override
  String get heatTier3 => 'VROČINA III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  pobegnilo $escaped/$max';
  }

  @override
  String get weekly => 'TEDENSKI IZZIV';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ostaja $days dni',
      few: 'ostajajo $days dnevi',
      two: 'ostajata $days dneva',
      one: 'ostaja $days dan',
      zero: 'zadnji dan',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'najboljše v tednu · $score';
  }

  @override
  String get achievements => 'DOSEŽKI';

  @override
  String get challenges => 'IZZIVI';

  @override
  String get share => 'DELI';

  @override
  String shareText(int score, String link) {
    return 'Moj nov rekord v Puff: $score. Ga lahko premagaš? $link';
  }

  @override
  String get reducedFlashes => 'MANJ BLISKOV';

  @override
  String get paletteHoliday => 'Praznična';
}
