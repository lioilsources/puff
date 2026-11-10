// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get tagline => 'håll · dra · släpp';

  @override
  String get play => 'SPELA';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'MILJÖ';

  @override
  String get modifierTitle => 'MODIFIERARE';

  @override
  String get paletteTitle => 'PALETT';

  @override
  String get leaderboard => 'TOPPLISTA';

  @override
  String get settings => 'INSTÄLLNINGAR';

  @override
  String get paused => 'PAUSAT';

  @override
  String get resume => 'FORTSÄTT';

  @override
  String get restart => 'STARTA OM';

  @override
  String get nextTrack => '♪ NÄSTA LÅT';

  @override
  String get menu => 'MENY';

  @override
  String get gameOver => 'SPELET SLUT';

  @override
  String get newBest => 'NYTT REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   flyttade $displaced   krossade $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'IGEN';

  @override
  String get quality => 'KVALITET';

  @override
  String get qualityLow => 'LÅG';

  @override
  String get qualityMed => 'MEDEL';

  @override
  String get qualityHigh => 'HÖG';

  @override
  String get haptics => 'VIBRATION';

  @override
  String get sound => 'LJUD';

  @override
  String get music => 'MUSIK';

  @override
  String get debugOverlay => 'FELSÖKNINGSLAGER';

  @override
  String get back => 'TILLBAKA';

  @override
  String get on => 'PÅ';

  @override
  String get off => 'AV';

  @override
  String get envVacuum => 'Vakuum';

  @override
  String get envAir => 'Luft';

  @override
  String get envWater => 'Vatten';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Tryck';

  @override
  String get modImplosion => 'Implosion';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Gravitationsbrunn';

  @override
  String get modChainSpark => 'Kedjegnista';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Syra';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Glöd';

  @override
  String get paletteArctic => 'Arktis';

  @override
  String get heatTier1 => 'VÄRME I';

  @override
  String get heatTier2 => 'VÄRME II';

  @override
  String get heatTier3 => 'VÄRME III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  undkom $escaped/$max';
  }

  @override
  String get weekly => 'VECKANS UTMANING';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dagar kvar',
      one: '1 dag kvar',
      zero: 'sista dagen',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'veckans bästa · $score';
  }

  @override
  String get achievements => 'PRESTATIONER';

  @override
  String get challenges => 'UTMANINGAR';

  @override
  String get share => 'DELA';

  @override
  String shareText(int score, String link) {
    return 'Mitt nya rekord i Puff: $score. Kan du slå det? $link';
  }

  @override
  String get reducedFlashes => 'FÄRRE BLIXTAR';

  @override
  String get paletteHoliday => 'Högtid';
}
