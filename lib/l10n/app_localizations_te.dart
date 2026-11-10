// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get tagline => 'పట్టు · లాగు · వదులు';

  @override
  String get play => 'ఆడండి';

  @override
  String bestScore(int score) {
    return 'ఉత్తమం · $score';
  }

  @override
  String get environmentTitle => 'పరిసరం';

  @override
  String get modifierTitle => 'మాడిఫైయర్';

  @override
  String get paletteTitle => 'పాలెట్';

  @override
  String get leaderboard => 'లీడర్‌బోర్డ్';

  @override
  String get settings => 'సెట్టింగ్స్';

  @override
  String get paused => 'విరామం';

  @override
  String get resume => 'కొనసాగించు';

  @override
  String get restart => 'మళ్లీ ప్రారంభించు';

  @override
  String get nextTrack => '♪ తదుపరి పాట';

  @override
  String get menu => 'మెనూ';

  @override
  String get gameOver => 'ఆట ముగిసింది';

  @override
  String get newBest => 'కొత్త ఉత్తమం';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'కాంబో x$combo   కదిలినవి $displaced   పగిలినవి $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds సె';
  }

  @override
  String get again => 'మళ్లీ';

  @override
  String get quality => 'నాణ్యత';

  @override
  String get qualityLow => 'తక్కువ';

  @override
  String get qualityMed => 'మధ్యస్థం';

  @override
  String get qualityHigh => 'ఎక్కువ';

  @override
  String get haptics => 'కంపనం';

  @override
  String get sound => 'ధ్వని';

  @override
  String get music => 'సంగీతం';

  @override
  String get debugOverlay => 'డీబగ్ ఓవర్‌లే';

  @override
  String get back => 'వెనుకకు';

  @override
  String get on => 'ఆన్';

  @override
  String get off => 'ఆఫ్';

  @override
  String get envVacuum => 'శూన్యం';

  @override
  String get envAir => 'గాలి';

  @override
  String get envWater => 'నీరు';

  @override
  String get envPlasma => 'ప్లాస్మా';

  @override
  String get modPressure => 'పీడనం';

  @override
  String get modImplosion => 'అంతర్విస్ఫోటనం';

  @override
  String get modMagnet => 'అయస్కాంతం';

  @override
  String get modGravityWell => 'గురుత్వ బావి';

  @override
  String get modChainSpark => 'గొలుసు నిప్పురవ్వ';

  @override
  String get paletteCyberpunk => 'సైబర్‌పంక్';

  @override
  String get paletteVaporwave => 'వేపర్‌వేవ్';

  @override
  String get paletteAcid => 'ఆమ్లం';

  @override
  String get paletteMono => 'మోనో';

  @override
  String get paletteEmber => 'నిప్పు కణం';

  @override
  String get paletteArctic => 'ఆర్కిటిక్';

  @override
  String get heatTier1 => 'వేడి I';

  @override
  String get heatTier2 => 'వేడి II';

  @override
  String get heatTier3 => 'వేడి III';

  @override
  String get heatTierOverdrive => 'ఓవర్‌డ్రైవ్';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  కాంబో $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  తప్పించుకున్నవి $escaped/$max';
  }

  @override
  String get weekly => 'వారపు సవాలు';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days రోజులు మిగిలాయి',
      one: '1 రోజు మిగిలింది',
      zero: 'చివరి రోజు',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'వారపు ఉత్తమం · $score';
  }

  @override
  String get achievements => 'విజయాలు';

  @override
  String get challenges => 'సవాళ్లు';

  @override
  String get share => 'షేర్ చేయండి';

  @override
  String shareText(int score, String link) {
    return 'Puffలో నా కొత్త ఉత్తమ స్కోర్: $score. మీరు అధిగమించగలరా? $link';
  }

  @override
  String get reducedFlashes => 'తక్కువ మెరుపులు';

  @override
  String get paletteHoliday => 'పండుగ';
}
