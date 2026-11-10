// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get tagline => 'κράτα · σύρε · άφησε';

  @override
  String get play => 'ΠΑΙΞΕ';

  @override
  String bestScore(int score) {
    return 'ρεκόρ · $score';
  }

  @override
  String get environmentTitle => 'ΠΕΡΙΒΑΛΛΟΝ';

  @override
  String get modifierTitle => 'ΤΡΟΠΟΠΟΙΗΤΗΣ';

  @override
  String get paletteTitle => 'ΠΑΛΕΤΑ';

  @override
  String get leaderboard => 'ΒΑΘΜΟΛΟΓΙΑ';

  @override
  String get settings => 'ΡΥΘΜΙΣΕΙΣ';

  @override
  String get paused => 'ΠΑΥΣΗ';

  @override
  String get resume => 'ΣΥΝΕΧΕΙΑ';

  @override
  String get restart => 'ΕΠΑΝΕΚΚΙΝΗΣΗ';

  @override
  String get nextTrack => '♪ ΕΠΟΜΕΝΟ ΚΟΜΜΑΤΙ';

  @override
  String get menu => 'ΜΕΝΟΥ';

  @override
  String get gameOver => 'ΤΕΛΟΣ ΠΑΙΧΝΙΔΙΟΥ';

  @override
  String get newBest => 'ΝΕΟ ΡΕΚΟΡ';

  @override
  String gameOverStats(int combo, int displaced, int broken) {
    return 'κόμπο x$combo   μετατοπίστηκαν $displaced   έσπασαν $broken';
  }

  @override
  String gameOverRun(String environment, String modifier, String seconds) {
    return '$environment · $modifier · $seconds δ';
  }

  @override
  String get again => 'ΞΑΝΑ';

  @override
  String get quality => 'ΠΟΙΟΤΗΤΑ';

  @override
  String get qualityLow => 'ΧΑΜΗΛΗ';

  @override
  String get qualityMed => 'ΜΕΣΑΙΑ';

  @override
  String get qualityHigh => 'ΥΨΗΛΗ';

  @override
  String get haptics => 'ΔΟΝΗΣΗ';

  @override
  String get sound => 'ΗΧΟΣ';

  @override
  String get music => 'ΜΟΥΣΙΚΗ';

  @override
  String get debugOverlay => 'ΕΠΙΚΑΛΥΨΗ DEBUG';

  @override
  String get back => 'ΠΙΣΩ';

  @override
  String get on => 'ΕΝΕΡΓΟ';

  @override
  String get off => 'ΑΝΕΝΕΡΓΟ';

  @override
  String get envVacuum => 'Κενό';

  @override
  String get envAir => 'Αέρας';

  @override
  String get envWater => 'Νερό';

  @override
  String get envPlasma => 'Πλάσμα';

  @override
  String get modPressure => 'Πίεση';

  @override
  String get modImplosion => 'Εκρηκτική κατάρρευση';

  @override
  String get modMagnet => 'Μαγνήτης';

  @override
  String get modGravityWell => 'Πηγάδι βαρύτητας';

  @override
  String get modChainSpark => 'Αλυσιδωτός σπινθήρας';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteVaporwave => 'Vaporwave';

  @override
  String get paletteAcid => 'Acid';

  @override
  String get paletteMono => 'Mono';

  @override
  String get paletteEmber => 'Θράκα';

  @override
  String get paletteArctic => 'Αρκτική';

  @override
  String get heatTier1 => 'ΘΕΡΜΟΤΗΤΑ I';

  @override
  String get heatTier2 => 'ΘΕΡΜΟΤΗΤΑ II';

  @override
  String get heatTier3 => 'ΘΕΡΜΟΤΗΤΑ III';

  @override
  String get heatTierOverdrive => 'OVERDRIVE';

  @override
  String hudCombo(String multiplier, int combo) {
    return 'x$multiplier  κόμπο $combo';
  }

  @override
  String hudEscaped(String environment, int escaped, int max) {
    return '$environment  διέφυγαν $escaped/$max';
  }

  @override
  String get weekly => 'ΕΒΔΟΜΑΔΙΑΙΑ ΠΡΟΚΛΗΣΗ';

  @override
  String weeklyDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'απομένουν $days μέρες',
      one: 'απομένει 1 μέρα',
      zero: 'τελευταία μέρα',
    );
    return '$_temp0';
  }

  @override
  String weeklyBest(int score) {
    return 'καλύτερο εβδομάδας · $score';
  }

  @override
  String get achievements => 'ΕΠΙΤΕΥΓΜΑΤΑ';

  @override
  String get challenges => 'ΠΡΟΚΛΗΣΕΙΣ';

  @override
  String get share => 'ΚΟΙΝΟΠΟΙΗΣΗ';

  @override
  String shareText(int score, String link) {
    return 'Το νέο μου ρεκόρ στο Puff: $score. Μπορείς να το ξεπεράσεις; $link';
  }

  @override
  String get reducedFlashes => 'ΛΙΓΟΤΕΡΑ ΦΛΑΣ';

  @override
  String get paletteHoliday => 'Γιορτινή';
}
