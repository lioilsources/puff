// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get tagline => 'ধরুন · টানুন · ছাড়ুন';

  @override
  String get play => 'খেলুন';

  @override
  String bestScore(int score) {
    return 'সেরা · $score';
  }

  @override
  String get environmentTitle => 'পরিবেশ';

  @override
  String get modifierTitle => 'মডিফায়ার';

  @override
  String get paletteTitle => 'রঙের প্যালেট';

  @override
  String get leaderboard => 'লিডারবোর্ড';

  @override
  String get settings => 'সেটিংস';

  @override
  String get paused => 'বিরতি';

  @override
  String get resume => 'চালিয়ে যান';

  @override
  String get restart => 'আবার শুরু';

  @override
  String get nextTrack => '♪ পরের গান';

  @override
  String get menu => 'মেনু';

  @override
  String get gameOver => 'খেলা শেষ';

  @override
  String get newBest => 'নতুন সেরা';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'কম্বো x$combo   সরেছে $displaced   ভেঙেছে $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds সে';
  }

  @override
  String get again => 'আবার';

  @override
  String get quality => 'মান';

  @override
  String get qualityLow => 'কম';

  @override
  String get qualityMed => 'মাঝারি';

  @override
  String get qualityHigh => 'বেশি';

  @override
  String get haptics => 'কম্পন';

  @override
  String get sound => 'শব্দ';

  @override
  String get music => 'সংগীত';

  @override
  String get debugOverlay => 'ডিবাগ ওভারলে';

  @override
  String get back => 'পিছনে';

  @override
  String get on => 'চালু';

  @override
  String get off => 'বন্ধ';

  @override
  String get envVacuum => 'শূন্যস্থান';

  @override
  String get envAir => 'বায়ু';

  @override
  String get envWater => 'জল';

  @override
  String get envPlasma => 'প্লাজমা';

  @override
  String get modPressure => 'চাপ';

  @override
  String get modImplosion => 'অন্তর্বিস্ফোরণ';

  @override
  String get modMagnet => 'চুম্বক';

  @override
  String get modGravityWell => 'মহাকর্ষ কূপ';

  @override
  String get modChainSpark => 'শৃঙ্খল স্ফুলিঙ্গ';

  @override
  String get paletteCyberpunk => 'সাইবারপাঙ্ক';

  @override
  String get paletteVaporwave => 'ভেপারওয়েভ';

  @override
  String get paletteAcid => 'অ্যাসিড';

  @override
  String get paletteMono => 'মনো';

  @override
  String get paletteEmber => 'অঙ্গার';

  @override
  String get paletteArctic => 'আর্কটিক';

  @override
  String get heatTier1 => 'উত্তাপ I';

  @override
  String get heatTier2 => 'উত্তাপ II';

  @override
  String get heatTier3 => 'উত্তাপ III';

  @override
  String get heatTierOverdrive => 'ওভারড্রাইভ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  কম্বো $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  পালিয়েছে $escaped/$max';
  }

  @override
  String get weekly => 'সাপ্তাহিক চ্যালেঞ্জ';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'আর $days দিন',
      one: 'আর ১ দিন',
      zero: 'শেষ দিন',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'সপ্তাহের সেরা · $score';
  }

  @override
  String get achievements => 'অর্জন';

  @override
  String get challenges => 'চ্যালেঞ্জ';

  @override
  String get share => 'শেয়ার';

  @override
  String shareText(int score, String link) {
    return 'Puff-এ আমার নতুন সেরা: $score। পারবেন হারাতে? $link';
  }

  @override
  String get reducedFlashes => 'কম ঝলকানি';

  @override
  String get paletteHoliday => 'উৎসব';
}
