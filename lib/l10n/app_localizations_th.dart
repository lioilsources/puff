// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get tagline => 'กด · ลาก · ปล่อย';

  @override
  String get play => 'เล่น';

  @override
  String bestScore(int score) {
    return 'สถิติ · $score';
  }

  @override
  String get environmentTitle => 'สภาพแวดล้อม';

  @override
  String get modifierTitle => 'ตัวปรับแต่ง';

  @override
  String get paletteTitle => 'จานสี';

  @override
  String get leaderboard => 'อันดับ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get paused => 'หยุดชั่วคราว';

  @override
  String get resume => 'เล่นต่อ';

  @override
  String get restart => 'เริ่มใหม่';

  @override
  String get nextTrack => '♪ เพลงถัดไป';

  @override
  String get menu => 'เมนู';

  @override
  String get gameOver => 'จบเกม';

  @override
  String get newBest => 'สถิติใหม่';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'คอมโบ x$combo   ขยับ $displaced   แตก $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds วิ';
  }

  @override
  String get again => 'อีกครั้ง';

  @override
  String get quality => 'คุณภาพ';

  @override
  String get qualityLow => 'ต่ำ';

  @override
  String get qualityMed => 'กลาง';

  @override
  String get qualityHigh => 'สูง';

  @override
  String get haptics => 'การสั่น';

  @override
  String get sound => 'เสียง';

  @override
  String get music => 'เพลง';

  @override
  String get debugOverlay => 'โอเวอร์เลย์ดีบัก';

  @override
  String get back => 'กลับ';

  @override
  String get on => 'เปิด';

  @override
  String get off => 'ปิด';

  @override
  String get envVacuum => 'สุญญากาศ';

  @override
  String get envAir => 'อากาศ';

  @override
  String get envWater => 'น้ำ';

  @override
  String get envPlasma => 'พลาสมา';

  @override
  String get modPressure => 'แรงดัน';

  @override
  String get modImplosion => 'การระเบิดเข้าใน';

  @override
  String get modMagnet => 'แม่เหล็ก';

  @override
  String get modGravityWell => 'บ่อแรงโน้มถ่วง';

  @override
  String get modChainSpark => 'ประกายลูกโซ่';

  @override
  String get paletteCyberpunk => 'ไซเบอร์พังก์';

  @override
  String get paletteVaporwave => 'เวเปอร์เวฟ';

  @override
  String get paletteAcid => 'แอซิด';

  @override
  String get paletteMono => 'โมโน';

  @override
  String get paletteEmber => 'ถ่านไฟ';

  @override
  String get paletteArctic => 'อาร์กติก';

  @override
  String get heatTier1 => 'ความร้อน I';

  @override
  String get heatTier2 => 'ความร้อน II';

  @override
  String get heatTier3 => 'ความร้อน III';

  @override
  String get heatTierOverdrive => 'โอเวอร์ไดรฟ์';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  คอมโบ $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  หลุดรอด $escaped/$max';
  }

  @override
  String get weekly => 'ภารกิจประจำสัปดาห์';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'เหลือ $days วัน',
      one: 'เหลือ 1 วัน',
      zero: 'วันสุดท้าย',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'ดีที่สุดของสัปดาห์ · $score';
  }

  @override
  String get achievements => 'ความสำเร็จ';

  @override
  String get challenges => 'ความท้าทาย';

  @override
  String get share => 'แชร์';

  @override
  String shareText(int score, String link) {
    return 'สถิติใหม่ของฉันใน Puff: $score คุณทำลายได้ไหม $link';
  }

  @override
  String get reducedFlashes => 'ลดแสงวาบ';

  @override
  String get paletteHoliday => 'เทศกาล';
}
