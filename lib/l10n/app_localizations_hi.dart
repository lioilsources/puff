// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get tagline => 'पकड़ो · खींचो · छोड़ो';

  @override
  String get play => 'खेलें';

  @override
  String bestScore(int score) {
    return 'सर्वश्रेष्ठ · $score';
  }

  @override
  String get environmentTitle => 'परिवेश';

  @override
  String get modifierTitle => 'मॉडिफ़ायर';

  @override
  String get paletteTitle => 'पैलेट';

  @override
  String get leaderboard => 'लीडरबोर्ड';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get paused => 'रुका हुआ';

  @override
  String get resume => 'जारी रखें';

  @override
  String get restart => 'फिर शुरू करें';

  @override
  String get nextTrack => '♪ अगला गाना';

  @override
  String get menu => 'मेन्यू';

  @override
  String get gameOver => 'खेल ख़त्म';

  @override
  String get newBest => 'नया सर्वश्रेष्ठ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'कॉम्बो x$combo   हटाए $displaced   टूटे $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds से';
  }

  @override
  String get again => 'फिर से';

  @override
  String get quality => 'गुणवत्ता';

  @override
  String get qualityLow => 'कम';

  @override
  String get qualityMed => 'मध्यम';

  @override
  String get qualityHigh => 'उच्च';

  @override
  String get haptics => 'कंपन';

  @override
  String get sound => 'आवाज़';

  @override
  String get music => 'संगीत';

  @override
  String get debugOverlay => 'डीबग ओवरले';

  @override
  String get back => 'वापस';

  @override
  String get on => 'चालू';

  @override
  String get off => 'बंद';

  @override
  String get envVacuum => 'निर्वात';

  @override
  String get envAir => 'हवा';

  @override
  String get envWater => 'पानी';

  @override
  String get envPlasma => 'प्लाज़्मा';

  @override
  String get modPressure => 'दबाव';

  @override
  String get modImplosion => 'अंतर्विस्फोट';

  @override
  String get modMagnet => 'चुंबक';

  @override
  String get modGravityWell => 'गुरुत्व कुआँ';

  @override
  String get modChainSpark => 'श्रृंखला चिंगारी';

  @override
  String get paletteCyberpunk => 'साइबरपंक';

  @override
  String get paletteVaporwave => 'वेपरवेव';

  @override
  String get paletteAcid => 'एसिड';

  @override
  String get paletteMono => 'मोनो';

  @override
  String get paletteEmber => 'अंगारा';

  @override
  String get paletteArctic => 'आर्कटिक';

  @override
  String get heatTier1 => 'ताप I';

  @override
  String get heatTier2 => 'ताप II';

  @override
  String get heatTier3 => 'ताप III';

  @override
  String get heatTierOverdrive => 'ओवरड्राइव';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  कॉम्बो $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  बचकर निकले $escaped/$max';
  }

  @override
  String get weekly => 'साप्ताहिक चुनौती';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिन बाकी',
      one: '1 दिन बाकी',
      zero: 'आख़िरी दिन',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'सप्ताह का सर्वश्रेष्ठ · $score';
  }

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String get challenges => 'चुनौतियाँ';

  @override
  String get share => 'शेयर करें';

  @override
  String shareText(int score, String link) {
    return 'Puff में मेरा नया सर्वश्रेष्ठ स्कोर: $score। क्या आप हरा सकते हैं? $link';
  }

  @override
  String get reducedFlashes => 'कम चमक';

  @override
  String get paletteHoliday => 'त्योहार';
}
