// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get tagline => 'પકડો · ખેંચો · છોડો';

  @override
  String get play => 'રમો';

  @override
  String bestScore(int score) {
    return 'શ્રેષ્ઠ · $score';
  }

  @override
  String get environmentTitle => 'પર્યાવરણ';

  @override
  String get modifierTitle => 'મોડિફાયર';

  @override
  String get paletteTitle => 'પેલેટ';

  @override
  String get leaderboard => 'લીડરબોર્ડ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get paused => 'થોભાવ્યું';

  @override
  String get resume => 'ચાલુ રાખો';

  @override
  String get restart => 'ફરી શરૂ કરો';

  @override
  String get nextTrack => '♪ આગલું ગીત';

  @override
  String get menu => 'મેનૂ';

  @override
  String get gameOver => 'રમત પૂરી';

  @override
  String get newBest => 'નવો શ્રેષ્ઠ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'કૉમ્બો x$combo   ખસેડ્યા $displaced   તૂટ્યા $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds સે';
  }

  @override
  String get again => 'ફરી';

  @override
  String get quality => 'ગુણવત્તા';

  @override
  String get qualityLow => 'નીચી';

  @override
  String get qualityMed => 'મધ્યમ';

  @override
  String get qualityHigh => 'ઊંચી';

  @override
  String get haptics => 'કંપન';

  @override
  String get sound => 'અવાજ';

  @override
  String get music => 'સંગીત';

  @override
  String get debugOverlay => 'ડિબગ ઓવરલે';

  @override
  String get back => 'પાછા';

  @override
  String get on => 'ચાલુ';

  @override
  String get off => 'બંધ';

  @override
  String get envVacuum => 'શૂન્યાવકાશ';

  @override
  String get envAir => 'હવા';

  @override
  String get envWater => 'પાણી';

  @override
  String get envPlasma => 'પ્લાઝ્મા';

  @override
  String get modPressure => 'દબાણ';

  @override
  String get modImplosion => 'અંતર્વિસ્ફોટ';

  @override
  String get modMagnet => 'ચુંબક';

  @override
  String get modGravityWell => 'ગુરુત્વ કૂવો';

  @override
  String get modChainSpark => 'સાંકળ તણખો';

  @override
  String get paletteCyberpunk => 'સાયબરપંક';

  @override
  String get paletteVaporwave => 'વેપરવેવ';

  @override
  String get paletteAcid => 'ઍસિડ';

  @override
  String get paletteMono => 'મોનો';

  @override
  String get paletteEmber => 'અંગારો';

  @override
  String get paletteArctic => 'આર્કટિક';

  @override
  String get heatTier1 => 'ગરમી I';

  @override
  String get heatTier2 => 'ગરમી II';

  @override
  String get heatTier3 => 'ગરમી III';

  @override
  String get heatTierOverdrive => 'ઓવરડ્રાઇવ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  કૉમ્બો $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  છટકી ગયા $escaped/$max';
  }

  @override
  String get weekly => 'સાપ્તાહિક પડકાર';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days દિવસ બાકી',
      one: '1 દિવસ બાકી',
      zero: 'છેલ્લો દિવસ',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'અઠવાડિયાનો શ્રેષ્ઠ · $score';
  }

  @override
  String get achievements => 'સિદ્ધિઓ';

  @override
  String get challenges => 'પડકારો';

  @override
  String get share => 'શેર કરો';

  @override
  String shareText(int score, String link) {
    return 'Puff માં મારો નવો શ્રેષ્ઠ સ્કોર: $score. તમે હરાવી શકો? $link';
  }

  @override
  String get reducedFlashes => 'ઓછી ઝળહળાટ';

  @override
  String get paletteHoliday => 'તહેવાર';
}
