// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get tagline => 'drž · ťahaj · pusti';

  @override
  String get play => 'HRAŤ';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'PROSTREDIE';

  @override
  String get modifierTitle => 'MODIFIKÁTOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'REBRÍČEK';

  @override
  String get settings => 'NASTAVENIA';

  @override
  String get paused => 'PAUZA';

  @override
  String get resume => 'POKRAČOVAŤ';

  @override
  String get restart => 'ZNOVU';

  @override
  String get nextTrack => '♪ ĎALŠIA SKLADBA';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'KONIEC HRY';

  @override
  String get newBest => 'NOVÝ REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   odsunuté $displaced   rozbité $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'ZNOVA';

  @override
  String get quality => 'KVALITA';

  @override
  String get qualityLow => 'NÍZKA';

  @override
  String get qualityMed => 'STREDNÁ';

  @override
  String get qualityHigh => 'VYSOKÁ';

  @override
  String get haptics => 'VIBRÁCIE';

  @override
  String get sound => 'ZVUK';

  @override
  String get music => 'HUDBA';

  @override
  String get debugOverlay => 'LADIACI PRIEHĽAD';

  @override
  String get back => 'SPÄŤ';

  @override
  String get on => 'ZAP.';

  @override
  String get off => 'VYP.';

  @override
  String get envVacuum => 'Vákuum';

  @override
  String get envAir => 'Vzduch';

  @override
  String get envWater => 'Voda';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Tlak';

  @override
  String get modImplosion => 'Implózia';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Gravitačná studňa';

  @override
  String get modChainSpark => 'Reťazová iskra';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Kyselina';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Žeravé uhlíky';

  @override
  String get paletteArctic => 'Arktída';

  @override
  String get heatTier1 => 'ŽIAR I';

  @override
  String get heatTier2 => 'ŽIAR II';

  @override
  String get heatTier3 => 'ŽIAR III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  uniklo $escaped/$max';
  }

  @override
  String get weekly => 'TÝŽDENNÁ VÝZVA';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'zostáva $days dní',
      few: 'zostávajú $days dni',
      one: 'zostáva 1 deň',
      zero: 'posledný deň',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'najlepšie za týždeň · $score';
  }

  @override
  String get achievements => 'ÚSPECHY';

  @override
  String get challenges => 'VÝZVY';

  @override
  String get share => 'ZDIEĽAŤ';

  @override
  String shareText(int score, String link) {
    return 'Môj nový rekord v Puff: $score. Prekonáš ho? $link';
  }

  @override
  String get reducedFlashes => 'MENEJ BLESKOV';

  @override
  String get paletteHoliday => 'Sviatočná';
}
