// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get tagline => 'tartsd · húzd · engedd el';

  @override
  String get play => 'JÁTÉK';

  @override
  String bestScore(int score) {
    return 'rekord · $score';
  }

  @override
  String get environmentTitle => 'KÖRNYEZET';

  @override
  String get modifierTitle => 'MÓDOSÍTÓ';

  @override
  String get paletteTitle => 'PALETTA';

  @override
  String get leaderboard => 'RANGLISTA';

  @override
  String get settings => 'BEÁLLÍTÁSOK';

  @override
  String get paused => 'SZÜNET';

  @override
  String get resume => 'FOLYTATÁS';

  @override
  String get restart => 'ÚJRAINDÍTÁS';

  @override
  String get nextTrack => '♪ KÖVETKEZŐ SZÁM';

  @override
  String get menu => 'MENÜ';

  @override
  String get gameOver => 'VÉGE A JÁTÉKNAK';

  @override
  String get newBest => 'ÚJ REKORD';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombó x$combo   eltolva $displaced   széttörve $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds mp';
  }

  @override
  String get again => 'ÚJRA';

  @override
  String get quality => 'MINŐSÉG';

  @override
  String get qualityLow => 'ALACSONY';

  @override
  String get qualityMed => 'KÖZEPES';

  @override
  String get qualityHigh => 'MAGAS';

  @override
  String get haptics => 'REZGÉS';

  @override
  String get sound => 'HANG';

  @override
  String get music => 'ZENE';

  @override
  String get debugOverlay => 'HIBAKERESŐ RÉTEG';

  @override
  String get back => 'VISSZA';

  @override
  String get on => 'BE';

  @override
  String get off => 'KI';

  @override
  String get envVacuum => 'Vákuum';

  @override
  String get envAir => 'Levegő';

  @override
  String get envWater => 'Víz';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Nyomás';

  @override
  String get modImplosion => 'Implózió';

  @override
  String get modMagnet => 'Mágnes';

  @override
  String get modGravityWell => 'Gravitációs kút';

  @override
  String get modChainSpark => 'Láncszikra';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Sav';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Parázs';

  @override
  String get paletteArctic => 'Sarkvidék';

  @override
  String get heatTier1 => 'HŐ I';

  @override
  String get heatTier2 => 'HŐ II';

  @override
  String get heatTier3 => 'HŐ III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombó $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  megszökött $escaped/$max';
  }

  @override
  String get weekly => 'HETI KIHÍVÁS';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'még $days nap',
      one: 'még 1 nap',
      zero: 'utolsó nap',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'a hét legjobbja · $score';
  }

  @override
  String get achievements => 'TELJESÍTMÉNYEK';

  @override
  String get challenges => 'KIHÍVÁSOK';

  @override
  String get share => 'MEGOSZTÁS';

  @override
  String shareText(int score, String link) {
    return 'Új rekordom a Puffban: $score. Meg tudod verni? $link';
  }

  @override
  String get reducedFlashes => 'KEVESEBB VILLANÁS';

  @override
  String get paletteHoliday => 'Ünnepi';
}
