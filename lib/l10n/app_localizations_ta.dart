// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get tagline => 'பிடி · இழு · விடு';

  @override
  String get play => 'விளையாடு';

  @override
  String bestScore(int score) {
    return 'சிறந்தது · $score';
  }

  @override
  String get environmentTitle => 'சூழல்';

  @override
  String get modifierTitle => 'மாற்றி';

  @override
  String get paletteTitle => 'வண்ணத் தட்டு';

  @override
  String get leaderboard => 'முன்னணிப் பட்டியல்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get paused => 'இடைநிறுத்தம்';

  @override
  String get resume => 'தொடர்';

  @override
  String get restart => 'மீண்டும் தொடங்கு';

  @override
  String get nextTrack => '♪ அடுத்த பாடல்';

  @override
  String get menu => 'பட்டி';

  @override
  String get gameOver => 'ஆட்டம் முடிந்தது';

  @override
  String get newBest => 'புதிய சிறந்தது';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'காம்போ x$combo   நகர்ந்தவை $displaced   உடைந்தவை $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds வி';
  }

  @override
  String get again => 'மீண்டும்';

  @override
  String get quality => 'தரம்';

  @override
  String get qualityLow => 'குறைவு';

  @override
  String get qualityMed => 'நடுத்தரம்';

  @override
  String get qualityHigh => 'உயர்வு';

  @override
  String get haptics => 'அதிர்வு';

  @override
  String get sound => 'ஒலி';

  @override
  String get music => 'இசை';

  @override
  String get debugOverlay => 'பிழைத்திருத்த மேலடுக்கு';

  @override
  String get back => 'பின்';

  @override
  String get on => 'இயக்கம்';

  @override
  String get off => 'நிறுத்தம்';

  @override
  String get envVacuum => 'வெற்றிடம்';

  @override
  String get envAir => 'காற்று';

  @override
  String get envWater => 'நீர்';

  @override
  String get envPlasma => 'பிளாஸ்மா';

  @override
  String get modPressure => 'அழுத்தம்';

  @override
  String get modImplosion => 'உள்வெடிப்பு';

  @override
  String get modMagnet => 'காந்தம்';

  @override
  String get modGravityWell => 'ஈர்ப்புக் கிணறு';

  @override
  String get modChainSpark => 'சங்கிலிப் பொறி';

  @override
  String get paletteCyberpunk => 'சைபர்பங்க்';

  @override
  String get paletteVaporwave => 'வேப்பர்வேவ்';

  @override
  String get paletteAcid => 'அமிலம்';

  @override
  String get paletteMono => 'மோனோ';

  @override
  String get paletteEmber => 'தணல்';

  @override
  String get paletteArctic => 'ஆர்க்டிக்';

  @override
  String get heatTier1 => 'வெப்பம் I';

  @override
  String get heatTier2 => 'வெப்பம் II';

  @override
  String get heatTier3 => 'வெப்பம் III';

  @override
  String get heatTierOverdrive => 'ஓவர்டிரைவ்';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  காம்போ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  தப்பியவை $escaped/$max';
  }

  @override
  String get weekly => 'வாராந்திரச் சவால்';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days நாள் மீதம்',
      one: '1 நாள் மீதம்',
      zero: 'கடைசி நாள்',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'வாரத்தின் சிறந்தது · $score';
  }

  @override
  String get achievements => 'சாதனைகள்';

  @override
  String get challenges => 'சவால்கள்';

  @override
  String get share => 'பகிர்';

  @override
  String shareText(int score, String link) {
    return 'Puff-ல் என் புதிய சிறந்த மதிப்பெண்: $score. முறியடிக்க முடியுமா? $link';
  }

  @override
  String get reducedFlashes => 'குறைந்த மின்னல்';

  @override
  String get paletteHoliday => 'விழாக்காலம்';
}
