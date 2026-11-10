// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get tagline => 'hold · dra · slipp';

  @override
  String get play => 'SPILL';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'MILJØ';

  @override
  String get modifierTitle => 'MODIFIKATOR';

  @override
  String get paletteTitle => 'PALETT';

  @override
  String get leaderboard => 'TOPPLISTE';

  @override
  String get settings => 'INNSTILLINGER';

  @override
  String get paused => 'PAUSET';

  @override
  String get resume => 'FORTSETT';

  @override
  String get restart => 'START PÅ NYTT';

  @override
  String get nextTrack => '♪ NESTE LÅT';

  @override
  String get menu => 'MENY';

  @override
  String get gameOver => 'SPILLET ER SLUTT';

  @override
  String get newBest => 'NY REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   flyttet $displaced   knust $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'IGJEN';

  @override
  String get quality => 'KVALITET';

  @override
  String get qualityLow => 'LAV';

  @override
  String get qualityMed => 'MIDDELS';

  @override
  String get qualityHigh => 'HØY';

  @override
  String get haptics => 'VIBRASJON';

  @override
  String get sound => 'LYD';

  @override
  String get music => 'MUSIKK';

  @override
  String get debugOverlay => 'DEBUG-OVERLEGG';

  @override
  String get back => 'TILBAKE';

  @override
  String get on => 'PÅ';

  @override
  String get off => 'AV';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Luft';

  @override
  String get envWater => 'Vann';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Trykk';

  @override
  String get modImplosion => 'Implosjon';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Tyngdebrønn';

  @override
  String get modChainSpark => 'Kjedegnist';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Syre';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Glør';

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
    return '$environment  sluppet unna $escaped/$max';
  }

  @override
  String get weekly => 'UKENTLIG UTFORDRING';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dager igjen',
      one: '1 dag igjen',
      zero: 'siste dag',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ukens beste · $score';
  }

  @override
  String get achievements => 'PRESTASJONER';

  @override
  String get challenges => 'UTFORDRINGER';

  @override
  String get share => 'DEL';

  @override
  String shareText(int score, String link) {
    return 'Min nye rekord i Puff: $score. Kan du slå den? $link';
  }

  @override
  String get reducedFlashes => 'FÆRRE BLINK';

  @override
  String get paletteHoliday => 'Høytid';
}
