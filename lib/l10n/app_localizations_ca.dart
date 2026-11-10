// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get tagline => 'mantén · arrossega · deixa anar';

  @override
  String get play => 'JUGA';

  @override
  String bestScore(int score) {
    return 'rècord · $score';
  }

  @override
  String get environmentTitle => 'ENTORN';

  @override
  String get modifierTitle => 'MODIFICADOR';

  @override
  String get paletteTitle => 'PAL·LETA';

  @override
  String get leaderboard => 'CLASSIFICACIÓ';

  @override
  String get settings => 'AJUSTOS';

  @override
  String get paused => 'EN PAUSA';

  @override
  String get resume => 'CONTINUA';

  @override
  String get restart => 'REINICIA';

  @override
  String get nextTrack => '♪ SEGÜENT PISTA';

  @override
  String get menu => 'MENÚ';

  @override
  String get gameOver => 'FI DEL JOC';

  @override
  String get newBest => 'NOU RÈCORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   desplaçades $displaced   trencades $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'TORNA-HI';

  @override
  String get quality => 'QUALITAT';

  @override
  String get qualityLow => 'BAIXA';

  @override
  String get qualityMed => 'MITJA';

  @override
  String get qualityHigh => 'ALTA';

  @override
  String get haptics => 'VIBRACIÓ';

  @override
  String get sound => 'SO';

  @override
  String get music => 'MÚSICA';

  @override
  String get debugOverlay => 'SUPERPOSICIÓ DE DEPURACIÓ';

  @override
  String get back => 'ENRERE';

  @override
  String get on => 'SÍ';

  @override
  String get off => 'NO';

  @override
  String get envVacuum => 'Buit';

  @override
  String get envAir => 'Aire';

  @override
  String get envWater => 'Aigua';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Pressió';

  @override
  String get modImplosion => 'Implosió';

  @override
  String get modMagnet => 'Imant';

  @override
  String get modGravityWell => 'Pou gravitatori';

  @override
  String get modChainSpark => 'Espurna en cadena';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Àcid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Brasa';

  @override
  String get paletteArctic => 'Àrtic';

  @override
  String get heatTier1 => 'CALOR I';

  @override
  String get heatTier2 => 'CALOR II';

  @override
  String get heatTier3 => 'CALOR III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  escapades $escaped/$max';
  }

  @override
  String get weekly => 'REPTE SETMANAL';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'queden $days dies',
      one: 'queda 1 dia',
      zero: 'últim dia',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'millor de la setmana · $score';
  }

  @override
  String get achievements => 'ASSOLIMENTS';

  @override
  String get challenges => 'REPTES';

  @override
  String get share => 'COMPARTEIX';

  @override
  String shareText(int score, String link) {
    return 'El meu nou rècord a Puff: $score. El pots superar? $link';
  }

  @override
  String get reducedFlashes => 'MENYS FLASHOS';

  @override
  String get paletteHoliday => 'Festiu';
}
