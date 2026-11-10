// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get tagline => 'tahan · seret · lepas';

  @override
  String get play => 'MAIN';

  @override
  String bestScore(int score) {
    return 'terbaik · $score';
  }

  @override
  String get environmentTitle => 'PERSEKITARAN';

  @override
  String get modifierTitle => 'PENGUBAH SUAI';

  @override
  String get paletteTitle => 'PALET';

  @override
  String get leaderboard => 'PAPAN MARKAH';

  @override
  String get settings => 'TETAPAN';

  @override
  String get paused => 'DIJEDA';

  @override
  String get resume => 'SAMBUNG';

  @override
  String get restart => 'MULA SEMULA';

  @override
  String get nextTrack => '♪ LAGU SETERUSNYA';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'PERMAINAN TAMAT';

  @override
  String get newBest => 'REKOD BARU';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   teranjak $displaced   pecah $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds s';
  }

  @override
  String get again => 'LAGI';

  @override
  String get quality => 'KUALITI';

  @override
  String get qualityLow => 'RENDAH';

  @override
  String get qualityMed => 'SEDERHANA';

  @override
  String get qualityHigh => 'TINGGI';

  @override
  String get haptics => 'GETARAN';

  @override
  String get sound => 'BUNYI';

  @override
  String get music => 'MUZIK';

  @override
  String get debugOverlay => 'OVERLAY NYAHPEPIJAT';

  @override
  String get back => 'KEMBALI';

  @override
  String get on => 'HIDUP';

  @override
  String get off => 'MATI';

  @override
  String get envVacuum => 'Vakum';

  @override
  String get envAir => 'Udara';

  @override
  String get envWater => 'Air';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Tekanan';

  @override
  String get modImplosion => 'Implosi';

  @override
  String get modMagnet => 'Magnet';

  @override
  String get modGravityWell => 'Telaga graviti';

  @override
  String get modChainSpark => 'Percikan berantai';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Asid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Bara';

  @override
  String get paletteArctic => 'Artik';

  @override
  String get heatTier1 => 'HABA I';

  @override
  String get heatTier2 => 'HABA II';

  @override
  String get heatTier3 => 'HABA III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  terlepas $escaped/$max';
  }

  @override
  String get weekly => 'CABARAN MINGGUAN';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'tinggal $days hari',
      one: 'tinggal 1 hari',
      zero: 'hari terakhir',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'terbaik minggu ini · $score';
  }

  @override
  String get achievements => 'PENCAPAIAN';

  @override
  String get challenges => 'CABARAN';

  @override
  String get share => 'KONGSI';

  @override
  String shareText(int score, String link) {
    return 'Rekod baharu saya dalam Puff: $score. Boleh kalahkan? $link';
  }

  @override
  String get reducedFlashes => 'KURANGKAN KILATAN';

  @override
  String get paletteHoliday => 'Perayaan';
}
