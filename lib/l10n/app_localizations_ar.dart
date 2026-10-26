// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get tagline => 'اضغط · اسحب · أفلت';

  @override
  String get play => 'العب';

  @override
  String bestScore(int score) {
    return 'الأفضل · $score';
  }

  @override
  String get environmentTitle => 'البيئة';

  @override
  String get modifierTitle => 'المُعدِّل';

  @override
  String get paletteTitle => 'الألوان';

  @override
  String get leaderboard => 'لوحة الصدارة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get paused => 'متوقف مؤقتًا';

  @override
  String get resume => 'استئناف';

  @override
  String get restart => 'إعادة البدء';

  @override
  String get nextTrack => '♪ المقطع التالي';

  @override
  String get menu => 'القائمة';

  @override
  String get gameOver => 'انتهت اللعبة';

  @override
  String get newBest => 'رقم قياسي جديد';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'كومبو x$combo   أُزيح $displaced   كُسر $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds ث';
  }

  @override
  String get again => 'مرة أخرى';

  @override
  String get quality => 'الجودة';

  @override
  String get qualityLow => 'منخفضة';

  @override
  String get qualityMed => 'متوسطة';

  @override
  String get qualityHigh => 'عالية';

  @override
  String get haptics => 'الاهتزاز';

  @override
  String get sound => 'الصوت';

  @override
  String get music => 'الموسيقى';

  @override
  String get debugOverlay => 'معلومات التصحيح';

  @override
  String get back => 'رجوع';

  @override
  String get on => 'تشغيل';

  @override
  String get off => 'إيقاف';

  @override
  String get envVacuum => 'فراغ';

  @override
  String get envAir => 'هواء';

  @override
  String get envWater => 'ماء';

  @override
  String get envPlasma => 'بلازما';

  @override
  String get modPressure => 'ضغط';

  @override
  String get modImplosion => 'انفجار داخلي';

  @override
  String get modMagnet => 'مغناطيس';

  @override
  String get modGravityWell => 'بئر جاذبية';

  @override
  String get modChainSpark => 'شرارة متسلسلة';

  @override
  String get paletteCyberpunk => 'سايبربانك';

  @override
  String get paletteVaporwave => 'فيبورويف';

  @override
  String get paletteAcid => 'حمضي';

  @override
  String get paletteMono => 'أحادي';

  @override
  String get paletteEmber => 'جمر';

  @override
  String get paletteArctic => 'قطبي';

  @override
  String get heatTier1 => 'حرارة I';

  @override
  String get heatTier2 => 'حرارة II';

  @override
  String get heatTier3 => 'حرارة III';

  @override
  String get heatTierOverdrive => 'حمل زائد';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  كومبو $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  هرب $escaped/$max';
  }
}
