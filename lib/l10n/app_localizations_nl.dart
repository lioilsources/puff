// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get tagline => 'vasthouden · slepen · loslaten';

  @override
  String get play => 'SPELEN';

  @override
  String bestScore(int score) {
    return 'record · $score';
  }

  @override
  String get environmentTitle => 'OMGEVING';

  @override
  String get modifierTitle => 'MODIFIER';

  @override
  String get paletteTitle => 'PALET';

  @override
  String get leaderboard => 'RANGLIJST';

  @override
  String get settings => 'INSTELLINGEN';

  @override
  String get paused => 'PAUZE';

  @override
  String get resume => 'HERVATTEN';

  @override
  String get restart => 'OPNIEUW';

  @override
  String get nextTrack => '♪ VOLGEND NUMMER';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'GAME OVER';

  @override
  String get newBest => 'NIEUW RECORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   verplaatst $displaced   gebroken $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'NOG EEN KEER';

  @override
  String get quality => 'KWALITEIT';

  @override
  String get qualityLow => 'LAAG';

  @override
  String get qualityMed => 'MIDDEL';

  @override
  String get qualityHigh => 'HOOG';

  @override
  String get haptics => 'TRILLING';

  @override
  String get sound => 'GELUID';

  @override
  String get music => 'MUZIEK';

  @override
  String get debugOverlay => 'DEBUG-OVERLAY';

  @override
  String get back => 'TERUG';

  @override
  String get on => 'AAN';

  @override
  String get off => 'UIT';

  @override
  String get envVacuum => 'Vacuüm';

  @override
  String get envAir => 'Lucht';

  @override
  String get envWater => 'Water';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Druk';

  @override
  String get modImplosion => 'Implosie';

  @override
  String get modMagnet => 'Magneet';

  @override
  String get modGravityWell => 'Zwaartekrachtput';

  @override
  String get modChainSpark => 'Kettingvonk';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Gloed';

  @override
  String get paletteArctic => 'Arctisch';

  @override
  String get heatTier1 => 'HITTE I';

  @override
  String get heatTier2 => 'HITTE II';

  @override
  String get heatTier3 => 'HITTE III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  ontsnapt $escaped/$max';
  }

  @override
  String get weekly => 'WEEKUITDAGING';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'nog $days dagen',
      one: 'nog 1 dag',
      zero: 'laatste dag',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'weekrecord · $score';
  }

  @override
  String get achievements => 'PRESTATIES';

  @override
  String get challenges => 'UITDAGINGEN';

  @override
  String get share => 'DELEN';

  @override
  String shareText(int score, String link) {
    return 'Mijn nieuwe record in Puff: $score. Kun jij het verbeteren? $link';
  }

  @override
  String get reducedFlashes => 'MINDER FLITSEN';

  @override
  String get paletteHoliday => 'Feestdagen';

  @override
  String get supporter => 'SUPPORTER';

  @override
  String get tipJar => 'FOOI';

  @override
  String get tipJarInfo =>
      'Puff blijft gratis en zonder advertenties. Een fooi ontgrendelt niets — het is gewoon een bedankje, met een supportersbadge in het menu.';

  @override
  String get tipSmall => 'KLEINE FOOI';

  @override
  String get tipMedium => 'MIDDELGROTE FOOI';

  @override
  String get tipLarge => 'GROTE FOOI';

  @override
  String get tipThanks => 'BEDANKT!';

  @override
  String get tipFailed => 'AANKOOP IS NIET GELUKT';
}
