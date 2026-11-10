// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get tagline => 'pidä · vedä · päästä irti';

  @override
  String get play => 'PELAA';

  @override
  String bestScore(int score) {
    return 'ennätys · $score';
  }

  @override
  String get environmentTitle => 'YMPÄRISTÖ';

  @override
  String get modifierTitle => 'MUUNNIN';

  @override
  String get paletteTitle => 'PALETTI';

  @override
  String get leaderboard => 'TULOSLISTA';

  @override
  String get settings => 'ASETUKSET';

  @override
  String get paused => 'TAUOLLA';

  @override
  String get resume => 'JATKA';

  @override
  String get restart => 'ALOITA ALUSTA';

  @override
  String get nextTrack => '♪ SEURAAVA KAPPALE';

  @override
  String get menu => 'VALIKKO';

  @override
  String get gameOver => 'PELI PÄÄTTYI';

  @override
  String get newBest => 'UUSI ENNÄTYS';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   siirretty $displaced   rikottu $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'VIELÄ KERRAN';

  @override
  String get quality => 'LAATU';

  @override
  String get qualityLow => 'MATALA';

  @override
  String get qualityMed => 'KESKI';

  @override
  String get qualityHigh => 'KORKEA';

  @override
  String get haptics => 'TÄRINÄ';

  @override
  String get sound => 'ÄÄNI';

  @override
  String get music => 'MUSIIKKI';

  @override
  String get debugOverlay => 'DEBUG-KERROS';

  @override
  String get back => 'TAKAISIN';

  @override
  String get on => 'PÄÄLLÄ';

  @override
  String get off => 'POIS';

  @override
  String get envVacuum => 'Tyhjiö';

  @override
  String get envAir => 'Ilma';

  @override
  String get envWater => 'Vesi';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Paine';

  @override
  String get modImplosion => 'Implosio';

  @override
  String get modMagnet => 'Magneetti';

  @override
  String get modGravityWell => 'Painovoimakaivo';

  @override
  String get modChainSpark => 'Ketjukipinä';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Happo';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Hiillos';

  @override
  String get paletteArctic => 'Arktinen';

  @override
  String get heatTier1 => 'KUUMUUS I';

  @override
  String get heatTier2 => 'KUUMUUS II';

  @override
  String get heatTier3 => 'KUUMUUS III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  paennut $escaped/$max';
  }

  @override
  String get weekly => 'VIIKON HAASTE';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days päivää jäljellä',
      one: '1 päivä jäljellä',
      zero: 'viimeinen päivä',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'viikon paras · $score';
  }

  @override
  String get achievements => 'SAAVUTUKSET';

  @override
  String get challenges => 'HAASTEET';

  @override
  String get share => 'JAA';

  @override
  String shareText(int score, String link) {
    return 'Uusi ennätykseni Puffissa: $score. Pystytkö voittamaan? $link';
  }

  @override
  String get reducedFlashes => 'VÄHEMMÄN VÄLÄHDYKSIÄ';

  @override
  String get paletteHoliday => 'Juhla';
}
