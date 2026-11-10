// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get tagline => 'ține · trage · eliberează';

  @override
  String get play => 'JOACĂ';

  @override
  String bestScore(int score) {
    return 'record · $score';
  }

  @override
  String get environmentTitle => 'MEDIU';

  @override
  String get modifierTitle => 'MODIFICATOR';

  @override
  String get paletteTitle => 'PALETĂ';

  @override
  String get leaderboard => 'CLASAMENT';

  @override
  String get settings => 'SETĂRI';

  @override
  String get paused => 'PAUZĂ';

  @override
  String get resume => 'CONTINUĂ';

  @override
  String get restart => 'REPORNEȘTE';

  @override
  String get nextTrack => '♪ PIESA URMĂTOARE';

  @override
  String get menu => 'MENIU';

  @override
  String get gameOver => 'JOC TERMINAT';

  @override
  String get newBest => 'RECORD NOU';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   deplasate $displaced   sparte $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'DIN NOU';

  @override
  String get quality => 'CALITATE';

  @override
  String get qualityLow => 'SCĂZUTĂ';

  @override
  String get qualityMed => 'MEDIE';

  @override
  String get qualityHigh => 'RIDICATĂ';

  @override
  String get haptics => 'VIBRAȚII';

  @override
  String get sound => 'SUNET';

  @override
  String get music => 'MUZICĂ';

  @override
  String get debugOverlay => 'STRAT DE DEPANARE';

  @override
  String get back => 'ÎNAPOI';

  @override
  String get on => 'PORNIT';

  @override
  String get off => 'OPRIT';

  @override
  String get envVacuum => 'Vid';

  @override
  String get envAir => 'Aer';

  @override
  String get envWater => 'Apă';

  @override
  String get envPlasma => 'Plasmă';

  @override
  String get modPressure => 'Presiune';

  @override
  String get modImplosion => 'Implozie';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Put gravitațional';

  @override
  String get modChainSpark => 'Scânteie în lanț';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Jar';

  @override
  String get paletteArctic => 'Arctic';

  @override
  String get heatTier1 => 'CĂLDURĂ I';

  @override
  String get heatTier2 => 'CĂLDURĂ II';

  @override
  String get heatTier3 => 'CĂLDURĂ III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  scăpate $escaped/$max';
  }

  @override
  String get weekly => 'PROVOCAREA SĂPTĂMÂNII';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'au mai rămas $days de zile',
      few: 'au mai rămas $days zile',
      one: 'a mai rămas 1 zi',
      zero: 'ultima zi',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'cel mai bun al săptămânii · $score';
  }

  @override
  String get achievements => 'REALIZĂRI';

  @override
  String get challenges => 'PROVOCĂRI';

  @override
  String get share => 'DISTRIBUIE';

  @override
  String shareText(int score, String link) {
    return 'Noul meu record în Puff: $score. Îl poți depăși? $link';
  }

  @override
  String get reducedFlashes => 'MAI PUȚINE FLASH-URI';

  @override
  String get paletteHoliday => 'Sărbători';
}
