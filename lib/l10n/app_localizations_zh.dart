// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get tagline => '按住 · 拖动 · 松开';

  @override
  String get play => '开始';

  @override
  String bestScore(int score) {
    return '最佳 · $score';
  }

  @override
  String get environmentTitle => '环境';

  @override
  String get modifierTitle => '模式';

  @override
  String get paletteTitle => '配色';

  @override
  String get leaderboard => '排行榜';

  @override
  String get settings => '设置';

  @override
  String get paused => '已暂停';

  @override
  String get resume => '继续';

  @override
  String get restart => '重新开始';

  @override
  String get nextTrack => '♪ 下一首';

  @override
  String get menu => '菜单';

  @override
  String get gameOver => '游戏结束';

  @override
  String get newBest => '新纪录！';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return '连击 x$combo   推开 $displaced   击碎 $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds秒';
  }

  @override
  String get again => '再来一局';

  @override
  String get quality => '画质';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMed => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get haptics => '振动';

  @override
  String get sound => '音效';

  @override
  String get music => '音乐';

  @override
  String get debugOverlay => '调试信息';

  @override
  String get back => '返回';

  @override
  String get on => '开';

  @override
  String get off => '关';

  @override
  String get envVacuum => '真空';

  @override
  String get envAir => '空气';

  @override
  String get envWater => '水';

  @override
  String get envPlasma => '等离子';

  @override
  String get modPressure => '压力';

  @override
  String get modImplosion => '内爆';

  @override
  String get modMagnet => '磁铁';

  @override
  String get modGravityWell => '引力井';

  @override
  String get modChainSpark => '连锁电火';

  @override
  String get paletteCyberpunk => '赛博朋克';

  @override
  String get paletteVaporwave => '蒸汽波';

  @override
  String get paletteAcid => '酸性';

  @override
  String get paletteMono => '单色';

  @override
  String get paletteEmber => '余烬';

  @override
  String get paletteArctic => '北极';

  @override
  String get heatTier1 => '热度 I';

  @override
  String get heatTier2 => '热度 II';

  @override
  String get heatTier3 => '热度 III';

  @override
  String get heatTierOverdrive => '超载';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  连击 $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  逃逸 $escaped/$max';
  }

  @override
  String get weekly => '每周挑战';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '剩余 $days 天',
      zero: '最后一天',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return '本周最佳 · $score';
  }

  @override
  String get achievements => '成就';

  @override
  String get challenges => '挑战';

  @override
  String get share => '分享';

  @override
  String shareText(int score, String link) {
    return '我在 Puff 的新纪录：$score。你能超过吗？$link';
  }

  @override
  String get reducedFlashes => '减少闪烁';

  @override
  String get paletteHoliday => '节日';

  @override
  String get supporter => '支持者';

  @override
  String get tipJar => '打赏';

  @override
  String get tipJarInfo => 'Puff 始终免费且无广告。打赏不会解锁任何内容，只是表达感谢，并在菜单中显示支持者徽章。';

  @override
  String get tipSmall => '小额打赏';

  @override
  String get tipMedium => '中额打赏';

  @override
  String get tipLarge => '大额打赏';

  @override
  String get tipThanks => '谢谢！';

  @override
  String get tipFailed => '购买未完成';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get tagline => '按住 · 拖曳 · 放開';

  @override
  String get play => '開始';

  @override
  String bestScore(int score) {
    return '最佳 · $score';
  }

  @override
  String get environmentTitle => '環境';

  @override
  String get modifierTitle => '模式';

  @override
  String get paletteTitle => '配色';

  @override
  String get leaderboard => '排行榜';

  @override
  String get settings => '設定';

  @override
  String get paused => '已暫停';

  @override
  String get resume => '繼續';

  @override
  String get restart => '重新開始';

  @override
  String get nextTrack => '♪ 下一首';

  @override
  String get menu => '選單';

  @override
  String get gameOver => '遊戲結束';

  @override
  String get newBest => '新紀錄！';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return '連擊 x$combo   推開 $displaced   擊碎 $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds秒';
  }

  @override
  String get again => '再來一局';

  @override
  String get quality => '畫質';

  @override
  String get qualityLow => '低';

  @override
  String get qualityMed => '中';

  @override
  String get qualityHigh => '高';

  @override
  String get haptics => '震動';

  @override
  String get sound => '音效';

  @override
  String get music => '音樂';

  @override
  String get debugOverlay => '除錯資訊';

  @override
  String get back => '返回';

  @override
  String get on => '開';

  @override
  String get off => '關';

  @override
  String get envVacuum => '真空';

  @override
  String get envAir => '空氣';

  @override
  String get envWater => '水';

  @override
  String get envPlasma => '電漿';

  @override
  String get modPressure => '壓力';

  @override
  String get modImplosion => '內爆';

  @override
  String get modMagnet => '磁鐵';

  @override
  String get modGravityWell => '重力井';

  @override
  String get modChainSpark => '連鎖電火';

  @override
  String get paletteCyberpunk => '賽博龐克';

  @override
  String get paletteVaporwave => '蒸氣波';

  @override
  String get paletteAcid => '酸性';

  @override
  String get paletteMono => '單色';

  @override
  String get paletteEmber => '餘燼';

  @override
  String get paletteArctic => '北極';

  @override
  String get heatTier1 => '熱度 I';

  @override
  String get heatTier2 => '熱度 II';

  @override
  String get heatTier3 => '熱度 III';

  @override
  String get heatTierOverdrive => '超載';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  連擊 $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  逃逸 $escaped/$max';
  }

  @override
  String get weekly => '每週挑戰';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '剩餘 $days 天',
      zero: '最後一天',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return '本週最佳 · $score';
  }

  @override
  String get achievements => '成就';

  @override
  String get challenges => '挑戰';

  @override
  String get share => '分享';

  @override
  String shareText(int score, String link) {
    return '我在 Puff 的新紀錄：$score。你能超越嗎？$link';
  }

  @override
  String get reducedFlashes => '減少閃爍';

  @override
  String get paletteHoliday => '節日';

  @override
  String get supporter => '支持者';

  @override
  String get tipJar => '打賞';

  @override
  String get tipJarInfo => 'Puff 始終免費且無廣告。打賞不會解鎖任何內容，只是表達感謝，並在選單中顯示支持者徽章。';

  @override
  String get tipSmall => '小額打賞';

  @override
  String get tipMedium => '中額打賞';

  @override
  String get tipLarge => '大額打賞';

  @override
  String get tipThanks => '謝謝！';

  @override
  String get tipFailed => '購買未完成';
}
