// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get tagline => 'പിടിക്കൂ · വലിക്കൂ · വിടൂ';

  @override
  String get play => 'കളിക്കൂ';

  @override
  String bestScore(int score) {
    return 'മികച്ചത് · $score';
  }

  @override
  String get environmentTitle => 'പരിസ്ഥിതി';

  @override
  String get modifierTitle => 'മോഡിഫയർ';

  @override
  String get paletteTitle => 'പാലറ്റ്';

  @override
  String get leaderboard => 'ലീഡർബോർഡ്';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get paused => 'താൽക്കാലികമായി നിർത്തി';

  @override
  String get resume => 'തുടരുക';

  @override
  String get restart => 'വീണ്ടും തുടങ്ങുക';

  @override
  String get nextTrack => '♪ അടുത്ത ഗാനം';

  @override
  String get menu => 'മെനു';

  @override
  String get gameOver => 'കളി കഴിഞ്ഞു';

  @override
  String get newBest => 'പുതിയ മികച്ച സ്കോർ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'കോംബോ x$combo   നീങ്ങിയത് $displaced   പൊട്ടിയത് $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds സെ';
  }

  @override
  String get again => 'വീണ്ടും';

  @override
  String get quality => 'ഗുണനിലവാരം';

  @override
  String get qualityLow => 'കുറവ്';

  @override
  String get qualityMed => 'ഇടത്തരം';

  @override
  String get qualityHigh => 'ഉയർന്നത്';

  @override
  String get haptics => 'വൈബ്രേഷൻ';

  @override
  String get sound => 'ശബ്ദം';

  @override
  String get music => 'സംഗീതം';

  @override
  String get debugOverlay => 'ഡീബഗ് ഓവർലേ';

  @override
  String get back => 'പിന്നോട്ട്';

  @override
  String get on => 'ഓൺ';

  @override
  String get off => 'ഓഫ്';

  @override
  String get envVacuum => 'ശൂന്യത';

  @override
  String get envAir => 'വായു';

  @override
  String get envWater => 'ജലം';

  @override
  String get envPlasma => 'പ്ലാസ്മ';

  @override
  String get modPressure => 'മർദ്ദം';

  @override
  String get modImplosion => 'അന്തർസ്ഫോടനം';

  @override
  String get modMagnet => 'കാന്തം';

  @override
  String get modGravityWell => 'ഗുരുത്വ കിണർ';

  @override
  String get modChainSpark => 'ശൃംഖലാ തീപ്പൊരി';

  @override
  String get paletteCyberpunk => 'സൈബർപങ്ക്';

  @override
  String get paletteVaporwave => 'വേപ്പർവേവ്';

  @override
  String get paletteAcid => 'ആസിഡ്';

  @override
  String get paletteMono => 'മോണോ';

  @override
  String get paletteEmber => 'കനൽ';

  @override
  String get paletteArctic => 'ആർട്ടിക്';

  @override
  String get heatTier1 => 'ചൂട് I';

  @override
  String get heatTier2 => 'ചൂട് II';

  @override
  String get heatTier3 => 'ചൂട് III';

  @override
  String get heatTierOverdrive => 'ഓവർഡ്രൈവ്';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  കോംബോ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  രക്ഷപ്പെട്ടത് $escaped/$max';
  }

  @override
  String get weekly => 'പ്രതിവാര വെല്ലുവിളി';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ദിവസം ബാക്കി',
      one: '1 ദിവസം ബാക്കി',
      zero: 'അവസാന ദിവസം',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ആഴ്ചയിലെ മികച്ചത് · $score';
  }

  @override
  String get achievements => 'നേട്ടങ്ങൾ';

  @override
  String get challenges => 'വെല്ലുവിളികൾ';

  @override
  String get share => 'പങ്കിടുക';

  @override
  String shareText(int score, String link) {
    return 'Puff-ൽ എന്റെ പുതിയ മികച്ച സ്കോർ: $score. തോൽപ്പിക്കാനാകുമോ? $link';
  }

  @override
  String get reducedFlashes => 'കുറഞ്ഞ മിന്നൽ';

  @override
  String get paletteHoliday => 'ഉത്സവം';
}
