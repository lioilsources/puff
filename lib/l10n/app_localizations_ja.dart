// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get tagline => '長押し · ドラッグ · はなす';

  @override
  String get play => 'プレイ';

  @override
  String bestScore(int score) {
    return 'ベスト · $score';
  }

  @override
  String get environmentTitle => '環境';

  @override
  String get modifierTitle => 'モディファイア';

  @override
  String get paletteTitle => 'パレット';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get settings => '設定';

  @override
  String get paused => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get restart => 'リスタート';

  @override
  String get nextTrack => '♪ 次の曲';

  @override
  String get menu => 'メニュー';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get newBest => 'ベスト更新！';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'コンボ x$combo   移動 $displaced   破壊 $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds秒';
  }

  @override
  String get again => 'もう一度';

  @override
  String get quality => '画質';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMed => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get haptics => '振動';

  @override
  String get sound => '効果音';

  @override
  String get music => '音楽';

  @override
  String get debugOverlay => 'デバッグ表示';

  @override
  String get back => '戻る';

  @override
  String get on => 'オン';

  @override
  String get off => 'オフ';

  @override
  String get envVacuum => '真空';

  @override
  String get envAir => '空気';

  @override
  String get envWater => '水';

  @override
  String get envPlasma => 'プラズマ';

  @override
  String get modPressure => '圧力';

  @override
  String get modImplosion => '爆縮';

  @override
  String get modMagnet => '磁力';

  @override
  String get modGravityWell => '重力井戸';

  @override
  String get modChainSpark => '連鎖スパーク';

  @override
  String get paletteCyberpunk => 'サイバーパンク';

  @override
  String get paletteVaporwave => 'ヴェイパーウェイヴ';

  @override
  String get paletteAcid => 'アシッド';

  @override
  String get paletteMono => 'モノ';

  @override
  String get paletteEmber => '残り火';

  @override
  String get paletteArctic => '北極';

  @override
  String get heatTier1 => 'ヒート I';

  @override
  String get heatTier2 => 'ヒート II';

  @override
  String get heatTier3 => 'ヒート III';

  @override
  String get heatTierOverdrive => 'オーバードライブ';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  コンボ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  脱出 $escaped/$max';
  }
}
