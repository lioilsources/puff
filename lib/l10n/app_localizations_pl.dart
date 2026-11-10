// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get tagline => 'przytrzymaj · przeciągnij · puść';

  @override
  String get play => 'GRAJ';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'ŚRODOWISKO';

  @override
  String get modifierTitle => 'MODYFIKATOR';

  @override
  String get paletteTitle => 'PALETA';

  @override
  String get leaderboard => 'RANKING';

  @override
  String get settings => 'USTAWIENIA';

  @override
  String get paused => 'PAUZA';

  @override
  String get resume => 'WZNÓW';

  @override
  String get restart => 'OD NOWA';

  @override
  String get nextTrack => '♪ NASTĘPNY UTWÓR';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'KONIEC GRY';

  @override
  String get newBest => 'NOWY REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   odepchnięte $displaced   rozbite $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'JESZCZE RAZ';

  @override
  String get quality => 'JAKOŚĆ';

  @override
  String get qualityLow => 'NISKA';

  @override
  String get qualityMed => 'ŚREDNIA';

  @override
  String get qualityHigh => 'WYSOKA';

  @override
  String get haptics => 'WIBRACJE';

  @override
  String get sound => 'DŹWIĘK';

  @override
  String get music => 'MUZYKA';

  @override
  String get debugOverlay => 'NAKŁADKA DEBUG';

  @override
  String get back => 'WSTECZ';

  @override
  String get on => 'WŁ.';

  @override
  String get off => 'WYŁ.';

  @override
  String get envVacuum => 'Próżnia';

  @override
  String get envAir => 'Powietrze';

  @override
  String get envWater => 'Woda';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Ciśnienie';

  @override
  String get modImplosion => 'Implozja';

  @override
  String get modMagnet => 'Magnes';

  @override
  String get modGravityWell => 'Studnia grawitacyjna';

  @override
  String get modChainSpark => 'Iskra łańcuchowa';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Kwas';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Żar';

  @override
  String get paletteArctic => 'Arktyka';

  @override
  String get heatTier1 => 'ŻAR I';

  @override
  String get heatTier2 => 'ŻAR II';

  @override
  String get heatTier3 => 'ŻAR III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  uciekło $escaped/$max';
  }

  @override
  String get weekly => 'WYZWANIE TYGODNIA';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'zostało $days dnia',
      many: 'zostało $days dni',
      few: 'zostały $days dni',
      one: 'został $days dzień',
      zero: 'ostatni dzień',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'najlepszy w tygodniu · $score';
  }

  @override
  String get achievements => 'OSIĄGNIĘCIA';

  @override
  String get challenges => 'WYZWANIA';

  @override
  String get share => 'UDOSTĘPNIJ';

  @override
  String shareText(int score, String link) {
    return 'Mój nowy rekord w Puff: $score. Pobijesz go? $link';
  }

  @override
  String get reducedFlashes => 'MNIEJ BŁYSKÓW';

  @override
  String get paletteHoliday => 'Świąteczna';
}
