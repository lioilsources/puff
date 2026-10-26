// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get tagline => 'tieni · trascina · rilascia';

  @override
  String get play => 'GIOCA';

  @override
  String bestScore(int score) {
    return 'record · $score';
  }

  @override
  String get environmentTitle => 'AMBIENTE';

  @override
  String get modifierTitle => 'MODIFICATORE';

  @override
  String get paletteTitle => 'TAVOLOZZA';

  @override
  String get leaderboard => 'CLASSIFICA';

  @override
  String get settings => 'IMPOSTAZIONI';

  @override
  String get paused => 'PAUSA';

  @override
  String get resume => 'RIPRENDI';

  @override
  String get restart => 'RICOMINCIA';

  @override
  String get nextTrack => '♪ BRANO SUCCESSIVO';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'PARTITA FINITA';

  @override
  String get newBest => 'NUOVO RECORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   spostati $displaced   rotti $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'ANCORA';

  @override
  String get quality => 'QUALITÀ';

  @override
  String get qualityLow => 'BASSA';

  @override
  String get qualityMed => 'MEDIA';

  @override
  String get qualityHigh => 'ALTA';

  @override
  String get haptics => 'VIBRAZIONE';

  @override
  String get sound => 'SUONI';

  @override
  String get music => 'MUSICA';

  @override
  String get debugOverlay => 'DEBUG';

  @override
  String get back => 'INDIETRO';

  @override
  String get on => 'SÌ';

  @override
  String get off => 'NO';

  @override
  String get envVacuum => 'Vuoto';

  @override
  String get envAir => 'Aria';

  @override
  String get envWater => 'Acqua';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Pressione';

  @override
  String get modImplosion => 'Implosione';

  @override
  String get modMagnet => 'Magnete';

  @override
  String get modGravityWell => 'Pozzo gravitazionale';

  @override
  String get modChainSpark => 'Scintilla a catena';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acido';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Brace';

  @override
  String get paletteArctic => 'Artico';

  @override
  String get heatTier1 => 'CALORE I';

  @override
  String get heatTier2 => 'CALORE II';

  @override
  String get heatTier3 => 'CALORE III';

  @override
  String get heatTierOverdrive => 'SOVRACCARICO';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  fuggiti $escaped/$max';
  }
}
