// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get tagline => 'tahan · seret · lepas';

  @override
  String get play => 'MAIN';

  @override
  String bestScore(int score) {
    return 'terbaik · $score';
  }

  @override
  String get environmentTitle => 'LINGKUNGAN';

  @override
  String get modifierTitle => 'MODIFIER';

  @override
  String get paletteTitle => 'PALET';

  @override
  String get leaderboard => 'PAPAN PERINGKAT';

  @override
  String get settings => 'PENGATURAN';

  @override
  String get paused => 'DIJEDA';

  @override
  String get resume => 'LANJUT';

  @override
  String get restart => 'ULANG';

  @override
  String get nextTrack => '♪ LAGU BERIKUTNYA';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'GAME BERAKHIR';

  @override
  String get newBest => 'REKOR BARU';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   bergeser $displaced   pecah $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds dtk';
  }

  @override
  String get again => 'LAGI';

  @override
  String get quality => 'KUALITAS';

  @override
  String get qualityLow => 'RENDAH';

  @override
  String get qualityMed => 'SEDANG';

  @override
  String get qualityHigh => 'TINGGI';

  @override
  String get haptics => 'GETAR';

  @override
  String get sound => 'SUARA';

  @override
  String get music => 'MUSIK';

  @override
  String get debugOverlay => 'OVERLAY DEBUG';

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
  String get modGravityWell => 'Sumur gravitasi';

  @override
  String get modChainSpark => 'Percikan berantai';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Asam';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Bara';

  @override
  String get paletteArctic => 'Arktik';

  @override
  String get heatTier1 => 'PANAS I';

  @override
  String get heatTier2 => 'PANAS II';

  @override
  String get heatTier3 => 'PANAS III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  lolos $escaped/$max';
  }

  @override
  String get weekly => 'TANTANGAN MINGGUAN';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'sisa $days hari',
      one: 'sisa 1 hari',
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
  String get challenges => 'TANTANGAN';

  @override
  String get share => 'BAGIKAN';

  @override
  String shareText(int score, String link) {
    return 'Rekor baruku di Puff: $score. Bisa mengalahkannya? $link';
  }

  @override
  String get reducedFlashes => 'KURANGI KEDIP';

  @override
  String get paletteHoliday => 'Liburan';
}
