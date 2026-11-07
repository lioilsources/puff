// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tagline => 'mantén · arrastra · suelta';

  @override
  String get play => 'JUGAR';

  @override
  String bestScore(int score) {
    return 'récord · $score';
  }

  @override
  String get environmentTitle => 'ENTORNO';

  @override
  String get modifierTitle => 'MODIFICADOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'CLASIFICACIÓN';

  @override
  String get settings => 'AJUSTES';

  @override
  String get paused => 'PAUSA';

  @override
  String get resume => 'CONTINUAR';

  @override
  String get restart => 'REINICIAR';

  @override
  String get nextTrack => '♪ SIGUIENTE PISTA';

  @override
  String get menu => 'MENÚ';

  @override
  String get gameOver => 'FIN DE LA PARTIDA';

  @override
  String get newBest => 'NUEVO RÉCORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   desplazados $displaced   rotos $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'OTRA VEZ';

  @override
  String get quality => 'CALIDAD';

  @override
  String get qualityLow => 'BAJA';

  @override
  String get qualityMed => 'MEDIA';

  @override
  String get qualityHigh => 'ALTA';

  @override
  String get haptics => 'VIBRACIÓN';

  @override
  String get sound => 'SONIDO';

  @override
  String get music => 'MÚSICA';

  @override
  String get debugOverlay => 'DEPURACIÓN';

  @override
  String get back => 'ATRÁS';

  @override
  String get on => 'SÍ';

  @override
  String get off => 'NO';

  @override
  String get envVacuum => 'Vacío';

  @override
  String get envAir => 'Aire';

  @override
  String get envWater => 'Agua';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Presión';

  @override
  String get modImplosion => 'Implosión';

  @override
  String get modMagnet => 'Imán';

  @override
  String get modGravityWell => 'Pozo gravitatorio';

  @override
  String get modChainSpark => 'Chispa en cadena';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Ácido';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Brasa';

  @override
  String get paletteArctic => 'Ártico';

  @override
  String get heatTier1 => 'CALOR I';

  @override
  String get heatTier2 => 'CALOR II';

  @override
  String get heatTier3 => 'CALOR III';

  @override
  String get heatTierOverdrive => 'SOBRECARGA';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  escapados $escaped/$max';
  }

  @override
  String get weekly => 'RETO SEMANAL';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'quedan $days días',
      one: 'queda 1 día',
      zero: 'último día',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'mejor de la semana · $score';
  }

  @override
  String get achievements => 'LOGROS';

  @override
  String get challenges => 'DESAFÍOS';

  @override
  String get share => 'COMPARTIR';

  @override
  String shareText(int score, String link) {
    return 'Mi nuevo récord en Puff: $score. ¿Lo superas? $link';
  }

  @override
  String get reducedFlashes => 'MENOS DESTELLOS';

  @override
  String get paletteHoliday => 'Fiestas';

  @override
  String get supporter => 'MECENAS';

  @override
  String get tipJar => 'PROPINA';

  @override
  String get tipJarInfo =>
      'Puff sigue siendo gratis y sin anuncios. Una propina no desbloquea nada: solo da las gracias y añade una insignia de mecenas al menú.';

  @override
  String get tipSmall => 'PROPINA PEQUEÑA';

  @override
  String get tipMedium => 'PROPINA MEDIANA';

  @override
  String get tipLarge => 'PROPINA GRANDE';

  @override
  String get tipThanks => '¡GRACIAS!';

  @override
  String get tipFailed => 'LA COMPRA NO SE COMPLETÓ';
}
