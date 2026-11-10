// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get tagline => 'drži · povuci · pusti';

  @override
  String get play => 'IGRAJ';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'OKOLINA';

  @override
  String get modifierTitle => 'MODIFIKATOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'LJESTVICA';

  @override
  String get settings => 'POSTAVKE';

  @override
  String get paused => 'PAUZA';

  @override
  String get resume => 'NASTAVI';

  @override
  String get restart => 'PONOVNO';

  @override
  String get nextTrack => '♪ SLJEDEĆA SKLADBA';

  @override
  String get menu => 'IZBORNIK';

  @override
  String get gameOver => 'KRAJ IGRE';

  @override
  String get newBest => 'NOVI REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   pomaknuto $displaced   razbijeno $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'OPET';

  @override
  String get quality => 'KVALITETA';

  @override
  String get qualityLow => 'NISKA';

  @override
  String get qualityMed => 'SREDNJA';

  @override
  String get qualityHigh => 'VISOKA';

  @override
  String get haptics => 'VIBRACIJA';

  @override
  String get sound => 'ZVUK';

  @override
  String get music => 'GLAZBA';

  @override
  String get debugOverlay => 'DEBUG PRIKAZ';

  @override
  String get back => 'NAZAD';

  @override
  String get on => 'UKLJ';

  @override
  String get off => 'ISKLJ';

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
  String get modGravityWell => 'Gravitacijski bunar';

  @override
  String get modChainSpark => 'Lančana iskra';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Kiselina';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Žar';

  @override
  String get paletteArctic => 'Arktik';

  @override
  String get heatTier1 => 'ŽAR I';

  @override
  String get heatTier2 => 'ŽAR II';

  @override
  String get heatTier3 => 'ŽAR III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  pobjeglo $escaped/$max';
  }

  @override
  String get weekly => 'TJEDNI IZAZOV';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'ostalo $days dana',
      few: 'ostala $days dana',
      one: 'ostao $days dan',
      zero: 'zadnji dan',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'najbolje u tjednu · $score';
  }

  @override
  String get achievements => 'POSTIGNUĆA';

  @override
  String get challenges => 'IZAZOVI';

  @override
  String get share => 'PODIJELI';

  @override
  String shareText(int score, String link) {
    return 'Moj novi rekord u Puffu: $score. Možeš li ga srušiti? $link';
  }

  @override
  String get reducedFlashes => 'MANJE BLJESKOVA';

  @override
  String get paletteHoliday => 'Blagdanska';
}
