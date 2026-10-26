// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get tagline => 'basılı tut · sürükle · bırak';

  @override
  String get play => 'OYNA';

  @override
  String bestScore(int score) {
    return 'rekor · $score';
  }

  @override
  String get environmentTitle => 'ORTAM';

  @override
  String get modifierTitle => 'DEĞİŞTİRİCİ';

  @override
  String get paletteTitle => 'PALET';

  @override
  String get leaderboard => 'SIRALAMA';

  @override
  String get settings => 'AYARLAR';

  @override
  String get paused => 'DURAKLATILDI';

  @override
  String get resume => 'DEVAM ET';

  @override
  String get restart => 'YENİDEN BAŞLAT';

  @override
  String get nextTrack => '♪ SONRAKİ PARÇA';

  @override
  String get menu => 'MENÜ';

  @override
  String get gameOver => 'OYUN BİTTİ';

  @override
  String get newBest => 'YENİ REKOR';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'kombo x$combo   itilen $displaced   kırılan $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds sn';
  }

  @override
  String get again => 'TEKRAR';

  @override
  String get quality => 'KALİTE';

  @override
  String get qualityLow => 'DÜŞÜK';

  @override
  String get qualityMed => 'ORTA';

  @override
  String get qualityHigh => 'YÜKSEK';

  @override
  String get haptics => 'TİTREŞİM';

  @override
  String get sound => 'SES';

  @override
  String get music => 'MÜZİK';

  @override
  String get debugOverlay => 'HATA AYIKLAMA';

  @override
  String get back => 'GERİ';

  @override
  String get on => 'AÇIK';

  @override
  String get off => 'KAPALI';

  @override
  String get envVacuum => 'Boşluk';

  @override
  String get envAir => 'Hava';

  @override
  String get envWater => 'Su';

  @override
  String get envPlasma => 'Plazma';

  @override
  String get modPressure => 'Basınç';

  @override
  String get modImplosion => 'İçe patlama';

  @override
  String get modMagnet => 'Mıknatıs';

  @override
  String get modGravityWell => 'Çekim kuyusu';

  @override
  String get modChainSpark => 'Zincirleme kıvılcım';

  @override
  String get paletteCyberpunk => 'Siberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Asit';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Kor';

  @override
  String get paletteArctic => 'Kutup';

  @override
  String get heatTier1 => 'ISI I';

  @override
  String get heatTier2 => 'ISI II';

  @override
  String get heatTier3 => 'ISI III';

  @override
  String get heatTierOverdrive => 'AŞIRI YÜK';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  kombo $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  kaçan $escaped/$max';
  }
}
