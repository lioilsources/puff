// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class AppLocalizationsOr extends AppLocalizations {
  AppLocalizationsOr([String locale = 'or']) : super(locale);

  @override
  String get tagline => 'ଧରନ୍ତୁ · ଟାଣନ୍ତୁ · ଛାଡ଼ନ୍ତୁ';

  @override
  String get play => 'ଖେଳନ୍ତୁ';

  @override
  String bestScore(int score) {
    return 'ସର୍ବୋତ୍ତମ · $score';
  }

  @override
  String get environmentTitle => 'ପରିବେଶ';

  @override
  String get modifierTitle => 'ମଡିଫାୟର୍';

  @override
  String get paletteTitle => 'ପ୍ୟାଲେଟ୍';

  @override
  String get leaderboard => 'ଲିଡରବୋର୍ଡ';

  @override
  String get settings => 'ସେଟିଂସ୍';

  @override
  String get paused => 'ବିରତି';

  @override
  String get resume => 'ଜାରି ରଖନ୍ତୁ';

  @override
  String get restart => 'ପୁଣି ଆରମ୍ଭ';

  @override
  String get nextTrack => '♪ ପରବର୍ତ୍ତୀ ଗୀତ';

  @override
  String get menu => 'ମେନୁ';

  @override
  String get gameOver => 'ଖେଳ ଶେଷ';

  @override
  String get newBest => 'ନୂଆ ସର୍ବୋତ୍ତମ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'କମ୍ବୋ x$combo   ହଟିଲା $displaced   ଭାଙ୍ଗିଲା $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds ସେ';
  }

  @override
  String get again => 'ପୁଣି';

  @override
  String get quality => 'ଗୁଣବତ୍ତା';

  @override
  String get qualityLow => 'କମ୍';

  @override
  String get qualityMed => 'ମଧ୍ୟମ';

  @override
  String get qualityHigh => 'ଉଚ୍ଚ';

  @override
  String get haptics => 'କମ୍ପନ';

  @override
  String get sound => 'ଧ୍ୱନି';

  @override
  String get music => 'ସଂଗୀତ';

  @override
  String get debugOverlay => 'ଡିବଗ୍ ଓଭରଲେ';

  @override
  String get back => 'ପଛକୁ';

  @override
  String get on => 'ଚାଲୁ';

  @override
  String get off => 'ବନ୍ଦ';

  @override
  String get envVacuum => 'ଶୂନ୍ୟସ୍ଥାନ';

  @override
  String get envAir => 'ବାୟୁ';

  @override
  String get envWater => 'ଜଳ';

  @override
  String get envPlasma => 'ପ୍ଲାଜ୍ମା';

  @override
  String get modPressure => 'ଚାପ';

  @override
  String get modImplosion => 'ଅନ୍ତର୍ବିସ୍ଫୋରଣ';

  @override
  String get modMagnet => 'ଚୁମ୍ବକ';

  @override
  String get modGravityWell => 'ମହାକର୍ଷ କୂଅ';

  @override
  String get modChainSpark => 'ଶୃଙ୍ଖଳା ସ୍ଫୁଲିଙ୍ଗ';

  @override
  String get paletteCyberpunk => 'ସାଇବରପଙ୍କ୍';

  @override
  String get paletteVaporwave => 'ଭେପରୱେଭ୍';

  @override
  String get paletteAcid => 'ଏସିଡ୍';

  @override
  String get paletteMono => 'ମୋନୋ';

  @override
  String get paletteEmber => 'ଅଙ୍ଗାର';

  @override
  String get paletteArctic => 'ଆର୍କଟିକ୍';

  @override
  String get heatTier1 => 'ଉତ୍ତାପ I';

  @override
  String get heatTier2 => 'ଉତ୍ତାପ II';

  @override
  String get heatTier3 => 'ଉତ୍ତାପ III';

  @override
  String get heatTierOverdrive => 'ଓଭରଡ୍ରାଇଭ୍';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  କମ୍ବୋ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  ବଞ୍ଚିଗଲା $escaped/$max';
  }

  @override
  String get weekly => 'ସାପ୍ତାହିକ ଚ୍ୟାଲେଞ୍ଜ';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ଦିନ ବାକି',
      one: '୧ ଦିନ ବାକି',
      zero: 'ଶେଷ ଦିନ',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ସପ୍ତାହର ସର୍ବୋତ୍ତମ · $score';
  }

  @override
  String get achievements => 'ସଫଳତା';

  @override
  String get challenges => 'ଚ୍ୟାଲେଞ୍ଜ';

  @override
  String get share => 'ସେୟାର୍';

  @override
  String shareText(int score, String link) {
    return 'Puff ରେ ମୋର ନୂଆ ସର୍ବୋତ୍ତମ ସ୍କୋର: $score। ଆପଣ ହରାଇପାରିବେ? $link';
  }

  @override
  String get reducedFlashes => 'କମ୍ ଝଲକ';

  @override
  String get paletteHoliday => 'ଉତ୍ସବ';
}
