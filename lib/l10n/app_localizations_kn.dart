// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get tagline => 'ಹಿಡಿ · ಎಳೆ · ಬಿಡು';

  @override
  String get play => 'ಆಡಿ';

  @override
  String bestScore(int score) {
    return 'ಅತ್ಯುತ್ತಮ · $score';
  }

  @override
  String get environmentTitle => 'ಪರಿಸರ';

  @override
  String get modifierTitle => 'ಮಾರ್ಪಾಡು';

  @override
  String get paletteTitle => 'ಬಣ್ಣದ ಪ್ಯಾಲೆಟ್';

  @override
  String get leaderboard => 'ಲೀಡರ್‌ಬೋರ್ಡ್';

  @override
  String get settings => 'ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get paused => 'ವಿರಾಮ';

  @override
  String get resume => 'ಮುಂದುವರಿಸಿ';

  @override
  String get restart => 'ಮತ್ತೆ ಆರಂಭಿಸಿ';

  @override
  String get nextTrack => '♪ ಮುಂದಿನ ಹಾಡು';

  @override
  String get menu => 'ಮೆನು';

  @override
  String get gameOver => 'ಆಟ ಮುಗಿಯಿತು';

  @override
  String get newBest => 'ಹೊಸ ಅತ್ಯುತ್ತಮ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'ಕಾಂಬೊ x$combo   ಸರಿದವು $displaced   ಒಡೆದವು $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds ಸೆ';
  }

  @override
  String get again => 'ಮತ್ತೆ';

  @override
  String get quality => 'ಗುಣಮಟ್ಟ';

  @override
  String get qualityLow => 'ಕಡಿಮೆ';

  @override
  String get qualityMed => 'ಮಧ್ಯಮ';

  @override
  String get qualityHigh => 'ಹೆಚ್ಚು';

  @override
  String get haptics => 'ಕಂಪನ';

  @override
  String get sound => 'ಧ್ವನಿ';

  @override
  String get music => 'ಸಂಗೀತ';

  @override
  String get debugOverlay => 'ಡೀಬಗ್ ಓವರ್‌ಲೇ';

  @override
  String get back => 'ಹಿಂದೆ';

  @override
  String get on => 'ಆನ್';

  @override
  String get off => 'ಆಫ್';

  @override
  String get envVacuum => 'ನಿರ್ವಾತ';

  @override
  String get envAir => 'ಗಾಳಿ';

  @override
  String get envWater => 'ನೀರು';

  @override
  String get envPlasma => 'ಪ್ಲಾಸ್ಮಾ';

  @override
  String get modPressure => 'ಒತ್ತಡ';

  @override
  String get modImplosion => 'ಅಂತರ್ಸ್ಫೋಟ';

  @override
  String get modMagnet => 'ಆಯಸ್ಕಾಂತ';

  @override
  String get modGravityWell => 'ಗುರುತ್ವ ಬಾವಿ';

  @override
  String get modChainSpark => 'ಸರಪಳಿ ಕಿಡಿ';

  @override
  String get paletteCyberpunk => 'ಸೈಬರ್‌ಪಂಕ್';

  @override
  String get paletteVaporwave => 'ವೇಪರ್‌ವೇವ್';

  @override
  String get paletteAcid => 'ಆಮ್ಲ';

  @override
  String get paletteMono => 'ಮೊನೊ';

  @override
  String get paletteEmber => 'ಕೆಂಡ';

  @override
  String get paletteArctic => 'ಆರ್ಕ್ಟಿಕ್';

  @override
  String get heatTier1 => 'ಶಾಖ I';

  @override
  String get heatTier2 => 'ಶಾಖ II';

  @override
  String get heatTier3 => 'ಶಾಖ III';

  @override
  String get heatTierOverdrive => 'ಓವರ್‌ಡ್ರೈವ್';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  ಕಾಂಬೊ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  ತಪ್ಪಿಸಿಕೊಂಡವು $escaped/$max';
  }

  @override
  String get weekly => 'ವಾರದ ಸವಾಲು';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ದಿನ ಬಾಕಿ',
      one: '1 ದಿನ ಬಾಕಿ',
      zero: 'ಕೊನೆಯ ದಿನ',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ವಾರದ ಅತ್ಯುತ್ತಮ · $score';
  }

  @override
  String get achievements => 'ಸಾಧನೆಗಳು';

  @override
  String get challenges => 'ಸವಾಲುಗಳು';

  @override
  String get share => 'ಹಂಚಿಕೊಳ್ಳಿ';

  @override
  String shareText(int score, String link) {
    return 'Puff ನಲ್ಲಿ ನನ್ನ ಹೊಸ ಅತ್ಯುತ್ತಮ ಸ್ಕೋರ್: $score. ನೀವು ಮೀರಿಸಬಲ್ಲಿರಾ? $link';
  }

  @override
  String get reducedFlashes => 'ಕಡಿಮೆ ಮಿನುಗು';

  @override
  String get paletteHoliday => 'ಹಬ್ಬ';
}
