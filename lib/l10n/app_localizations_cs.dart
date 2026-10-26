// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get tagline => 'drž · táhni · pusť';

  @override
  String get play => 'HRÁT';

  @override
  String bestScore(int score) {
    return 'nejlepší · $score';
  }

  @override
  String get environmentTitle => 'PROSTŘEDÍ';

  @override
  String get modifierTitle => 'MODIFIKÁTOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'ŽEBŘÍČEK';

  @override
  String get settings => 'NASTAVENÍ';

  @override
  String get paused => 'PAUZA';

  @override
  String get resume => 'POKRAČOVAT';

  @override
  String get restart => 'ZAČÍT ZNOVU';

  @override
  String get nextTrack => '♪ DALŠÍ SKLADBA';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'KONEC HRY';

  @override
  String get newBest => 'NOVÝ REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   odsunuto $displaced   rozbito $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'ZNOVU';

  @override
  String get quality => 'KVALITA';

  @override
  String get qualityLow => 'NÍZKÁ';

  @override
  String get qualityMed => 'STŘEDNÍ';

  @override
  String get qualityHigh => 'VYSOKÁ';

  @override
  String get haptics => 'VIBRACE';

  @override
  String get sound => 'ZVUKY';

  @override
  String get music => 'HUDBA';

  @override
  String get debugOverlay => 'LADĚNÍ';

  @override
  String get back => 'ZPĚT';

  @override
  String get on => 'ZAP';

  @override
  String get off => 'VYP';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Vzduch';

  @override
  String get envWater => 'Voda';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Tlak';

  @override
  String get modImplosion => 'Imploze';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Gravitační studna';

  @override
  String get modChainSpark => 'Řetězová jiskra';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Žár';

  @override
  String get paletteArctic => 'Arktida';

  @override
  String get heatTier1 => 'ŽÁR I';

  @override
  String get heatTier2 => 'ŽÁR II';

  @override
  String get heatTier3 => 'ŽÁR III';

  @override
  String get heatTierOverdrive => 'PŘETÍŽENÍ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  uniklo $escaped/$max';
  }
}
