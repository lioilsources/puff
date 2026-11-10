// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get tagline => 'החזק · גרור · שחרר';

  @override
  String get play => 'שחק';

  @override
  String bestScore(int score) {
    return 'שיא · $score';
  }

  @override
  String get environmentTitle => 'סביבה';

  @override
  String get modifierTitle => 'משנה';

  @override
  String get paletteTitle => 'פלטה';

  @override
  String get leaderboard => 'טבלת מובילים';

  @override
  String get settings => 'הגדרות';

  @override
  String get paused => 'מושהה';

  @override
  String get resume => 'המשך';

  @override
  String get restart => 'התחל מחדש';

  @override
  String get nextTrack => '♪ הרצועה הבאה';

  @override
  String get menu => 'תפריט';

  @override
  String get gameOver => 'המשחק נגמר';

  @override
  String get newBest => 'שיא חדש';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'קומבו x$combo   הוזזו $displaced   נשברו $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds שנ׳';
  }

  @override
  String get again => 'שוב';

  @override
  String get quality => 'איכות';

  @override
  String get qualityLow => 'נמוכה';

  @override
  String get qualityMed => 'בינונית';

  @override
  String get qualityHigh => 'גבוהה';

  @override
  String get haptics => 'רטט';

  @override
  String get sound => 'צליל';

  @override
  String get music => 'מוזיקה';

  @override
  String get debugOverlay => 'שכבת דיבוג';

  @override
  String get back => 'חזרה';

  @override
  String get on => 'פועל';

  @override
  String get off => 'כבוי';

  @override
  String get envVacuum => 'ואקום';

  @override
  String get envAir => 'אוויר';

  @override
  String get envWater => 'מים';

  @override
  String get envPlasma => 'פלזמה';

  @override
  String get modPressure => 'לחץ';

  @override
  String get modImplosion => 'התפרצות פנימה';

  @override
  String get modMagnet => 'מגנט';

  @override
  String get modGravityWell => 'בור כבידה';

  @override
  String get modChainSpark => 'ניצוץ שרשרת';

  @override
  String get paletteCyberpunk => 'סייברפאנק';

  @override
  String get paletteVaporwave => 'ויפורוויב';

  @override
  String get paletteAcid => 'חומצה';

  @override
  String get paletteMono => 'מונו';

  @override
  String get paletteEmber => 'גחל';

  @override
  String get paletteArctic => 'ארקטי';

  @override
  String get heatTier1 => 'חום I';

  @override
  String get heatTier2 => 'חום II';

  @override
  String get heatTier3 => 'חום III';

  @override
  String get heatTierOverdrive => 'אוברדרייב';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  קומבו $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  נמלטו $escaped/$max';
  }

  @override
  String get weekly => 'אתגר שבועי';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'נותרו $days ימים',
      two: 'נותרו יומיים',
      one: 'נותר יום אחד',
      zero: 'היום האחרון',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'שיא השבוע · $score';
  }

  @override
  String get achievements => 'הישגים';

  @override
  String get challenges => 'אתגרים';

  @override
  String get share => 'שיתוף';

  @override
  String shareText(int score, String link) {
    return 'השיא החדש שלי ב-Puff: $score. תצליחו לעקוף? $link';
  }

  @override
  String get reducedFlashes => 'פחות הבזקים';

  @override
  String get paletteHoliday => 'חג';
}
