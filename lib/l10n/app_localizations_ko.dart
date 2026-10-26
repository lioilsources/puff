// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get tagline => '누르기 · 끌기 · 놓기';

  @override
  String get play => '플레이';

  @override
  String bestScore(int score) {
    return '최고 · $score';
  }

  @override
  String get environmentTitle => '환경';

  @override
  String get modifierTitle => '모디파이어';

  @override
  String get paletteTitle => '팔레트';

  @override
  String get leaderboard => '순위표';

  @override
  String get settings => '설정';

  @override
  String get paused => '일시정지';

  @override
  String get resume => '계속';

  @override
  String get restart => '다시 시작';

  @override
  String get nextTrack => '♪ 다음 곡';

  @override
  String get menu => '메뉴';

  @override
  String get gameOver => '게임 오버';

  @override
  String get newBest => '최고 기록!';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return '콤보 x$combo   밀어냄 $displaced   파괴 $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds초';
  }

  @override
  String get again => '다시 하기';

  @override
  String get quality => '화질';

  @override
  String get qualityLow => '낮음';

  @override
  String get qualityMed => '보통';

  @override
  String get qualityHigh => '높음';

  @override
  String get haptics => '진동';

  @override
  String get sound => '효과음';

  @override
  String get music => '음악';

  @override
  String get debugOverlay => '디버그 표시';

  @override
  String get back => '뒤로';

  @override
  String get on => '켬';

  @override
  String get off => '끔';

  @override
  String get envVacuum => '진공';

  @override
  String get envAir => '공기';

  @override
  String get envWater => '물';

  @override
  String get envPlasma => '플라즈마';

  @override
  String get modPressure => '압력';

  @override
  String get modImplosion => '내파';

  @override
  String get modMagnet => '자석';

  @override
  String get modGravityWell => '중력 우물';

  @override
  String get modChainSpark => '연쇄 스파크';

  @override
  String get paletteCyberpunk => '사이버펑크';

  @override
  String get paletteVaporwave => '베이퍼웨이브';

  @override
  String get paletteAcid => '애시드';

  @override
  String get paletteMono => '모노';

  @override
  String get paletteEmber => '잉걸불';

  @override
  String get paletteArctic => '북극';

  @override
  String get heatTier1 => '히트 I';

  @override
  String get heatTier2 => '히트 II';

  @override
  String get heatTier3 => '히트 III';

  @override
  String get heatTierOverdrive => '오버드라이브';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  콤보 $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  탈출 $escaped/$max';
  }
}
