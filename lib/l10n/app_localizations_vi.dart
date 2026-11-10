// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get tagline => 'giữ · kéo · thả';

  @override
  String get play => 'CHƠI';

  @override
  String bestScore(int score) {
    return 'kỷ lục · $score';
  }

  @override
  String get environmentTitle => 'MÔI TRƯỜNG';

  @override
  String get modifierTitle => 'BỘ ĐIỀU CHỈNH';

  @override
  String get paletteTitle => 'BẢNG MÀU';

  @override
  String get leaderboard => 'BẢNG XẾP HẠNG';

  @override
  String get settings => 'CÀI ĐẶT';

  @override
  String get paused => 'TẠM DỪNG';

  @override
  String get resume => 'TIẾP TỤC';

  @override
  String get restart => 'CHƠI LẠI';

  @override
  String get nextTrack => '♪ BÀI TIẾP THEO';

  @override
  String get menu => 'MENU';

  @override
  String get gameOver => 'KẾT THÚC';

  @override
  String get newBest => 'KỶ LỤC MỚI';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'combo x$combo   đẩy đi $displaced   vỡ $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds giây';
  }

  @override
  String get again => 'LẠI';

  @override
  String get quality => 'CHẤT LƯỢNG';

  @override
  String get qualityLow => 'THẤP';

  @override
  String get qualityMed => 'VỪA';

  @override
  String get qualityHigh => 'CAO';

  @override
  String get haptics => 'RUNG';

  @override
  String get sound => 'ÂM THANH';

  @override
  String get music => 'NHẠC';

  @override
  String get debugOverlay => 'LỚP GỠ LỖI';

  @override
  String get back => 'QUAY LẠI';

  @override
  String get on => 'BẬT';

  @override
  String get off => 'TẮT';

  @override
  String get envVacuum => 'Chân không';

  @override
  String get envAir => 'Không khí';

  @override
  String get envWater => 'Nước';

  @override
  String get envPlasma => 'Plasma';

  @override
  String get modPressure => 'Áp suất';

  @override
  String get modImplosion => 'Nổ vào trong';

  @override
  String get modMagnet => 'Nam châm';

  @override
  String get modGravityWell => 'Giếng trọng lực';

  @override
  String get modChainSpark => 'Tia lửa dây chuyền';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Axit';

  @override
  String get paletteMono => 'Đơn sắc';

  @override
  String get paletteEmber => 'Than hồng';

  @override
  String get paletteArctic => 'Bắc Cực';

  @override
  String get heatTier1 => 'NHIỆT I';

  @override
  String get heatTier2 => 'NHIỆT II';

  @override
  String get heatTier3 => 'NHIỆT III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  combo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  thoát $escaped/$max';
  }

  @override
  String get weekly => 'THỬ THÁCH TUẦN';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'còn $days ngày',
      one: 'còn 1 ngày',
      zero: 'ngày cuối',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'tốt nhất tuần · $score';
  }

  @override
  String get achievements => 'THÀNH TÍCH';

  @override
  String get challenges => 'THỬ THÁCH';

  @override
  String get share => 'CHIA SẺ';

  @override
  String shareText(int score, String link) {
    return 'Kỷ lục mới của tôi trong Puff: $score. Bạn phá được không? $link';
  }

  @override
  String get reducedFlashes => 'GIẢM NHẤP NHÁY';

  @override
  String get paletteHoliday => 'Lễ hội';
}
