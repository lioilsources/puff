// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get tagline => 'پکڑیں · کھینچیں · چھوڑیں';

  @override
  String get play => 'کھیلیں';

  @override
  String bestScore(int score) {
    return 'بہترین · $score';
  }

  @override
  String get environmentTitle => 'ماحول';

  @override
  String get modifierTitle => 'موڈیفائر';

  @override
  String get paletteTitle => 'رنگ پیلیٹ';

  @override
  String get leaderboard => 'لیڈر بورڈ';

  @override
  String get settings => 'ترتیبات';

  @override
  String get paused => 'رکا ہوا';

  @override
  String get resume => 'جاری رکھیں';

  @override
  String get restart => 'دوبارہ شروع کریں';

  @override
  String get nextTrack => '♪ اگلا ٹریک';

  @override
  String get menu => 'مینو';

  @override
  String get gameOver => 'کھیل ختم';

  @override
  String get newBest => 'نیا بہترین';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'کومبو x$combo   ہٹائے $displaced   ٹوٹے $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds سیکنڈ';
  }

  @override
  String get again => 'پھر سے';

  @override
  String get quality => 'معیار';

  @override
  String get qualityLow => 'کم';

  @override
  String get qualityMed => 'درمیانہ';

  @override
  String get qualityHigh => 'اعلیٰ';

  @override
  String get haptics => 'ارتعاش';

  @override
  String get sound => 'آواز';

  @override
  String get music => 'موسیقی';

  @override
  String get debugOverlay => 'ڈیبگ اوورلے';

  @override
  String get back => 'واپس';

  @override
  String get on => 'آن';

  @override
  String get off => 'آف';

  @override
  String get envVacuum => 'خلا';

  @override
  String get envAir => 'ہوا';

  @override
  String get envWater => 'پانی';

  @override
  String get envPlasma => 'پلازما';

  @override
  String get modPressure => 'دباؤ';

  @override
  String get modImplosion => 'اندرونی دھماکہ';

  @override
  String get modMagnet => 'مقناطیس';

  @override
  String get modGravityWell => 'کششِ ثقل کا کنواں';

  @override
  String get modChainSpark => 'زنجیری چنگاری';

  @override
  String get paletteCyberpunk => 'سائبرپنک';

  @override
  String get paletteVaporwave => 'ویپروِیو';

  @override
  String get paletteAcid => 'تیزاب';

  @override
  String get paletteMono => 'مونو';

  @override
  String get paletteEmber => 'انگارہ';

  @override
  String get paletteArctic => 'آرکٹک';

  @override
  String get heatTier1 => 'حرارت I';

  @override
  String get heatTier2 => 'حرارت II';

  @override
  String get heatTier3 => 'حرارت III';

  @override
  String get heatTierOverdrive => 'اوورڈرائیو';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  کومبو $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  بچ نکلے $escaped/$max';
  }

  @override
  String get weekly => 'ہفتہ وار چیلنج';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days دن باقی',
      one: '1 دن باقی',
      zero: 'آخری دن',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ہفتے کا بہترین · $score';
  }

  @override
  String get achievements => 'کامیابیاں';

  @override
  String get challenges => 'چیلنجز';

  @override
  String get share => 'شیئر کریں';

  @override
  String shareText(int score, String link) {
    return 'Puff میں میرا نیا بہترین سکور: $score۔ کیا آپ ہرا سکتے ہیں؟ $link';
  }

  @override
  String get reducedFlashes => 'کم چمک';

  @override
  String get paletteHoliday => 'تہوار';
}
