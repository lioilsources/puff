// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get tagline => 'тримай · тягни · відпусти';

  @override
  String get play => 'ГРАТИ';

  @override
  String bestScore(int score) {
    return 'рекорд · $score';
  }

  @override
  String get environmentTitle => 'СЕРЕДОВИЩЕ';

  @override
  String get modifierTitle => 'МОДИФІКАТОР';

  @override
  String get paletteTitle => 'ПАЛІТРА';

  @override
  String get leaderboard => 'РЕЙТИНГ';

  @override
  String get settings => 'НАЛАШТУВАННЯ';

  @override
  String get paused => 'ПАУЗА';

  @override
  String get resume => 'ПРОДОВЖИТИ';

  @override
  String get restart => 'ЗАНОВО';

  @override
  String get nextTrack => '♪ НАСТУПНИЙ ТРЕК';

  @override
  String get menu => 'МЕНЮ';

  @override
  String get gameOver => 'КІНЕЦЬ ГРИ';

  @override
  String get newBest => 'НОВИЙ РЕКОРД';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'комбо x$combo   зсунуто $displaced   розбито $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds с';
  }

  @override
  String get again => 'ЩЕ РАЗ';

  @override
  String get quality => 'ЯКІСТЬ';

  @override
  String get qualityLow => 'НИЗЬКА';

  @override
  String get qualityMed => 'СЕРЕДНЯ';

  @override
  String get qualityHigh => 'ВИСОКА';

  @override
  String get haptics => 'ВІБРАЦІЯ';

  @override
  String get sound => 'ЗВУК';

  @override
  String get music => 'МУЗИКА';

  @override
  String get debugOverlay => 'НАЛАГОДЖЕННЯ';

  @override
  String get back => 'НАЗАД';

  @override
  String get on => 'УВІМК.';

  @override
  String get off => 'ВИМК.';

  @override
  String get envVacuum => 'Вакуум';

  @override
  String get envAir => 'Повітря';

  @override
  String get envWater => 'Вода';

  @override
  String get envPlasma => 'Плазма';

  @override
  String get modPressure => 'Тиск';

  @override
  String get modImplosion => 'Імплозія';

  @override
  String get modMagnet => 'Магніт';

  @override
  String get modGravityWell => 'Гравітаційний колодязь';

  @override
  String get modChainSpark => 'Ланцюгова іскра';

  @override
  String get paletteCyberpunk => 'Кіберпанк';

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
  String get heatTierOverdrive => 'ОВЕРДРАЙВ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  комбо $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  втекло $escaped/$max';
  }

  @override
  String get weekly => 'ЩОТИЖНЕВИЙ ВИКЛИК';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'залишилося $days дня',
      many: 'залишилося $days днів',
      few: 'залишилися $days дні',
      one: 'залишився $days день',
      zero: 'останній день',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'найкращий за тиждень · $score';
  }

  @override
  String get achievements => 'ДОСЯГНЕННЯ';

  @override
  String get challenges => 'ВИКЛИКИ';

  @override
  String get share => 'ПОДІЛИТИСЯ';

  @override
  String shareText(int score, String link) {
    return 'Мій новий рекорд у Puff: $score. Зможеш побити? $link';
  }

  @override
  String get reducedFlashes => 'МЕНШЕ СПАЛАХІВ';

  @override
  String get paletteHoliday => 'Святкова';
}
