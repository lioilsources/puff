// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get tagline => 'держи · тяни · отпускай';

  @override
  String get play => 'ИГРАТЬ';

  @override
  String bestScore(int score) {
    return 'рекорд · $score';
  }

  @override
  String get environmentTitle => 'СРЕДА';

  @override
  String get modifierTitle => 'МОДИФИКАТОР';

  @override
  String get paletteTitle => 'ПАЛИТРА';

  @override
  String get leaderboard => 'РЕЙТИНГ';

  @override
  String get settings => 'НАСТРОЙКИ';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get resume => 'ПРОДОЛЖИТЬ';

  @override
  String get restart => 'ЗАНОВО';

  @override
  String get nextTrack => '♪ СЛЕДУЮЩИЙ ТРЕК';

  @override
  String get menu => 'МЕНЮ';

  @override
  String get gameOver => 'ИГРА ОКОНЧЕНА';

  @override
  String get newBest => 'НОВЫЙ РЕКОРД';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'комбо x$combo   сдвинуто $displaced   разбито $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds с';
  }

  @override
  String get again => 'ЕЩЁ РАЗ';

  @override
  String get quality => 'КАЧЕСТВО';

  @override
  String get qualityLow => 'НИЗКОЕ';

  @override
  String get qualityMed => 'СРЕДНЕЕ';

  @override
  String get qualityHigh => 'ВЫСОКОЕ';

  @override
  String get haptics => 'ВИБРАЦИЯ';

  @override
  String get sound => 'ЗВУК';

  @override
  String get music => 'МУЗЫКА';

  @override
  String get debugOverlay => 'ОТЛАДКА';

  @override
  String get back => 'НАЗАД';

  @override
  String get on => 'ВКЛ';

  @override
  String get off => 'ВЫКЛ';

  @override
  String get envVacuum => 'Вакуум';

  @override
  String get envAir => 'Воздух';

  @override
  String get envWater => 'Вода';

  @override
  String get envPlasma => 'Плазма';

  @override
  String get modPressure => 'Давление';

  @override
  String get modImplosion => 'Имплозия';

  @override
  String get modMagnet => 'Магнит';

  @override
  String get modGravityWell => 'Гравитационный колодец';

  @override
  String get modChainSpark => 'Цепная искра';

  @override
  String get paletteCyberpunk => 'Киберпанк';

  @override
  String get paletteVaporwave => 'Вейпорвейв';

  @override
  String get paletteAcid => 'Кислота';

  @override
  String get paletteMono => 'Моно';

  @override
  String get paletteEmber => 'Жар';

  @override
  String get paletteArctic => 'Арктика';

  @override
  String get heatTier1 => 'ЖАР I';

  @override
  String get heatTier2 => 'ЖАР II';

  @override
  String get heatTier3 => 'ЖАР III';

  @override
  String get heatTierOverdrive => 'ПЕРЕГРУЗКА';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  комбо $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  сбежало $escaped/$max';
  }
}
