// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get tagline => 'धरा · ओढा · सोडा';

  @override
  String get play => 'खेळा';

  @override
  String bestScore(int score) {
    return 'सर्वोत्तम · $score';
  }

  @override
  String get environmentTitle => 'वातावरण';

  @override
  String get modifierTitle => 'मॉडिफायर';

  @override
  String get paletteTitle => 'पॅलेट';

  @override
  String get leaderboard => 'लीडरबोर्ड';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get paused => 'थांबवले';

  @override
  String get resume => 'पुढे चला';

  @override
  String get restart => 'पुन्हा सुरू करा';

  @override
  String get nextTrack => '♪ पुढचे गाणे';

  @override
  String get menu => 'मेनू';

  @override
  String get gameOver => 'खेळ संपला';

  @override
  String get newBest => 'नवा सर्वोत्तम';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'कॉम्बो x$combo   सरकवले $displaced   फुटले $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds से';
  }

  @override
  String get again => 'पुन्हा';

  @override
  String get quality => 'गुणवत्ता';

  @override
  String get qualityLow => 'कमी';

  @override
  String get qualityMed => 'मध्यम';

  @override
  String get qualityHigh => 'उच्च';

  @override
  String get haptics => 'कंपन';

  @override
  String get sound => 'आवाज';

  @override
  String get music => 'संगीत';

  @override
  String get debugOverlay => 'डीबग ओव्हरले';

  @override
  String get back => 'मागे';

  @override
  String get on => 'चालू';

  @override
  String get off => 'बंद';

  @override
  String get envVacuum => 'निर्वात';

  @override
  String get envAir => 'हवा';

  @override
  String get envWater => 'पाणी';

  @override
  String get envPlasma => 'प्लाझ्मा';

  @override
  String get modPressure => 'दाब';

  @override
  String get modImplosion => 'अंतःस्फोट';

  @override
  String get modMagnet => 'चुंबक';

  @override
  String get modGravityWell => 'गुरुत्वाकर्षण विहीर';

  @override
  String get modChainSpark => 'साखळी ठिणगी';

  @override
  String get paletteCyberpunk => 'सायबरपंक';

  @override
  String get paletteVaporwave => 'वेपरवेव्ह';

  @override
  String get paletteAcid => 'अ‍ॅसिड';

  @override
  String get paletteMono => 'मोनो';

  @override
  String get paletteEmber => 'निखारा';

  @override
  String get paletteArctic => 'आर्क्टिक';

  @override
  String get heatTier1 => 'उष्णता I';

  @override
  String get heatTier2 => 'उष्णता II';

  @override
  String get heatTier3 => 'उष्णता III';

  @override
  String get heatTierOverdrive => 'ओव्हरड्राइव्ह';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  कॉम्बो $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  निसटले $escaped/$max';
  }

  @override
  String get weekly => 'साप्ताहिक आव्हान';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days दिवस बाकी',
      one: '1 दिवस बाकी',
      zero: 'शेवटचा दिवस',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'आठवड्याचा सर्वोत्तम · $score';
  }

  @override
  String get achievements => 'उपलब्धी';

  @override
  String get challenges => 'आव्हाने';

  @override
  String get share => 'शेअर करा';

  @override
  String shareText(int score, String link) {
    return 'Puff मध्ये माझा नवा सर्वोत्तम स्कोर: $score. तुम्ही हरवू शकता का? $link';
  }

  @override
  String get reducedFlashes => 'कमी लखलखाट';

  @override
  String get paletteHoliday => 'सणासुदीचा';
}
