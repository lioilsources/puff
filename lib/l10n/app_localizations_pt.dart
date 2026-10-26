// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get tagline => 'segure · arraste · solte';

  @override
  String get play => 'JOGAR';

  @override
  String bestScore(int score) {
    return 'recorde · $score';
  }

  @override
  String get environmentTitle => 'AMBIENTE';

  @override
  String get modifierTitle => 'MODIFICADOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'CLASSIFICAÇÃO';

  @override
  String get settings => 'AJUSTES';

  @override
  String get paused => 'PAUSADO';

  @override
  String get resume => 'CONTINUAR';

  @override
  String get restart => 'REINICIAR';

  @override
  String get nextTrack => '♪ PRÓXIMA FAIXA';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'FIM DE JOGO';

  @override
  String get newBest => 'NOVO RECORDE';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   deslocados $displaced   quebrados $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'DE NOVO';

  @override
  String get quality => 'QUALIDADE';

  @override
  String get qualityLow => 'BAIXA';

  @override
  String get qualityMed => 'MÉDIA';

  @override
  String get qualityHigh => 'ALTA';

  @override
  String get haptics => 'VIBRAÇÃO';

  @override
  String get sound => 'SOM';

  @override
  String get music => 'MÚSICA';

  @override
  String get debugOverlay => 'DEPURAÇÃO';

  @override
  String get back => 'VOLTAR';

  @override
  String get on => 'SIM';

  @override
  String get off => 'NÃO';

  @override
  String get envVacuum => 'Vácuo';

  @override
  String get envAir => 'Ar';

  @override
  String get envWater => 'Água';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Pressão';

  @override
  String get modImplosion => 'Implosão';

  @override
  String get modMagnet => 'Ímã';

  @override
  String get modGravityWell => 'Poço gravitacional';

  @override
  String get modChainSpark => 'Faísca em cadeia';

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
    return '$environment  escaparam $escaped/$max';
  }
}
