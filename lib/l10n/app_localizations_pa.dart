// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class AppLocalizationsPa extends AppLocalizations {
  AppLocalizationsPa([String locale = 'pa']) : super(locale);

  @override
  String get tagline => 'ਫੜੋ · ਖਿੱਚੋ · ਛੱਡੋ';

  @override
  String get play => 'ਖੇਡੋ';

  @override
  String bestScore(int score) {
    return 'ਸਭ ਤੋਂ ਵਧੀਆ · $score';
  }

  @override
  String get environmentTitle => 'ਮਾਹੌਲ';

  @override
  String get modifierTitle => 'ਮੋਡੀਫਾਇਰ';

  @override
  String get paletteTitle => 'ਪੈਲੇਟ';

  @override
  String get leaderboard => 'ਲੀਡਰਬੋਰਡ';

  @override
  String get settings => 'ਸੈਟਿੰਗਾਂ';

  @override
  String get paused => 'ਰੁਕਿਆ';

  @override
  String get resume => 'ਜਾਰੀ ਰੱਖੋ';

  @override
  String get restart => 'ਮੁੜ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String get nextTrack => '♪ ਅਗਲਾ ਗਾਣਾ';

  @override
  String get menu => 'ਮੀਨੂ';

  @override
  String get gameOver => 'ਖੇਡ ਖ਼ਤਮ';

  @override
  String get newBest => 'ਨਵਾਂ ਸਭ ਤੋਂ ਵਧੀਆ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'ਕੌਂਬੋ x$combo   ਖਿਸਕੇ $displaced   ਟੁੱਟੇ $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds ਸਕਿੰ';
  }

  @override
  String get again => 'ਫਿਰ ਤੋਂ';

  @override
  String get quality => 'ਗੁਣਵੱਤਾ';

  @override
  String get qualityLow => 'ਘੱਟ';

  @override
  String get qualityMed => 'ਦਰਮਿਆਨੀ';

  @override
  String get qualityHigh => 'ਉੱਚੀ';

  @override
  String get haptics => 'ਕੰਪਨ';

  @override
  String get sound => 'ਆਵਾਜ਼';

  @override
  String get music => 'ਸੰਗੀਤ';

  @override
  String get debugOverlay => 'ਡੀਬੱਗ ਓਵਰਲੇ';

  @override
  String get back => 'ਪਿੱਛੇ';

  @override
  String get on => 'ਚਾਲੂ';

  @override
  String get off => 'ਬੰਦ';

  @override
  String get envVacuum => 'ਖਲਾਅ';

  @override
  String get envAir => 'ਹਵਾ';

  @override
  String get envWater => 'ਪਾਣੀ';

  @override
  String get envPlasma => 'ਪਲਾਜ਼ਮਾ';

  @override
  String get modPressure => 'ਦਬਾਅ';

  @override
  String get modImplosion => 'ਅੰਦਰੂਨੀ ਧਮਾਕਾ';

  @override
  String get modMagnet => 'ਚੁੰਬਕ';

  @override
  String get modGravityWell => 'ਗੁਰੂਤਾ ਖੂਹ';

  @override
  String get modChainSpark => 'ਲੜੀਵਾਰ ਚੰਗਿਆੜੀ';

  @override
  String get paletteCyberpunk => 'ਸਾਈਬਰਪੰਕ';

  @override
  String get paletteVaporwave => 'ਵੇਪਰਵੇਵ';

  @override
  String get paletteAcid => 'ਤੇਜ਼ਾਬ';

  @override
  String get paletteMono => 'ਮੋਨੋ';

  @override
  String get paletteEmber => 'ਅੰਗਾਰਾ';

  @override
  String get paletteArctic => 'ਆਰਕਟਿਕ';

  @override
  String get heatTier1 => 'ਤਾਪ I';

  @override
  String get heatTier2 => 'ਤਾਪ II';

  @override
  String get heatTier3 => 'ਤਾਪ III';

  @override
  String get heatTierOverdrive => 'ਓਵਰਡ੍ਰਾਈਵ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  ਕੌਂਬੋ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  ਬਚ ਨਿਕਲੇ $escaped/$max';
  }

  @override
  String get weekly => 'ਹਫ਼ਤਾਵਾਰੀ ਚੁਣੌਤੀ';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ਦਿਨ ਬਾਕੀ',
      one: '1 ਦਿਨ ਬਾਕੀ',
      zero: 'ਆਖ਼ਰੀ ਦਿਨ',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ਹਫ਼ਤੇ ਦਾ ਸਭ ਤੋਂ ਵਧੀਆ · $score';
  }

  @override
  String get achievements => 'ਪ੍ਰਾਪਤੀਆਂ';

  @override
  String get challenges => 'ਚੁਣੌਤੀਆਂ';

  @override
  String get share => 'ਸਾਂਝਾ ਕਰੋ';

  @override
  String shareText(int score, String link) {
    return 'Puff ਵਿੱਚ ਮੇਰਾ ਨਵਾਂ ਸਭ ਤੋਂ ਵਧੀਆ ਸਕੋਰ: $score। ਕੀ ਤੁਸੀਂ ਹਰਾ ਸਕਦੇ ਹੋ? $link';
  }

  @override
  String get reducedFlashes => 'ਘੱਟ ਚਮਕ';

  @override
  String get paletteHoliday => 'ਤਿਉਹਾਰ';
}
